class nodesite::profiles::npm (
  $npm_package,
  $package_options,
  $node_version    = 'v0.10.25', #TODO: to params.pp
){



  contain nodesite::packages
  class  { 'nodesite::project':
    project_name    => $npm_package,
    package_options => $package_options,
  }
  # #
  # # Class['nodesite::appuser'] ->
  # # Class['nodesite::packages'] ->
  # # Class['nodesite::project']
}
