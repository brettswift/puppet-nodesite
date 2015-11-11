class nodesite::git_project (
    String $repo_dir,
    String $git_branch,
    String $git_uri,
    String $project_name,
  ){

  $project_dir = "${repo_dir}/${project_name}"

  $node_exec_dir='/usr/local/node/node-default/bin'

  nodesite::appuser {$project_name:}

  file { $repo_dir:
    ensure => directory,
  }

  # clone of depth =1, causes 'is_sycned_with_upstream' script to fail.
  exec { 'cloneProject':
    command => "/usr/bin/git clone ${git_uri}  &>>${project_name}_gitclone.log",
    cwd     => $repo_dir,
    creates => "${repo_dir}/${project_name}/.git/HEAD",
  }

  exec { 'git_branch':
    command => "/usr/bin/git checkout ${git_branch}",
    cwd     => $project_dir,
  }

  file { "${project_dir}/is_synced_with_upstream.sh":
    content => template('nodesite/is_synced_with_upstream.sh.erb'),
    mode    => '0755',
  }

  exec { 'check_for_redploy' :
    command => "/bin/echo `git log --pretty=%H ...refs/heads/${git_branch}^` > ${project_dir}/.cur_git_hash",
    unless  => "${project_dir}/is_synced_with_upstream.sh",
    notify  => Exec['pullProject'],
  }

  exec { 'pullProject':
    command     => "/usr/bin/git pull origin ${git_branch}",
    cwd         => $project_dir,
    refreshonly => true,
    # notify      => Nodesite::Service[$project_name],
    notify      => Service[$project_name],
  }

  #########################################
  #########################################
  #TODO: converge init.d scripts

  file {"/etc/init.d/${project_name}":
     content  => template('nodesite/init.d.erb'),
     mode     => '0755',
  }

  service { $project_name:
    ensure => running,
  }
  File["/etc/init.d/${project_name}"]->
  Service[$project_name]

  # nodesite::service { $project_name:
  #   user => $project_name,
  # }
  #########################################

  File[$repo_dir] ->
  Exec['cloneProject'] ->
  Exec['git_branch'] ->
  Exec['pullProject']
  # Nodesite::Service[$project_name]

}
