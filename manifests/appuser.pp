class nodesite::appuser {

  user { $nodesite::user:
    ensure  => present,
    comment => 'user for running nodesite nodejs apps',
    home    => "/home/${nodesite::user}",
    shell   => '/bin/bash',
  }

}
