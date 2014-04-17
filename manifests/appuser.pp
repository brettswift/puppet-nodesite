class nodesite::appuser {

  user { "${nodesite::user}":
    comment   => "user for running nodesite nodejs apps",
    home      => "/home/${nodesite::user}",
    ensure    => present,
    shell     => "/bin/bash",
  }

}