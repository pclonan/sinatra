# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "centos/7"
  config.vm.network "public_network", ip: "192.168.0.200"
  config.vm.provision "shell", inline: <<-SHELL
    rpm -ivh http://yum.puppetlabs.com/puppetlabs-release-el-7.noarch.rpm
    yum install -y puppet git
	# As we have no Puppet master, we will pull down the manifests and modules directories
	# from https://github.com/pclonan/sinatra.git, and store them in /etc/puppet
	cd /etc/puppet
	git init
	git remote add origin https://github.com/pclonan/sinatra.git
	git config core.sparsecheckout true
	echo -e "modules/*\nmanifests/*" >> .git/info/sparse-checkout
	git pull --depth=1 origin master
    puppet apply /etc/puppet/manifests/default.pp
  SHELL
end