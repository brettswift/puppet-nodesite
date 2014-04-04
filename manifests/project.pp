class nodesite::project(
		$git_uri 	 		= {},
		$git_branch		= 'master',
		$file_to_run	= 'app.js',
		$node_version = {},
		$user					= {},
		$npm_proxy		= {},
	){

	$nodesite_dir = "/usr/local/share/notesite_git_projects"
	# regex to get project name, used in folder
	$project_name_dirty = regsubst($git_uri, '^(.*[\\\/])', '')
	$project_name = regsubst($project_name_dirty, '.git', '')
	$project_dir = "$nodesite_dir/${project_name}"
	
	#defaults
	Class{ user => $user }
	Exec{ user => $user	}
	File{ owner => $user	}

	class { 'nvm_nodejs':
  	user    => $user,
  	version => $node_version,
	}

	file { "${nodesite_dir}":
		ensure => directory,
	}

	exec { "cloneProject":
		command => "/usr/bin/git clone --depth 1 $git_uri  &>>${project_name}_gitclone.log",
		cwd			=> "${$nodesite_dir}",
		creates => "${$nodesite_dir}/${project_name}_gitclone.log",
	}

	exec { "git_branch":
		command => "/usr/bin/git checkout ${git_branch}",
		cwd			=> $project_dir,
		# TODO: notify npm purge exec.
	}

	exec { "pullProject":
		command => "/usr/bin/git pull origin ${git_branch}",
		cwd			=> $project_dir,
	}

	exec { "setNpmProxy": 
		command 		=> "$nvm_nodejs::NPM_EXEC config set https-proxy $npm_proxy; $nvm_nodejs::NPM_EXEC config set proxy ${npm_proxy}",
		onlyif			=> "/bin/echo $http_proxy",
		user 				=> 'root',
	}

	#TODO take deployment commands from package.json, not just npm install.
	exec { "npmInstall":
		command => "$nvm_nodejs::NPM_EXEC install",
		cwd			=> $project_dir,
	}
	# init.d
	# file {"/etc/init.d/${project_name}":
 #    content => template('nodesite/init.d.erb'),
 #    mode 		=> 0755,
	# }
	#upstart
	file {"/etc/init/${project_name}.conf":
    content => template('nodesite/init.conf.erb'),
    mode 		=> 0644,
	}

	service { "${project_name}" :
		ensure 		=> running,
		provider 	=> upstart,
	}

	service { "iptables":
    enable => false,
    ensure => stopped,
  }

 	Class['nvm_nodejs'] -> 
	File["${nodesite_dir}"] -> 
	Exec['cloneProject'] -> 
	Exec['git_branch'] -> 
	Exec['pullProject'] -> 
	Exec['npmInstall'] -> 
	# Exec['runProject'] -> 
	File["/etc/init/${project_name}.conf"]-> 
	# File["/etc/init.d/${project_name}"]-> 
	Service["${project_name}"]
	
	$node_executable = $nvm_nodejs::NODE_EXEC

	info("##### ---------------->>> git URI:    $git_uri")
	info("##### ---------------->>> project name:    $project_name")
	info("node exe: $nvm_nodejs::NODE_EXEC")

}