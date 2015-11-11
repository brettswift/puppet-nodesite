define nodesite::appuser (
    $app_user = $title,
  ){

  user { $app_user:
    ensure  => present,
    comment => 'user for running nodesite nodejs apps',
    home    => "/home/${app_user}",
    shell   => '/sbin/nologin',
  }

}
