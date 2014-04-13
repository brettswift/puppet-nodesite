class nodesite::git (
		$repo_dir 		= $nodesite::repo_dir,
		$git_branch 	= $nodesite::git_branch,
		$git_uri			= $nodesite::git_uri,
	){
	include nodesite::project

	 # regex to get project name from uri, used in git and project resources
	 # this code is duplicated.. fix it. 
  $project_name_dirty = regsubst($git_uri, '^(.*[\\\/])', '')
  $project_name = regsubst($project_name_dirty, '.git', '')
  $project_dir = "${repo_dir}/${project_name}"


	file { "${repo_dir}":
		ensure => directory,
	}

	#clone of depth =1, causes 'is_sycned_with_upstream' script to fail.
	#TODO: support for tags
	exec { "cloneProject":
		command => "/usr/bin/git clone $git_uri  &>>${project_name}_gitclone.log",
		cwd			=> "${$repo_dir}",
		creates => "${$repo_dir}/${project_name}/.git/HEAD",
	}

	exec { "git_branch":
		command => "/usr/bin/git checkout ${git_branch}",
		cwd			=> $project_dir,
		# TODO: notify npm purge exec.
	}

	file { "${project_dir}/is_synced_with_upstream.sh":
		content 	=> template('nodesite/is_synced_with_upstream.sh.erb'),
		mode 			=> '0755',
	}

	exec { "check_for_redeploy": 
		command  	=> "echo `git log --pretty=%H ...refs/heads/${git_branch}^` > ${project_dir}/.cur_git_hash",
		unless 		=> "${project_dir}/is_synced_with_upstream.sh",
		notify 		=> Exec['pullProject'],
	}	

	exec { "pullProject":
		command 		=> "/usr/bin/git pull origin ${git_branch}",
		cwd					=> "${project_dir}",
		refreshonly => true,
		notify 			=> Class["nodesite::project"],
	}

	File["${repo_dir}"] -> 
	Exec['cloneProject'] -> 
	Exec['git_branch'] -> 
	Exec['pullProject']

}