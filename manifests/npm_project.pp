# $package_options used in erb template.
class nodesite::npm_project(
    String           $project_name,
    Optional[String] $user = '',
    Optional[String] $package_options,
  ){

  nodesite::appuser {$project_name:}

  file { "/usr/local/bin/${project_name}":
    ensure => 'link',
    target => "${node_exec_dir}/${project_name}"
  }

  package { $project_name:
    provider => npm,
  }

  file { "/var/log/${project_name}":
    ensure => 'directory',
    mode   => '0755',
  }

  nodesite::service { $project_name:
    user            => $project_name,
    package_options => $package_options,
  }

  info("Configuring npm project name:    ${project_name}")

  Package[$project_name]->
  File["/usr/local/bin/${project_name}"]->
  Nodesite::Service[$project_name]

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

}
