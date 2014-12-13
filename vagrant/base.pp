class { 'nodesite':
  passwd       =>'dummy password',
  git_uri      => 'test/uri',
  node_version => '0.10.0',
  $user        => 'nodeuser',
}
