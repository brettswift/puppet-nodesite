class nodesite::project(
    String           $project_name,
    Optional[String] $user = '',
    Optional[String] $package_options,
  ){
    #TODO: removed temporarily while npm package refactor happens. Replace for .git repo ?
    # $npm_proxy    = $nodesite::params::npm_proxy,
    # $repo_dir     = $nodesite::params::repo_dir,
    # $yaml_file    = $nodesite::yaml_file,
    # $yaml_entries = $nodesite::yaml_entries,

  # TODO: validate node version to: vX.X.X or latest or stable
  # validate_re($node_version, '^one$')

  $project_user = $project_name #erb templates are easier to read

  class { 'nodesite::appuser':
    app_user => $project_name,
  }
  # set by willdurand/nodejs module, used in templates to find location of gems
  $node_exec_dir='/usr/local/node/node-default/bin'

  #Put node and project on the path - init.d runs as sudo and sudoers secure_path prevents it from running
  file { '/usr/local/bin/node':
    ensure => 'link',
    target => "${node_exec_dir}/node"
  }
  file { "/usr/local/bin/${project_name}":
    ensure => 'link',
    target => "${node_exec_dir}/${project_name}"
  }

  class { 'nodejs' :
    version      => 'stable',
    make_install => false,
  }

  package { 'node-gyp':
    provider => npm,
    require  => Class['nodejs']
  }

  package { $project_name:
    provider => npm,
    require  => Class['nodejs']
  }

  # $https_proxy_cmd = "${node_exec_dir}/npm config set https-proxy ${npm_proxy}"
  # $http_proxy_cmd  = "${node_exec_dir}/npm config set proxy ${npm_proxy}"
  # if($npm_proxy){
  #   exec { 'setNpmProxy':
  #     command => "${https_proxy_cmd}; ${http_proxy_cmd};",
  #     onlyif  => "/bin/echo ${::http_proxy}",
  #     user    => 'root',
  #   }
  # }

  # TODO take deployment commands from package.json, not just npm install.
  # npm install moved to init startup scripts
  # exec { "npmInstall":
  #   # command => "$nvm_nodejs::NPM_EXEC install",
  #   command => "${node_exec_dir}/npm install",
  #   cwd      => $project_dir,
  #   # user     => 'root', ...? not as root.
  # }

  file {"/etc/init.d/${project_name}":
  # content => template('nodesite/init.d.erb'), #worked with git?
    content => template('nodesite/npm_init.d.erb'),
    mode    => '0755',
    notify  => Service[$project_name],
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

  #TODO: if not defined turn off?
  service { 'iptables':
    ensure => stopped,
    enable => false,
  }
  file { "/var/log/${project_name}":
    ensure => 'directory',
    mode   => '0755',
  }

  # https://github.com/rodjek/puppet-logrotate/issues/46
  # logrotate::rule { "${project_name}.err":
  #   path         => "/var/log/${project_name}.err",
  #   # rotate       => 14, # bug with future parser.  module may have a new owner soon.
  #   rotate_every => 'hour',
  # }
  #
  # logrotate::rule { "${project_name}.log":
  #   path         => "/var/log/${project_name}.log",
  #   # rotate       => 14, # bug with future parser.  module may have a new owner soon.
  #   olddir       => "/var/log/${project_name}",
  #   rotate_every => 'hour',
  # }

  info("Configuring project name:    ${project_name}")

  Class['nodejs']->
  Package[$project_name]->
  File["/usr/local/bin/${project_name}"]->
  File['/usr/local/bin/node']->
  File["/etc/init.d/${project_name}"]->
  Service[$project_name]

}
