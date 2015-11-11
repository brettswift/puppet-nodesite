class nodesite::profiles::git (
  $repo_dir    = $nodesite::params::repo_dir,
  $git_uri,
  $git_branch  = $nodesite::params::git_branch,
  $file_to_run = $nodesite::params::file_to_run,
) inherits nodesite::params {

  contain nodesite::packages
  contain nodesite::nodejs

  $project_name_dirty = regsubst($git_uri, '^(.*[\\\/])', '')
  $project_name       = regsubst($project_name_dirty, '.git', '')
  $project_dir        = "${repo_dir}/${project_name}"

  notice($project_name_dirty)
  notice($project_name)
  notice($project_dir)

  class {'nodesite::git_project':
    repo_dir  => $repo_dir,
    git_branch  => $git_branch,
    git_uri  =>   $git_uri,
    project_name  => $project_name,
  }
  # include nodesite::appuser
  # include nodesite::packages
  # include nodesite::git
  # include nodesite::project
  #
  #
  #
  # Class['nodesite::appuser'] ->
  # Class['nodesite::packages'] ->
  # Class['nodesite::git'] ->
  # Class['nodesite::project']

}
