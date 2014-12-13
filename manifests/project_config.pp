#Private Class - do not call outside nodesite directly.

class nodesite::project_config (
    $yaml_file    = undef,
    $yaml_entries = $nodesite::yaml_entries,
  ){

  define config_settings ($::value) {
    $config_file = $nodesite::project_config::yaml_file
    notify { $title:
      message => "Setting configuration: ${title}:  ${::value}\n",
    }

    yaml_setting { $title:
      target => $config_file,
      key    => $title,
      value  => $::value,
    }
  }

  create_resources(config_settings, $yaml_entries)

}
