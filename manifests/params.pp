class nodesite::params {
  $repo_dir     = '/usr/local/share/nodesite_repos'
  $git_branch   = 'master'
  $node_version = "stable" #"v0.10.26"
  $file_to_run  = 'app.js'
  # $user         = {}
  $npm_proxy    = ''
  $main_dir     = '/opt/nodesite'
  # $yaml_file    = undef  #relative path from git project root.
  # $yaml_entries = undef

  #private convenience param:
  # set by willdurand/nodejs module, used in templates to find location of gems
  $node_exec_dir='/usr/local/node/node-default/bin'
}
