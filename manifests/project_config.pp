class nodesite::project_config (
		$yaml_file	 	= $nodesite::yaml_file,
		$yaml_entries	= $nodesite::yaml_entries,
	){
	$config_file = "{$nodesite::project_dir}/${yaml_file}"

	define config_settings ($value) {
	  notify { "${title}":
	    message => "Setting configuration: ${title}:  ${value}\n",
	  }

	  yaml_setting { $title:
	   target => $config_file,
	   key    => $title,
	   value  => $value,
	  }
	}

	create_resources(config_settings, $key_pairs)

}