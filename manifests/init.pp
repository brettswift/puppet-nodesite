# TODO: unit tests!
# TODO: documentation
# yaml_entries should be in the format:


#   $key_pairs = {
#     "value/animal/type" => { value => 'donkey'   },
#     "value/animal/name" => { value => 'ee-ore'   },
#     "value/animal/colors" => { value => ['grey','black','white', {'painted' => ['red','blue']}]   },
#   }

# Exec { path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/' ] }

class nodesite (
    $git_uri      = {},
    $git_branch   = 'master',
    $node_version = {},
    $file_to_run  = 'app.js',
    $user         = {},
    $npm_proxy    = '',
    $main_dir     = '/opt/nodesite',
    $yaml_file    = undef,  #relative path from git project root.
    $yaml_entries = undef,
){

  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }
  include nodesite::appuser
  include nodesite::packages
  include nodesite::git
  include nodesite::project



  Class['nodesite::appuser'] ->
  Class['nodesite::packages'] ->
  Class['nodesite::git'] ->
  Class['nodesite::project']

}
