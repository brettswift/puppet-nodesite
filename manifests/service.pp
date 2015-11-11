define nodesite::service (
  String           $project_name = $title,
  Optional[String] $user = '',
  Optional[String] $package_options = '',
){

  $node_exec_dir = $nodesite::params::node_exec_dir
  $project_user = $project_name #erb templates are easier to read


  file {"/etc/init.d/${project_name}":
  # content => template('nodesite/init.d.erb'), #worked with git?
    content => template('nodesite/npm_init.d.erb'),
    mode    => '0755',
    notify  => Service[$project_name],
  }

  service { $project_name:
    ensure => running,
  }

  #TODO: open required ports
  if ! defined(Service['iptables']) {
    service { 'iptables':
      ensure => stopped,
      enable => false,
    }
  }
}
