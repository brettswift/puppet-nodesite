class nodesite::nodejs (
    $node_version = $nodesite::params::node_version,
  ) inherits nodesite::params {


    #Put node and project on the path - init.d runs as sudo and sudoers secure_path prevents it from running
    file { '/usr/local/bin/node':
      ensure => 'link',
      target => "${nodesite::params::node_exec_dir}/node"
    }

    class { 'nodejs' :
      version      => $node_version,
      make_install => false,
    }

    package { 'node-gyp':
      provider => npm,
      require  => Class['nodejs']
    }

}
