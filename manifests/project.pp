class nodesite::project(
		$git_uri 	 		= $nodesite::git_uri,
		$git_branch		= $nodesite::git_branch,
		$file_to_run	= $nodesite::file_to_run,
		$node_version = $nodesite::node_version,
		$user					= $nodesite::user,
		$npm_proxy		= $nodesite::npm_proxy,
		$repo_dir 		= $nodesite::repo_dir,
		$node_params 	= $nodesite::node_params,
	){

	# TODO: validate node version to: vX.X.X or latest or stable
	# validate_re($node_version, '^one$')

	# regex to get project name from uri, used in git and project resources
  $project_name_dirty = regsubst($git_uri, '^(.*[\\\/])', '')
  $project_name = regsubst($project_name_dirty, '.git', '')
  $project_dir = "$repo_dir/${project_name}"

  #set by willdurand/nodejs module
  $node_exec_dir = '/usr/local/node/node-default/bin'
	
	if $node_params{
		# $inline_node_params = join($node_params,"-- ") future parser only
		$inline_node_params = "--${node_params}"
	}
	
	class { 'nodejs':
	  version      => 'stable',
	  make_install => false,
	}

	package { 'node-gyp':
  	provider => npm
	}
 	
 	# TODO: support proxy
	if($npm_proxy){
		exec { "setNpmProxy": 
			command 		=> "${node_exec_dir}/npm config set https-proxy $npm_proxy; ${node_exec_dir}/npm config set proxy ${npm_proxy}",
			onlyif			=> "/bin/echo $http_proxy",
			user 				=> 'root',
		}
	}

	#TODO take deployment commands from package.json, not just npm install.
	# npm install moved to init startup scripts
	# exec { "npmInstall":
	# 	# command => "$nvm_nodejs::NPM_EXEC install",
	# 	command => "${node_exec_dir}/npm install",
	# 	cwd			=> $project_dir,
	# 	user 		=> 'root', #TODO: not as root. 
	# }

	if $::puppetversion >= '3.5.0' {
	  $supports_upstart = true
	} else {
	  $supports_upstart = false
	}

	#ugly if condition, but early support for upstart on rhel
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

	service { "iptables":
    enable => false,
    ensure => stopped,
  }
	
	info("Configuring project name:    $project_name")

}