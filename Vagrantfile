# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "centos/7"
  config.vm.network "public_network", ip: "192.168.0.200"
  config.vm.provision "shell", inline: <<-SHELL
    rpm -ivh http://yum.puppetlabs.com/puppetlabs-release-el-7.noarch.rpm
    yum install -y puppet
    puppet apply --modulepath=/home/vagrant/sync/modules /home/vagrant/sync/manifests/default.pp
  SHELL
  config.vm.provision "puppet" do |puppet|
    puppet.module_path = "modules"
    puppet.manifests_path = "manifests"
    puppet.hiera_config_path = "hiera.yaml"
  end
end
