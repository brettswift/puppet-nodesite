class nodesite::config (){



  #.git profile only?
  if($yaml_entries){
    class {'nodesite::project_config':
      yaml_entries => $yaml_entries,
      yaml_file    => "${project_dir}/${yaml_file}",
    }
    anchor { 'nodesite::project_config::start': }->
    Class['nodesite::project_config']->
    Service[$project_name]->
    anchor { 'nodesite::project_config::end': }
  }


    #TODO: removed temporarily while npm package refactor happens. Replace for .git repo ?
    # $npm_proxy    = $nodesite::params::npm_proxy,
    # $repo_dir     = $nodesite::params::repo_dir,
    # $yaml_file    = $nodesite::yaml_file,
    # $yaml_entries = $nodesite::yaml_entries,

  # TODO: validate node version to: vX.X.X or latest or stable
  # validate_re($node_version, '^one$')


    # $https_proxy_cmd = "${nodesite::params::node_exec_dir}/npm config set https-proxy ${npm_proxy}"
    # $http_proxy_cmd  = "${nodesite::params::node_exec_dir}/npm config set proxy ${npm_proxy}"
    # if($npm_proxy){
    #   exec { 'setNpmProxy':
    #     command => "${https_proxy_cmd}; ${http_proxy_cmd};",
    #     onlyif  => "/bin/echo ${::http_proxy}",
    #     user    => 'root',
    #   }
    # }

    # TODO take deployment commands from package.json, not just npm install.
    # npm install moved to init startup scripts
    # exec { "npmInstall":
    #   # command => "$nvm_nodejs::NPM_EXEC install",
    #   command => "${node_exec_dir}/npm install",
    #   cwd      => $project_dir,
    #   # user     => 'root', ...? not as root.
    # }

}
