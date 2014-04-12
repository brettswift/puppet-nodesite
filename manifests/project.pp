class nodesite::project(
		$git_uri 	 		= $nodesite::git_uri,
		$git_branch		= $nodesite::git_branch,
		$file_to_run	= $nodesite::file_to_run,
		$node_version = $nodesite::node_version,
		$user					= $nodesite::user,
		$npm_proxy		= $nodesite::npm_proxy,
		$repo_dir 		= $nodesite::repo_dir,
	){


	# regex to get project name from uri, used in git and project resources
  $project_name_dirty = regsubst($git_uri, '^(.*[\\\/])', '')
  $project_name = regsubst($project_name_dirty, '.git', '')
  $project_dir = "$repo_dir/${project_name}"

	
	#defaults
	Class{ user => $user }
	Exec{ user => $user	}
	File{ owner => $user	}

	class { 'nvm_nodejs':
  	user    => $user,
  	version => $node_version,
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
		user 		=> 'root', #TODO: not as root. 
	}

	if $::puppetversion >= '3.5.0' {
	  $supports_upstart = true
	} else {
	  $supports_upstart = false
	}

	#ugly, but early support for upstart on rhel
	#TODO: move to service_35.pp and service_34?
	if $supports_upstart {
		info("Configuring $project_name with upstart")
		file {"/etc/init/${project_name}.conf":
	    content => template('nodesite/init.conf.erb'),
	    mode 		=> 0644,
		}

		service { "${project_name}":
			ensure 		=> running,
			provider 	=> upstart,
		}

		File["/etc/init/${project_name}.conf"]-> 
		Service["${project_name}"]


	} else {
		info("Configuring $project_name with sysv ")
		file {"/etc/init.d/${project_name}":
	    content => template('nodesite/init.d.erb'),
	    mode 		=> 0755,
		}

		service { "${project_name}": 
			ensure => running,
		}

		File["/etc/init.d/${project_name}"]-> 
		Service["${project_name}"]
	}

	#puppet <3.5 requires more verbose configuration
	 # service { "${project_name}":
  #   ensure    => 'running',
  #   hasstatus => false,
  #   pattern   => "${project_name}/${file_to_run}",
  #   restart   => "/sbin/restart ${project_name}",
  #   start     => "/sbin/start ${project_name}",
  #   stop      => "/sbin/stop ${project_name}",
  # }

	service { "iptables":
    enable => false,
    ensure => stopped,
  }

 	Class['nvm_nodejs'] -> 
	Exec['npmInstall']
	
	info("Configuring project name:    $project_name")
	info("Using node exe: $nvm_nodejs::NODE_EXEC")

}