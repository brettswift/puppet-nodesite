class nodesite::profiles::npm (
  $npm_package,
  $package_options,
){

  contain nodesite::packages
  contain nodesite::nodejs

  class  { 'nodesite::npm_project':
    project_name    => $npm_package,
    package_options => $package_options,
  }

  Class['nodesite::packages'] ->
  Class['nodesite::nodejs'] ->
  Class['nodesite::npm_project']
}
