class nodesite::appuser (
    $app_user = 'nodesite',
  ){

  user { $app_user:
    ensure  => present,
    comment => 'user for running nodesite nodejs apps',
    home    => "/home/${app_user}",
    shell   => '/bin/bash',
  }

}
