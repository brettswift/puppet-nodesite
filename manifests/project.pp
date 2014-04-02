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

	
	class { 'nvm_nodejs':
  	user    => $user,
  	version => $nodeVersion,
	}

	file { "/tmp/gitProjects":
		ensure => directory,
	}

	exec { "cloneProject":
		command => "/usr/bin/git clone --depth 1 $gitUri  &>>$projectName.log",
		cwd			=> "/tmp/gitProjects",
		creates => "/tmp/gitProjects/$projectName.log",
	}

	exec { "gitBranch":
		command => "/usr/bin/git checkout $gitBranch",
		cwd			=> "/tmp/gitProjects/$projectName",
		# TODO: notify npm purge exec.
	}

	exec { "pullProject":
		command => "/usr/bin/git pull origin $gitBranch",
		cwd			=> "/tmp/gitProjects/$projectName",
	}

	exec { "setNpmProxy": 
		command 		=> "$nvm_nodejs::NPM_EXEC config set https-proxy $npmProxy; $nvm_nodejs::NPM_EXEC config set proxy $npmProxy",
		user				=> "root",
		onlyif			=> "/bin/echo $http_proxy",
	}

	exec { "npmInstall":
		command => "$nvm_nodejs::NPM_EXEC install",
		cwd			=> "/tmp/gitProjects/$projectName",
	}

	# TODO: change to service - create init.d service template? use "forever"? 
	exec { "runProject":
		command => "$nvm_nodejs::NODE_EXEC $fileToRun &",
		cwd			=> "/tmp/gitProjects/$projectName",
	}

 	Class['nvm_nodejs'] -> 
	File['/tmp/gitProjects'] -> 
	Exec['cloneProject'] -> 
	Exec['gitBranch'] -> 
	Exec['pullProject'] -> 
	Exec['npmInstall'] -> 
	Exec['runProject']

	info("##### ---------------->>> git URI:    $gitUri")
	info("##### ---------------->>> project name:    $projectName")
	info("node exe: $nvm_nodejs::NODE_EXEC")

}