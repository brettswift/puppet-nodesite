class nodesite::git (
		$repo_dir 		= $nodesite::repo_dir,
		$git_branch 	= $nodesite::git_branch,
		$git_uri			= $nodesite::git_uri,
	){

	 # regex to get project name from uri, used in git and project resources
	 # this code is duplicated.. fix it. 
  $project_name_dirty = regsubst($git_uri, '^(.*[\\\/])', '')
  $project_name = regsubst($project_name_dirty, '.git', '')
  $project_dir = "$repo_dir/${project_name}"


	file { "${repo_dir}":
		ensure => directory,
	}

	info("/usr/bin/git clone --depth 1 $git_uri  &>>${project_name}_gitclone.log")
	exec { "cloneProject":
		command => "/usr/bin/git clone --depth 1 $git_uri  &>>${project_name}_gitclone.log",
		cwd			=> "${$repo_dir}",
		creates => "${$repo_dir}/${project_name}/.git/HEAD",
	}

	exec { "git_branch":
		command => "/usr/bin/git checkout ${git_branch}",
		cwd			=> $project_dir,
		# TODO: notify npm purge exec.
	}

	exec { "pullProject":
		command => "/usr/bin/git pull origin ${git_branch}",
		cwd			=> $project_dir,
	}

	File["${repo_dir}"] -> 
	Exec['cloneProject'] -> 
	Exec['git_branch'] -> 
	Exec['pullProject']

}