# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "centos/7"
  config.vm.network "public_network"
  config.vm.provision "shell", inline: <<-SHELL
    rpm -ivh http://yum.puppetlabs.com/puppetlabs-release-el-7.noarch.rpm
  SHELL
  config.vm.provision "puppet" do |puppet|
    puppet.module_path = "modules"
    puppet.manifests_path = "manifests"
    puppet.hiera_config_path = "hiera.yaml"
end
