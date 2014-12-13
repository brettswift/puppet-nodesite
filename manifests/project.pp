class nodesite::project(
    $git_uri      = $nodesite::git_uri,
    $git_branch   = $nodesite::git_branch,
    $file_to_run  = $nodesite::file_to_run,
    $node_version = $nodesite::node_version,
    $user         = $nodesite::user,
    $npm_proxy    = $nodesite::npm_proxy,
    $repo_dir     = $nodesite::repo_dir,
    $yaml_file    = $nodesite::yaml_file,
    $yaml_entries = $nodesite::yaml_entries,
  ){

  # TODO: validate node version to: vX.X.X or latest or stable
  # validate_re($node_version, '^one$')

  #regex to get project name from uri, used in git and project resources
  $project_name_dirty = regsubst($git_uri, '^(.*[\\\/])', '')
  $project_name       = regsubst($project_name_dirty, '.git', '')
  $project_dir        = "${repo_dir}/${project_name}"

  # set by willdurand/nodejs module
  $node_exec_dir = '/usr/local/node/node-default/bin'

  class { 'nodejs' :
    version      => 'stable',
    make_install => false,
  }

  package { 'node-gyp':
    provider => npm
  }

  $https_proxy_cmd = "${node_exec_dir}/npm config set https-proxy ${npm_proxy}"
  $http_proxy_cmd  = "${node_exec_dir}/npm config set proxy ${npm_proxy}"
  if($npm_proxy){
    exec { 'setNpmProxy':
      command => "${https_proxy_cmd}; ${http_proxy_cmd};",
      onlyif  => "/bin/echo ${::http_proxy}",
      user    => 'root',
    }
  }

  # TODO take deployment commands from package.json, not just npm install.
  # npm install moved to init startup scripts
  # exec { "npmInstall":
  #   # command => "$nvm_nodejs::NPM_EXEC install",
  #   command => "${node_exec_dir}/npm install",
  #   cwd      => $project_dir,
  #   # user     => 'root', ...? not as root.
  # }

  file {"/etc/init.d/${project_name}":
    content => template('nodesite/init.d.erb'),
    mode    => '0755',
  }


  if($yaml_entries){
    class {'nodesite::project_config':
      yaml_entries => $yaml_entries,
      yaml_file    => "${project_dir}/${yaml_file}",
    }

    anchor { 'nodesite::project_config::start': }->
    Class['nodesite::project_config']->
    Service[$project_name]->
    anchor { 'nodesite::project_config::end': }

  }


  service { $project_name:
    ensure => running,
  }

  File["/etc/init.d/${project_name}"]->
  Service[$project_name]

  service { 'iptables':
    ensure => stopped,
    enable => false,
  }

  info("Configuring project name:    ${project_name}")

}
