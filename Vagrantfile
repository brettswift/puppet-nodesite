
module_name = 'nodesite' #as required to appear in the module_path

Vagrant.configure("2") do |config|
  config.vm.define module_name do |node_config|
    node_config.vm.box = "centos-65-x64-virtualbox-puppet"
    node_config.vm.box_url = "http://puppet-vagrant-boxes.puppetlabs.com/centos-65-x64-virtualbox-puppet.box"

    node_config.vm.host_name = module_name
    node_config.ssh.forward_agent = true
    node_config.vm.network :private_network, ip: '172.1.1.10'  # let this automatically assign?

    node_config.vm.provider :virtualbox do |vb|
        vb.customize [
            'modifyvm', :id,
            '--name', module_name,
            '--memory', '512'
          ]
    end

    parent_dir =  Dir.pwd
    config.vm.synced_folder parent_dir, "/tmp/modules/#{module_name}"

    node_config.vm.provision :puppet do |puppet|
      puppet.manifests_path      = "vagrant"
      puppet.manifest_file       = "base.pp"
      puppet.hiera_config_path   = "vagrant/hiera.yaml"
      puppet.working_directory   = "/tmp/vagrant-puppet-2/manifests"
      puppet.options             = ["--modulepath=/tmp/modules:/vagrant/modules:/etc/puppetlabs/puppet/modules",
                                    "--verbose",
                                    "--trace"]
    end

  end
end
