class nodesite::project(
		$gitUri 	 		= {},
		$gitBranch		= 'master',
		$fileToRun 		= 'app.js',
		$nodeVersion 	= {},
		$user					= {},
		$npmProxy			= {},
	){
	# require nodesite::nvm

	$projectDir = "/tmp/gitProjects"
	# regex to get project name, used in folder
	$projectNameDirty = regsubst($gitUri, '^(.*[\\\/])', '')
	$projectName = regsubst($projectNameDirty, '.git', '')
	$projectDir_cwd = "$projectDir/${projectName}"
	
	#defaults
	Class{ user => $user }
	Exec{ user => $user	}
	File{ owner => $user	}

	class { 'nvm_nodejs':
  	user    => $user,
  	version => $nodeVersion,
	}

	file { "${projectDir}":
		ensure => directory,
	}

	exec { "cloneProject":
		command => "/usr/bin/git clone --depth 1 $gitUri  &>>${projectName}.log",
		cwd			=> "/tmp/gitProjects",
		creates => "/tmp/gitProjects/${projectName}.log",
	}

	exec { "gitBranch":
		command => "/usr/bin/git checkout ${gitBranch}",
		cwd			=> $projectDir_cwd,
		# TODO: notify npm purge exec.
	}

	exec { "pullProject":
		command => "/usr/bin/git pull origin ${gitBranch}",
		cwd			=> $projectDir_cwd,
	}

	exec { "setNpmProxy": 
		command 		=> "$nvm_nodejs::NPM_EXEC config set https-proxy $npmProxy; $nvm_nodejs::NPM_EXEC config set proxy ${npmProxy}",
		onlyif			=> "/bin/echo $http_proxy",
		user 				=> 'root',
	}

	exec { "npmInstall":
		command => "$nvm_nodejs::NPM_EXEC install",
		cwd			=> $projectDir_cwd,
	}

	# TODO: change to service - create init.d service template? use "forever"? 
	# exec { "runProject":
	# 	command => "$nvm_nodejs::NODE_EXEC $fileToRun &",
	# 	cwd			=> $projectDir_cwd,
	# 	user 		=> $user,
	# }

	file {"/etc/init.d/${projectName}":
    content => template('nodesite/init.d.erb'),
    mode 		=> 0755,
	}

	service { "${projectName}" :
		ensure => running,
	}

 	Class['nvm_nodejs'] -> 
	File['/tmp/gitProjects'] -> 
	Exec['cloneProject'] -> 
	Exec['gitBranch'] -> 
	Exec['pullProject'] -> 
	Exec['npmInstall'] -> 
	# Exec['runProject'] -> 
	File["/etc/init.d/${projectName}"]-> 
	Service["${projectName}"]
	
	$node_executable = $nvm_nodejs::NODE_EXEC

	info("##### ---------------->>> git URI:    $gitUri")
	info("##### ---------------->>> project name:    $projectName")
	info("node exe: $nvm_nodejs::NODE_EXEC")

}