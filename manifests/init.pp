# TODO: unit tests!
Exec { path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/' ] }

class nodesite (
    $git_uri        = {},
    $git_branch     = 'module_default',
    $node_version   = {},
    $file_to_run    = 'module_default',
    $user           = {},
    $npm_proxy      = '',
    $repo_dir       = 'module_default',
    $yaml_file      = undef,  #relative path from git project root.
    $yaml_entries   = undef,
){

  include nodesite::appuser
  include nodesite::packages
  include nodesite::git
  include nodesite::project



  Class['nodesite::appuser'] ->
  Class['nodesite::packages'] ->
  Class['nodesite::git'] ->
  Class['nodesite::project']

}
