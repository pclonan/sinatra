# The Simple Sinatra App for REA Group

The following process describes the deployment of REA Group's Simple Sinatra app.<br>
https://github.com/rea-cruitment/simple-sinatra-app

Prerequisites
---------------
* Vagrant (https://www.vagrantup.com)
* VirtualBox (https://www.virtualbox.org)
* A Git client (eg: https://git-scm.com)

Installation
---------------
    git clone git://github.com/pclonan/sinatra
    cd sinatra
    vagrant up

When the "vagrant up" process has completed, you will see the location of the running Sinatra app:<br>

    ==> default: Notice: Sinatra app: http://192.168.0.200

Descripton
---------------
The O/S chosen for this deployment is CentOS 7.2. (https://app.vagrantup.com/centos/boxes/7)<br>
The O/S deployment tool chosen for this project is Vagrant - deploying on to VirtualBox.<br>

Puppet has been chosen as the configuration orchestration tool, and will be responsible for the configuration and hardening of the O/S, as well as the installation of the Simple Sinatra application.<br>

The Ruby version chosen is 2.4, and is installed from the CentOS Software Collections repository. The reason behind this decision was to allow Puppet to install these packages using the native yum tools (as opposed to using RVM, or manually compiling).<br>

The Simple Sinatra app has been configured as a service. This allow Puppet to easily start/stop/restart the app, if required. It also allows for the application owner (in this case, user "sinatra") to start/stop/restart the app using systemctl (via sudo):

    [root@localhost ~]# sudo -lU sinatra
    Matching Defaults entries for sinatra on this host:
    !visiblepw, always_set_home, env_reset, env_keep="COLORS DISPLAY HOSTNAME HISTSIZE INPUTRC KDEDIR LS_COLORS", env_keep+="MAIL PS1 PS2 QTDIR USERNAME LANG LC_ADDRESS LC_CTYPE",
    env_keep+="LC_COLLATE LC_IDENTIFICATION LC_MEASUREMENT LC_MESSAGES", env_keep+="LC_MONETARY LC_NAME LC_NUMERIC LC_PAPER LC_TELEPHONE", env_keep+="LC_TIME LC_ALL LANGUAGE LINGUAS
    _XKB_CHARSET XAUTHORITY", secure_path=/sbin\:/bin\:/usr/sbin\:/usr/bin

    User sinatra may run the following commands on this host:
    (root) /usr/bin/systemctl start sinatra, /usr/bin/systemctl stop sinatra, /usr/bin/systemctl status sinatra

Once the O/S has been deployed, Puppet is installed. This is done via the <b>config.vm.provision "shell"</b> option within the Vagrantfile.<br>

Although the complete installation could be managed from within the <b>config.vm.provision "shell"</b> section of the Vagrant file, the decision has been made to offload these tasks to Puppet. The reasons behind this decision are:
- It does not lock us in to using Vagrant for the application installation, but instead, only for the initial O/S installation.
- We can download this Puppet manifest on to another CentOS 7 build (AWS, bare-metal, etc), and expect the exact same outcome (i.e. Simple Sinatra app running on a hardend O/S)
- The idempotent nature of Puppet allows us to rerun the code without damaging the application - whilst at the same time, running newly commited Git modules.

The <b>config.vm.provision "shell"</b> option also initiates the first Puppet run, which uses modules included in this Git repo. These modules are synced to /home/vagrant/sync as part of the Vagrant provisioning process:

    .
    ├── manifests
    │   └── default.pp
    ├── modules
    │   ├── git
    │   ├── iptables
    │   ├── osharden
    │   ├── puppet-cron
    │   ├── ruby
    │   ├── sinatraservice
    │   ├── ssh
    │   ├── sudo
    │   ├── users
    │   └── vcsrepo
    ├── README.md
    └── Vagrantfile

However, as there is no Puppet master in this environment, each subsequent Puppet run is controlled via cron. The script "/etc/puppet/rebase.sh" pulls down the manifests and modules directories from https://github.com/pclonan/sinatra. The cron entry is:

    */30 * * * * /etc/puppet/rebase.sh

Expected Output
---------------
    $ git clone git://github.com/pclonan/sinatra
    Cloning into 'sinatra'...
    remote: Counting objects: 678, done.
    remote: Compressing objects: 100% (66/66), done.
    remote: Total 678 (delta 32), reused 73 (delta 17), pack-reused 572
    Receiving objects: 100% (678/678), 154.21 KiB | 144.00 KiB/s, done.
    Resolving deltas: 100% (285/285), done.
    Checking connectivity... done.
    $ cd sinatra
    $ vagrant up
    Bringing machine 'default' up with 'virtualbox' provider...
    ==> default: Importing base box 'centos/7'...
    ==> default: Matching MAC address for NAT networking...
    ==> default: Checking if box 'centos/7' is up to date...
    ==> default: A newer version of the box 'centos/7' is available! You currently
    ==> default: have version '1605.01'. The latest is version '1707.01'. Run
    ==> default: `vagrant box update` to update.
    ==> default: Setting the name of the VM: sinatra_default_1502624449855_83515
    ==> default: Clearing any previously set network interfaces...
    ==> default: Preparing network interfaces based on configuration...
        default: Adapter 1: nat
        default: Adapter 2: bridged
    ==> default: Forwarding ports...
        default: 22 (guest) => 2222 (host) (adapter 1)
    ==> default: Booting VM...
    ==> default: Waiting for machine to boot. This may take a few minutes...
        default: SSH address: 127.0.0.1:2222
        default: SSH username: vagrant
        default: SSH auth method: private key
        default: Warning: Connection reset. Retrying...
        default: Warning: Connection aborted. Retrying...
        default: Warning: Connection reset. Retrying...
        default: Warning: Remote connection disconnect. Retrying...
        default: Warning: Connection aborted. Retrying...
        default: Warning: Remote connection disconnect. Retrying...
        default: Warning: Connection aborted. Retrying...
        default: Warning: Connection reset. Retrying...
        default: Warning: Connection aborted. Retrying...
        default:
        default: Vagrant insecure key detected. Vagrant will automatically replace
        default: this with a newly generated keypair for better security.
        default:
        default: Inserting generated public key within guest...
        default: Removing insecure key from the guest if it's present...
        default: Key inserted! Disconnecting and reconnecting using new SSH key...
    ==> default: Machine booted and ready!
    ==> default: Checking for guest additions in VM...
        default: No guest additions were detected on the base box for this VM! Guest
        default: additions are required for forwarded ports, shared folders, host only
        default: networking, and more. If SSH fails on this machine, please install
        default: the guest additions and repackage the box to continue.
        default:
        default: This is not an error message; everything may continue to work properly,
        default: in which case you may ignore this message.
    ==> default: Configuring and enabling network interfaces...
        default: SSH address: 127.0.0.1:2222
        default: SSH username: vagrant
        default: SSH auth method: private key
    ==> default: Rsyncing folder: /cygdrive/c/Users/Paul/sinatra/ => /home/vagrant/sync
    ==> default: Running provisioner: shell...
        default: Running: inline script
    ==> default: warning: /var/tmp/rpm-tmp.NpXJg6: Header V4 RSA/SHA1 Signature, key ID ef8d349f: NOKEY
    ==> default: Retrieving http://yum.puppetlabs.com/puppetlabs-release-el-7.noarch.rpm
    ==> default: Preparing...
    ==> default: ########################################
    ==> default: Updating / installing...
    ==> default: puppetlabs-release-22.0-2
    ==> default: ########################################
    ==> default: Loaded plugins: fastestmirror
    ==> default: Determining fastest mirrors
    ==> default:  * base: mirror.overthewire.com.au
    ==> default:  * extras: centos.mirror.ausnetservers.net.au
    ==> default:  * updates: centos.mirror.ausnetservers.net.au
    ==> default: Resolving Dependencies
    ==> default: --> Running transaction check
    ==> default: ---> Package git.x86_64 0:1.8.3.1-6.el7_2.1 will be installed
    ==> default: --> Processing Dependency: perl-Git = 1.8.3.1-6.el7_2.1 for package: git-1.8.3.1-6.el7_2.1.x86_64
    ==> default: --> Processing Dependency: perl >= 5.008 for package: git-1.8.3.1-6.el7_2.1.x86_64
    ==> default: --> Processing Dependency: perl(warnings) for package: git-1.8.3.1-6.el7_2.1.x86_64
    ==> default: --> Processing Dependency: perl(vars) for package: git-1.8.3.1-6.el7_2.1.x86_64
    ==> default: --> Processing Dependency: perl(strict) for package: git-1.8.3.1-6.el7_2.1.x86_64
    ==> default: --> Processing Dependency: perl(lib) for package: git-1.8.3.1-6.el7_2.1.x86_64
    ==> default: --> Processing Dependency: perl(Term::ReadKey) for package: git-1.8.3.1-6.el7_2.1.x86_64
    ==> default: --> Processing Dependency: perl(Git) for package: git-1.8.3.1-6.el7_2.1.x86_64
    ==> default: --> Processing Dependency: perl(Getopt::Long) for package: git-1.8.3.1-6.el7_2.1.x86_64
    ==> default: --> Processing Dependency: perl(File::stat) for package: git-1.8.3.1-6.el7_2.1.x86_64
    ==> default: --> Processing Dependency: perl(File::Temp) for package: git-1.8.3.1-6.el7_2.1.x86_64
    ==> default: --> Processing Dependency: perl(File::Spec) for package: git-1.8.3.1-6.el7_2.1.x86_64
    ==> default: --> Processing Dependency: perl(File::Path) for package: git-1.8.3.1-6.el7_2.1.x86_64
    ==> default: --> Processing Dependency: perl(File::Find) for package: git-1.8.3.1-6.el7_2.1.x86_64
    ==> default: --> Processing Dependency: perl(File::Copy) for package: git-1.8.3.1-6.el7_2.1.x86_64
    ==> default: --> Processing Dependency: perl(File::Basename) for package: git-1.8.3.1-6.el7_2.1.x86_64
    ==> default: --> Processing Dependency: perl(Exporter) for package: git-1.8.3.1-6.el7_2.1.x86_64
    ==> default: --> Processing Dependency: perl(Error) for package: git-1.8.3.1-6.el7_2.1.x86_64
    ==> default: --> Processing Dependency: /usr/bin/perl for package: git-1.8.3.1-6.el7_2.1.x86_64
    ==> default: --> Processing Dependency: libgnome-keyring.so.0()(64bit) for package: git-1.8.3.1-6.el7_2.1.x86_64
    ==> default: ---> Package puppet.noarch 0:3.8.7-1.el7 will be installed
    ==> default: --> Processing Dependency: ruby >= 1.8.7 for package: puppet-3.8.7-1.el7.noarch
    ==> default: --> Processing Dependency: hiera >= 1.0.0 for package: puppet-3.8.7-1.el7.noarch
    ==> default: --> Processing Dependency: facter >= 1:1.7.0 for package: puppet-3.8.7-1.el7.noarch
    ==> default: --> Processing Dependency: ruby >= 1.8 for package: puppet-3.8.7-1.el7.noarch
    ==> default: --> Processing Dependency: ruby-shadow for package: puppet-3.8.7-1.el7.noarch
    ==> default: --> Processing Dependency: ruby(selinux) for package: puppet-3.8.7-1.el7.noarch
    ==> default: --> Processing Dependency: ruby-augeas for package: puppet-3.8.7-1.el7.noarch
    ==> default: --> Processing Dependency: /usr/bin/ruby for package: puppet-3.8.7-1.el7.noarch
    ==> default: --> Processing Dependency: rubygem-json for package: puppet-3.8.7-1.el7.noarch
    ==> default: --> Running transaction check
    ==> default: ---> Package facter.x86_64 1:2.4.6-1.el7 will be installed
    ==> default: --> Processing Dependency: pciutils for package: 1:facter-2.4.6-1.el7.x86_64
    ==> default: --> Processing Dependency: net-tools for package: 1:facter-2.4.6-1.el7.x86_64
    ==> default: ---> Package hiera.noarch 0:1.3.4-1.el7 will be installed
    ==> default: ---> Package libgnome-keyring.x86_64 0:3.8.0-3.el7 will be installed
    ==> default: ---> Package libselinux-ruby.x86_64 0:2.5-6.el7 will be installed
    ==> default: --> Processing Dependency: libselinux(x86-64) = 2.5-6.el7 for package: libselinux-ruby-2.5-6.el7.x86_64
    ==> default: ---> Package perl.x86_64 4:5.16.3-291.el7 will be installed
    ==> default: --> Processing Dependency: perl-libs = 4:5.16.3-291.el7 for package: 4:perl-5.16.3-291.el7.x86_64
    ==> default: --> Processing Dependency: perl(Socket) >= 1.3 for package: 4:perl-5.16.3-291.el7.x86_64
    ==> default: --> Processing Dependency: perl(Scalar::Util) >= 1.10 for package: 4:perl-5.16.3-291.el7.x86_64
    ==> default: --> Processing Dependency: perl-macros for package: 4:perl-5.16.3-291.el7.x86_64
    ==> default: --> Processing Dependency: perl-libs for package: 4:perl-5.16.3-291.el7.x86_64
    ==> default: --> Processing Dependency: perl(threads::shared) for package: 4:perl-5.16.3-291.el7.x86_64
    ==> default: --> Processing Dependency: perl(threads) for package: 4:perl-5.16.3-291.el7.x86_64
    ==> default: --> Processing Dependency: perl(constant) for package: 4:perl-5.16.3-291.el7.x86_64
    ==> default: --> Processing Dependency: perl(Time::Local) for package: 4:perl-5.16.3-291.el7.x86_64
    ==> default: --> Processing Dependency: perl(Time::HiRes) for package: 4:perl-5.16.3-291.el7.x86_64
    ==> default: --> Processing Dependency: perl(Storable) for package: 4:perl-5.16.3-291.el7.x86_64
    ==> default: --> Processing Dependency: perl(Socket) for package: 4:perl-5.16.3-291.el7.x86_64
    ==> default: --> Processing Dependency: perl(Scalar::Util) for package: 4:perl-5.16.3-291.el7.x86_64
    ==> default: --> Processing Dependency: perl(Pod::Simple::XHTML) for package: 4:perl-5.16.3-291.el7.x86_64
    ==> default: --> Processing Dependency: perl(Pod::Simple::Search) for package: 4:perl-5.16.3-291.el7.x86_64
    ==> default: --> Processing Dependency: perl(Filter::Util::Call) for package: 4:perl-5.16.3-291.el7.x86_64
    ==> default: --> Processing Dependency: perl(Carp) for package: 4:perl-5.16.3-291.el7.x86_64
    ==> default: --> Processing Dependency: libperl.so()(64bit) for package: 4:perl-5.16.3-291.el7.x86_64
    ==> default: ---> Package perl-Error.noarch 1:0.17020-2.el7 will be installed
    ==> default: ---> Package perl-Exporter.noarch 0:5.68-3.el7 will be installed
    ==> default: ---> Package perl-File-Path.noarch 0:2.09-2.el7 will be installed
    ==> default: ---> Package perl-File-Temp.noarch 0:0.23.01-3.el7 will be installed
    ==> default: ---> Package perl-Getopt-Long.noarch 0:2.40-2.el7 will be installed
    ==> default: --> Processing Dependency: perl(Pod::Usage) >= 1.14 for package: perl-Getopt-Long-2.40-2.el7.noarch
    ==> default: --> Processing Dependency: perl(Text::ParseWords) for package: perl-Getopt-Long-2.40-2.el7.noarch
    ==> default: ---> Package perl-Git.noarch 0:1.8.3.1-6.el7_2.1 will be installed
    ==> default: ---> Package perl-PathTools.x86_64 0:3.40-5.el7 will be installed
    ==> default: ---> Package perl-TermReadKey.x86_64 0:2.30-20.el7 will be installed
    ==> default: ---> Package ruby.x86_64 0:2.0.0.648-29.el7 will be installed
    ==> default: --> Processing Dependency: ruby-libs(x86-64) = 2.0.0.648-29.el7 for package: ruby-2.0.0.648-29.el7.x86_64
    ==> default: --> Processing Dependency: rubygem(bigdecimal) >= 1.2.0 for package: ruby-2.0.0.648-29.el7.x86_64
    ==> default: --> Processing Dependency: ruby(rubygems) >= 2.0.14.1 for package: ruby-2.0.0.648-29.el7.x86_64
    ==> default: --> Processing Dependency: libruby.so.2.0()(64bit) for package: ruby-2.0.0.648-29.el7.x86_64
    ==> default: ---> Package ruby-augeas.x86_64 0:0.4.1-3.el7 will be installed
    ==> default: --> Processing Dependency: augeas-libs >= 0.8.0 for package: ruby-augeas-0.4.1-3.el7.x86_64
    ==> default: --> Processing Dependency: libaugeas.so.0(AUGEAS_0.12.0)(64bit) for package: ruby-augeas-0.4.1-3.el7.x86_64
    ==> default: --> Processing Dependency: libaugeas.so.0(AUGEAS_0.1.0)(64bit) for package: ruby-augeas-0.4.1-3.el7.x86_64
    ==> default: --> Processing Dependency: libaugeas.so.0(AUGEAS_0.10.0)(64bit) for package: ruby-augeas-0.4.1-3.el7.x86_64
    ==> default: --> Processing Dependency: libaugeas.so.0(AUGEAS_0.8.0)(64bit) for package: ruby-augeas-0.4.1-3.el7.x86_64
    ==> default: --> Processing Dependency: libaugeas.so.0(AUGEAS_0.11.0)(64bit) for package: ruby-augeas-0.4.1-3.el7.x86_64
    ==> default: --> Processing Dependency: libaugeas.so.0()(64bit) for package: ruby-augeas-0.4.1-3.el7.x86_64
    ==> default: ---> Package ruby-shadow.x86_64 1:2.2.0-2.el7 will be installed
    ==> default: ---> Package rubygem-json.x86_64 0:1.7.7-29.el7 will be installed
    ==> default: --> Running transaction check
    ==> default: ---> Package augeas-libs.x86_64 0:1.4.0-2.el7 will be installed
    ==> default: ---> Package libselinux.x86_64 0:2.2.2-6.el7 will be updated
    ==> default: --> Processing Dependency: libselinux = 2.2.2-6.el7 for package: libselinux-utils-2.2.2-6.el7.x86_64
    ==> default: --> Processing Dependency: libselinux = 2.2.2-6.el7 for package: libselinux-python-2.2.2-6.el7.x86_64
    ==> default: ---> Package libselinux.x86_64 0:2.5-6.el7 will be an update
    ==> default: --> Processing Dependency: libsepol(x86-64) >= 2.5-6 for package: libselinux-2.5-6.el7.x86_64
    ==> default: --> Processing Dependency: libsepol.so.1(LIBSEPOL_1.0)(64bit) for package: libselinux-2.5-6.el7.x86_64
    ==> default: ---> Package net-tools.x86_64 0:2.0-0.17.20131004git.el7 will be installed
    ==> default: ---> Package pciutils.x86_64 0:3.5.1-1.el7 will be installed
    ==> default: --> Processing Dependency: pciutils-libs = 3.5.1-1.el7 for package: pciutils-3.5.1-1.el7.x86_64
    ==> default: --> Processing Dependency: libpci.so.3(LIBPCI_3.5)(64bit) for package: pciutils-3.5.1-1.el7.x86_64
    ==> default: --> Processing Dependency: libpci.so.3(LIBPCI_3.3)(64bit) for package: pciutils-3.5.1-1.el7.x86_64
    ==> default: ---> Package perl-Carp.noarch 0:1.26-244.el7 will be installed
    ==> default: ---> Package perl-Filter.x86_64 0:1.49-3.el7 will be installed
    ==> default: ---> Package perl-Pod-Simple.noarch 1:3.28-4.el7 will be installed
    ==> default: --> Processing Dependency: perl(Pod::Escapes) >= 1.04 for package: 1:perl-Pod-Simple-3.28-4.el7.noarch
    ==> default: --> Processing Dependency: perl(Encode) for package: 1:perl-Pod-Simple-3.28-4.el7.noarch
    ==> default: ---> Package perl-Pod-Usage.noarch 0:1.63-3.el7 will be installed
    ==> default: --> Processing Dependency: perl(Pod::Text) >= 3.15 for package: perl-Pod-Usage-1.63-3.el7.noarch
    ==> default: --> Processing Dependency: perl-Pod-Perldoc for package: perl-Pod-Usage-1.63-3.el7.noarch
    ==> default: ---> Package perl-Scalar-List-Utils.x86_64 0:1.27-248.el7 will be installed
    ==> default: ---> Package perl-Socket.x86_64 0:2.010-4.el7 will be installed
    ==> default: ---> Package perl-Storable.x86_64 0:2.45-3.el7 will be installed
    ==> default: ---> Package perl-Text-ParseWords.noarch 0:3.29-4.el7 will be installed
    ==> default: ---> Package perl-Time-HiRes.x86_64 4:1.9725-3.el7 will be installed
    ==> default: ---> Package perl-Time-Local.noarch 0:1.2300-2.el7 will be installed
    ==> default: ---> Package perl-constant.noarch 0:1.27-2.el7 will be installed
    ==> default: ---> Package perl-libs.x86_64 4:5.16.3-291.el7 will be installed
    ==> default: ---> Package perl-macros.x86_64 4:5.16.3-291.el7 will be installed
    ==> default: ---> Package perl-threads.x86_64 0:1.87-4.el7 will be installed
    ==> default: ---> Package perl-threads-shared.x86_64 0:1.43-6.el7 will be installed
    ==> default: ---> Package ruby-libs.x86_64 0:2.0.0.648-29.el7 will be installed
    ==> default: ---> Package rubygem-bigdecimal.x86_64 0:1.2.0-29.el7 will be installed
    ==> default: ---> Package rubygems.noarch 0:2.0.14.1-29.el7 will be installed
    ==> default: --> Processing Dependency: rubygem(rdoc) >= 4.0.0 for package: rubygems-2.0.14.1-29.el7.noarch
    ==> default: --> Processing Dependency: rubygem(psych) >= 2.0.0 for package: rubygems-2.0.14.1-29.el7.noarch
    ==> default: --> Processing Dependency: rubygem(io-console) >= 0.4.2 for package: rubygems-2.0.14.1-29.el7.noarch
    ==> default: --> Running transaction check
    ==> default: ---> Package libselinux-python.x86_64 0:2.2.2-6.el7 will be updated
    ==> default: ---> Package libselinux-python.x86_64 0:2.5-6.el7 will be an update
    ==> default: ---> Package libselinux-utils.x86_64 0:2.2.2-6.el7 will be updated
    ==> default: ---> Package libselinux-utils.x86_64 0:2.5-6.el7 will be an update
    ==> default: ---> Package libsepol.x86_64 0:2.1.9-3.el7 will be updated
    ==> default: ---> Package libsepol.x86_64 0:2.5-6.el7 will be an update
    ==> default: ---> Package pciutils-libs.x86_64 0:3.2.1-4.el7 will be updated
    ==> default: ---> Package pciutils-libs.x86_64 0:3.5.1-1.el7 will be an update
    ==> default: ---> Package perl-Encode.x86_64 0:2.51-7.el7 will be installed
    ==> default: ---> Package perl-Pod-Escapes.noarch 1:1.04-291.el7 will be installed
    ==> default: ---> Package perl-Pod-Perldoc.noarch 0:3.20-4.el7 will be installed
    ==> default: --> Processing Dependency: perl(parent) for package: perl-Pod-Perldoc-3.20-4.el7.noarch
    ==> default: --> Processing Dependency: perl(HTTP::Tiny) for package: perl-Pod-Perldoc-3.20-4.el7.noarch
    ==> default: ---> Package perl-podlators.noarch 0:2.5.1-3.el7 will be installed
    ==> default: ---> Package rubygem-io-console.x86_64 0:0.4.2-29.el7 will be installed
    ==> default: ---> Package rubygem-psych.x86_64 0:2.0.0-29.el7 will be installed
    ==> default: --> Processing Dependency: libyaml-0.so.2()(64bit) for package: rubygem-psych-2.0.0-29.el7.x86_64
    ==> default: ---> Package rubygem-rdoc.noarch 0:4.0.0-29.el7 will be installed
    ==> default: --> Processing Dependency: ruby(irb) = 2.0.0.648 for package: rubygem-rdoc-4.0.0-29.el7.noarch
    ==> default: --> Running transaction check
    ==> default: ---> Package libyaml.x86_64 0:0.1.4-11.el7_0 will be installed
    ==> default: ---> Package perl-HTTP-Tiny.noarch 0:0.033-3.el7 will be installed
    ==> default: ---> Package perl-parent.noarch 1:0.225-244.el7 will be installed
    ==> default: ---> Package ruby-irb.noarch 0:2.0.0.648-29.el7 will be installed
    ==> default: --> Processing Conflict: libselinux-2.5-6.el7.x86_64 conflicts systemd < 219-20
    ==> default: --> Restarting Dependency Resolution with new changes.
    ==> default: --> Running transaction check
    ==> default: ---> Package systemd.x86_64 0:219-19.el7_2.9 will be updated
    ==> default: --> Processing Dependency: systemd = 219-19.el7_2.9 for package: systemd-sysv-219-19.el7_2.9.x86_64
    ==> default: ---> Package systemd.x86_64 0:219-30.el7_3.9 will be an update
    ==> default: --> Processing Dependency: systemd-libs = 219-30.el7_3.9 for package: systemd-219-30.el7_3.9.x86_64
    ==> default: --> Running transaction check
    ==> default: ---> Package systemd-libs.x86_64 0:219-19.el7_2.9 will be updated
    ==> default: --> Processing Dependency: systemd-libs = 219-19.el7_2.9 for package: libgudev1-219-19.el7_2.9.x86_64
    ==> default: ---> Package systemd-libs.x86_64 0:219-30.el7_3.9 will be an update
    ==> default: ---> Package systemd-sysv.x86_64 0:219-19.el7_2.9 will be updated
    ==> default: ---> Package systemd-sysv.x86_64 0:219-30.el7_3.9 will be an update
    ==> default: --> Running transaction check
    ==> default: ---> Package libgudev1.x86_64 0:219-19.el7_2.9 will be updated
    ==> default: ---> Package libgudev1.x86_64 0:219-30.el7_3.9 will be an update
    ==> default: --> Finished Dependency Resolution
    ==> default:
    ==> default: Dependencies Resolved
    ==> default:
    ==> default: ================================================================================
    ==> default:  Package              Arch   Version                  Repository           Size
    ==> default: ================================================================================
    ==> default: Installing:
    ==> default:  git                  x86_64 1.8.3.1-6.el7_2.1        base                4.4 M
    ==> default:  puppet               noarch 3.8.7-1.el7              puppetlabs-products 1.5 M
    ==> default: Updating:
    ==> default:  systemd              x86_64 219-30.el7_3.9           updates             5.2 M
    ==> default: Installing for dependencies:
    ==> default:  augeas-libs          x86_64 1.4.0-2.el7              base                355 k
    ==> default:  facter               x86_64 1:2.4.6-1.el7            puppetlabs-products  98 k
    ==> default:  hiera                noarch 1.3.4-1.el7              puppetlabs-products  23 k
    ==> default:  libgnome-keyring     x86_64 3.8.0-3.el7              base                109 k
    ==> default:  libselinux-ruby      x86_64 2.5-6.el7                base                120 k
    ==> default:  libyaml              x86_64 0.1.4-11.el7_0           base                 55 k
    ==> default:  net-tools            x86_64 2.0-0.17.20131004git.el7 base                304 k
    ==> default:  pciutils             x86_64 3.5.1-1.el7              base                 93 k
    ==> default:  perl                 x86_64 4:5.16.3-291.el7         base                8.0 M
    ==> default:  perl-Carp            noarch 1.26-244.el7             base                 19 k
    ==> default:  perl-Encode          x86_64 2.51-7.el7               base                1.5 M
    ==> default:  perl-Error           noarch 1:0.17020-2.el7          base                 32 k
    ==> default:  perl-Exporter        noarch 5.68-3.el7               base                 28 k
    ==> default:  perl-File-Path       noarch 2.09-2.el7               base                 26 k
    ==> default:  perl-File-Temp       noarch 0.23.01-3.el7            base                 56 k
    ==> default:  perl-Filter          x86_64 1.49-3.el7               base                 76 k
    ==> default:  perl-Getopt-Long     noarch 2.40-2.el7               base                 56 k
    ==> default:  perl-Git             noarch 1.8.3.1-6.el7_2.1        base                 53 k
    ==> default:  perl-HTTP-Tiny       noarch 0.033-3.el7              base                 38 k
    ==> default:  perl-PathTools       x86_64 3.40-5.el7               base                 82 k
    ==> default:  perl-Pod-Escapes     noarch 1:1.04-291.el7           base                 51 k
    ==> default:  perl-Pod-Perldoc     noarch 3.20-4.el7               base                 87 k
    ==> default:  perl-Pod-Simple      noarch 1:3.28-4.el7             base                216 k
    ==> default:  perl-Pod-Usage       noarch 1.63-3.el7               base                 27 k
    ==> default:  perl-Scalar-List-Utils
    ==> default:                       x86_64 1.27-248.el7             base                 36 k
    ==> default:  perl-Socket          x86_64 2.010-4.el7              base                 49 k
    ==> default:  perl-Storable        x86_64 2.45-3.el7               base                 77 k
    ==> default:  perl-TermReadKey     x86_64 2.30-20.el7              base                 31 k
    ==> default:  perl-Text-ParseWords noarch 3.29-4.el7               base                 14 k
    ==> default:  perl-Time-HiRes      x86_64 4:1.9725-3.el7           base                 45 k
    ==> default:  perl-Time-Local      noarch 1.2300-2.el7             base                 24 k
    ==> default:  perl-constant        noarch 1.27-2.el7               base                 19 k
    ==> default:  perl-libs            x86_64 4:5.16.3-291.el7         base                688 k
    ==> default:  perl-macros          x86_64 4:5.16.3-291.el7         base                 43 k
    ==> default:  perl-parent          noarch 1:0.225-244.el7          base                 12 k
    ==> default:  perl-podlators       noarch 2.5.1-3.el7              base                112 k
    ==> default:  perl-threads         x86_64 1.87-4.el7               base                 49 k
    ==> default:  perl-threads-shared  x86_64 1.43-6.el7               base                 39 k
    ==> default:  ruby                 x86_64 2.0.0.648-29.el7         base                 68 k
    ==> default:  ruby-augeas          x86_64 0.4.1-3.el7              puppetlabs-deps      22 k
    ==> default:  ruby-irb             noarch 2.0.0.648-29.el7         base                 89 k
    ==> default:  ruby-libs            x86_64 2.0.0.648-29.el7         base                2.8 M
    ==> default:  ruby-shadow          x86_64 1:2.2.0-2.el7            puppetlabs-deps      14 k
    ==> default:  rubygem-bigdecimal   x86_64 1.2.0-29.el7             base                 80 k
    ==> default:  rubygem-io-console   x86_64 0.4.2-29.el7             base                 51 k
    ==> default:  rubygem-json         x86_64 1.7.7-29.el7             base                 76 k
    ==> default:  rubygem-psych        x86_64 2.0.0-29.el7             base                 78 k
    ==> default:  rubygem-rdoc         noarch 4.0.0-29.el7             base                319 k
    ==> default:  rubygems             noarch 2.0.14.1-29.el7          base                216 k
    ==> default: Updating for dependencies:
    ==> default:  libgudev1            x86_64 219-30.el7_3.9           updates              77 k
    ==> default:  libselinux           x86_64 2.5-6.el7                base                161 k
    ==> default:  libselinux-python    x86_64 2.5-6.el7                base                234 k
    ==> default:  libselinux-utils     x86_64 2.5-6.el7                base                151 k
    ==> default:  libsepol             x86_64 2.5-6.el7                base                288 k
    ==> default:  pciutils-libs        x86_64 3.5.1-1.el7              base                 46 k
    ==> default:  systemd-libs         x86_64 219-30.el7_3.9           updates             369 k
    ==> default:  systemd-sysv         x86_64 219-30.el7_3.9           updates              64 k
    ==> default:
    ==> default: Transaction Summary
    ==> default: ================================================================================
    ==> default: Install  2 Packages (+49 Dependent packages)
    ==> default: Upgrade  1 Package  (+ 8 Dependent packages)
    ==> default:
    ==> default: Total download size: 29 M
    ==> default: Downloading packages:
    ==> default: No Presto metadata available for base
    ==> default: Delta RPMs reduced 5.6 M of updates to 3.1 M (44% saved)
    ==> default: Public key for facter-2.4.6-1.el7.x86_64.rpm is not installed
    ==> default: warning: /var/cache/yum/x86_64/7/puppetlabs-products/packages/facter-2.4.6-1.el7.x86_64.rpm: Header V4 RSA/SHA1 Signature, key ID 4bd6ec30: NOKEY
    ==> default: Public key for augeas-libs-1.4.0-2.el7.x86_64.rpm is not installed
    ==> default: warning: /var/cache/yum/x86_64/7/base/packages/augeas-libs-1.4.0-2.el7.x86_64.rpm: Header V3 RSA/SHA256 Signature, key ID f4a80eb5: NOKEY
    ==> default: Public key for libgudev1-219-30.el7_3.9.x86_64.rpm is not installed
    ==> default: Public key for ruby-augeas-0.4.1-3.el7.x86_64.rpm is not installed
    ==> default: Finishing delta rebuilds of 1 package(s) (5.2 M)
    ==> default: --------------------------------------------------------------------------------
    ==> default: Total                                              2.8 MB/s |  26 MB  00:09
    ==> default: Retrieving key from file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7
    ==> default: Importing GPG key 0xF4A80EB5:
    ==> default:  Userid     : "CentOS-7 Key (CentOS 7 Official Signing Key) <security@centos.org>"
    ==> default:  Fingerprint: 6341 ab27 53d7 8a78 a7c2 7bb1 24c6 a8a7 f4a8 0eb5
    ==> default:  Package    : centos-release-7-2.1511.el7.centos.2.10.x86_64 (@anaconda)
    ==> default:  From       : /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7
    ==> default: Retrieving key from file:///etc/pki/rpm-gpg/RPM-GPG-KEY-puppetlabs
    ==> default: Importing GPG key 0x4BD6EC30:
    ==> default:  Userid     : "Puppet Labs Release Key (Puppet Labs Release Key) <info@puppetlabs.com>"
    ==> default:  Fingerprint: 47b3 20eb 4c7c 375a a9da e1a0 1054 b7a2 4bd6 ec30
    ==> default:  Package    : puppetlabs-release-22.0-2.noarch (installed)
    ==> default:  From       : /etc/pki/rpm-gpg/RPM-GPG-KEY-puppetlabs
    ==> default: Retrieving key from file:///etc/pki/rpm-gpg/RPM-GPG-KEY-puppet
    ==> default: Importing GPG key 0xEF8D349F:
    ==> default:  Userid     : "Puppet, Inc. Release Key (Puppet, Inc. Release Key) <release@puppet.com>"
    ==> default:  Fingerprint: 6f6b 1550 9cf8 e59e 6e46 9f32 7f43 8280 ef8d 349f
    ==> default:  Package    : puppetlabs-release-22.0-2.noarch (installed)
    ==> default:  From       : /etc/pki/rpm-gpg/RPM-GPG-KEY-puppet
    ==> default: Running transaction check
    ==> default: Running transaction test
    ==> default: Transaction test succeeded
    ==> default: Running transaction
    ==> default: Warning: RPMDB altered outside of yum.
    ==> default:   Installing : ruby-libs-2.0.0.648-29.el7.x86_64                           1/69
    ==> default:
    ==> default:   Updating   : libsepol-2.5-6.el7.x86_64                                   2/69
    ==> default:
    ==> default:   Updating   : libselinux-2.5-6.el7.x86_64                                 3/69
    ==> default:
    ==> default:   Updating   : systemd-libs-219-30.el7_3.9.x86_64                          4/69
    ==> default:
    ==> default:   Updating   : systemd-219-30.el7_3.9.x86_64                               5/69
    ==> default:
    ==> default:   Installing : net-tools-2.0-0.17.20131004git.el7.x86_64                   6/69
    ==> default:
    ==> default:   Updating   : libselinux-utils-2.5-6.el7.x86_64                           7/69
    ==> default:
    ==> default:   Installing : libselinux-ruby-2.5-6.el7.x86_64                            8/69
    ==> default:
    ==> default:   Installing : augeas-libs-1.4.0-2.el7.x86_64                              9/69
    ==> default:
    ==> default:   Installing : ruby-augeas-0.4.1-3.el7.x86_64                             10/69
    ==> default:
    ==> default:   Installing : 1:perl-parent-0.225-244.el7.noarch                         11/69
    ==> default:
    ==> default:   Installing : perl-HTTP-Tiny-0.033-3.el7.noarch                          12/69
    ==> default:
    ==> default:   Installing : perl-podlators-2.5.1-3.el7.noarch                          13/69
    ==> default:
    ==> default:   Installing : perl-Pod-Perldoc-3.20-4.el7.noarch                         14/69
    ==> default:
    ==> default:   Installing : 1:perl-Pod-Escapes-1.04-291.el7.noarch                     15/69
    ==> default:
    ==> default:   Installing : perl-Encode-2.51-7.el7.x86_64                              16/69
    ==> default:
    ==> default:   Installing : perl-Text-ParseWords-3.29-4.el7.noarch                     17/69
    ==> default:
    ==> default:   Installing : perl-Pod-Usage-1.63-3.el7.noarch                           18/69
    ==> default:
    ==> default:   Installing : 4:perl-Time-HiRes-1.9725-3.el7.x86_64                      19/69
    ==> default:
    ==> default:   Installing : perl-Exporter-5.68-3.el7.noarch                            20/69
    ==> default:
    ==> default:   Installing : perl-constant-1.27-2.el7.noarch                            21/69
    ==> default:
    ==> default:   Installing : perl-Time-Local-1.2300-2.el7.noarch                        22/69
    ==> default:
    ==> default:   Installing : perl-Socket-2.010-4.el7.x86_64                             23/69
    ==> default:
    ==> default:   Installing : perl-Carp-1.26-244.el7.noarch                              24/69
    ==> default:
    ==> default:   Installing : perl-Storable-2.45-3.el7.x86_64                            25/69
    ==> default:
    ==> default:   Installing : perl-PathTools-3.40-5.el7.x86_64                           26/69
    ==> default:
    ==> default:   Installing : perl-Scalar-List-Utils-1.27-248.el7.x86_64                 27/69
    ==> default:
    ==> default:   Installing : 4:perl-libs-5.16.3-291.el7.x86_64                          28/69
    ==> default:
    ==> default:   Installing : 4:perl-macros-5.16.3-291.el7.x86_64                        29/69
    ==> default:
    ==> default:   Installing : perl-File-Temp-0.23.01-3.el7.noarch                        30/69
    ==> default:
    ==> default:   Installing : perl-File-Path-2.09-2.el7.noarch                           31/69
    ==> default:
    ==> default:   Installing : perl-threads-shared-1.43-6.el7.x86_64                      32/69
    ==> default:
    ==> default:   Installing : perl-threads-1.87-4.el7.x86_64                             33/69
    ==> default:
    ==> default:   Installing : perl-Filter-1.49-3.el7.x86_64                              34/69
    ==> default:
    ==> default:   Installing : 1:perl-Pod-Simple-3.28-4.el7.noarch                        35/69
    ==> default:
    ==> default:   Installing : perl-Getopt-Long-2.40-2.el7.noarch                         36/69
    ==> default:
    ==> default:   Installing : 4:perl-5.16.3-291.el7.x86_64                               37/69
    ==> default:
    ==> default:   Installing : 1:perl-Error-0.17020-2.el7.noarch                          38/69
    ==> default:
    ==> default:   Installing : perl-TermReadKey-2.30-20.el7.x86_64                        39/69
    ==> default:
    ==> default:   Installing : libyaml-0.1.4-11.el7_0.x86_64                              40/69
    ==> default:
    ==> default:   Installing : rubygem-psych-2.0.0-29.el7.x86_64                          41/69
    ==> default:
    ==> default:   Installing : rubygem-json-1.7.7-29.el7.x86_64                           42/69
    ==> default:
    ==> default:   Installing : rubygem-io-console-0.4.2-29.el7.x86_64                     43/69
    ==> default:
    ==> default:   Installing : rubygem-bigdecimal-1.2.0-29.el7.x86_64                     44/69
    ==> default:
    ==> default:   Installing : ruby-irb-2.0.0.648-29.el7.noarch                           45/69
    ==> default:
    ==> default:   Installing : ruby-2.0.0.648-29.el7.x86_64                               46/69
    ==> default:
    ==> default:   Installing : rubygems-2.0.14.1-29.el7.noarch                            47/69
    ==> default:
    ==> default:   Installing : rubygem-rdoc-4.0.0-29.el7.noarch                           48/69
    ==> default:
    ==> default:   Installing : hiera-1.3.4-1.el7.noarch                                   49/69
    ==> default:
    ==> default:   Installing : 1:ruby-shadow-2.2.0-2.el7.x86_64                           50/69
    ==> default:
    ==> default:   Installing : libgnome-keyring-3.8.0-3.el7.x86_64                        51/69
    ==> default:
    ==> default:   Installing : perl-Git-1.8.3.1-6.el7_2.1.noarch                          52/69
    ==> default:
    ==> default:   Installing : git-1.8.3.1-6.el7_2.1.x86_64                               53/69
    ==> default:
    ==> default:   Updating   : pciutils-libs-3.5.1-1.el7.x86_64                           54/69
    ==> default:
    ==> default:   Installing : pciutils-3.5.1-1.el7.x86_64                                55/69
    ==> default:
    ==> default:   Installing : 1:facter-2.4.6-1.el7.x86_64                                56/69
    ==> default:
    ==> default:   Installing : puppet-3.8.7-1.el7.noarch                                  57/69
    ==> default:
    ==> default:   Updating   : systemd-sysv-219-30.el7_3.9.x86_64                         58/69
    ==> default:
    ==> default:   Updating   : libgudev1-219-30.el7_3.9.x86_64                            59/69
    ==> default:
    ==> default:   Updating   : libselinux-python-2.5-6.el7.x86_64                         60/69
    ==> default:
    ==> default:   Cleanup    : systemd-sysv-219-19.el7_2.9.x86_64                         61/69
    ==> default:
    ==> default:   Cleanup    : systemd-219-19.el7_2.9.x86_64                              62/69
    ==> default:
    ==> default:   Cleanup    : libgudev1-219-19.el7_2.9.x86_64                            63/69
    ==> default:
    ==> default:   Cleanup    : systemd-libs-219-19.el7_2.9.x86_64                         64/69
    ==> default:
    ==> default:   Cleanup    : libselinux-utils-2.2.2-6.el7.x86_64                        65/69
    ==> default:
    ==> default:   Cleanup    : libselinux-python-2.2.2-6.el7.x86_64                       66/69
    ==> default:
    ==> default:   Cleanup    : libselinux-2.2.2-6.el7.x86_64                              67/69
    ==> default:
    ==> default:   Cleanup    : libsepol-2.1.9-3.el7.x86_64                                68/69
    ==> default:
    ==> default:   Cleanup    : pciutils-libs-3.2.1-4.el7.x86_64                           69/69
    ==> default:
    ==> default:   Verifying  : perl-HTTP-Tiny-0.033-3.el7.noarch                           1/69
    ==> default:
    ==> default:   Verifying  : rubygem-rdoc-4.0.0-29.el7.noarch                            2/69
    ==> default:
    ==> default:   Verifying  : libsepol-2.5-6.el7.x86_64                                   3/69
    ==> default:
    ==> default:   Verifying  : perl-threads-shared-1.43-6.el7.x86_64                       4/69
    ==> default:
    ==> default:   Verifying  : 4:perl-Time-HiRes-1.9725-3.el7.x86_64                       5/69
    ==> default:
    ==> default:   Verifying  : net-tools-2.0-0.17.20131004git.el7.x86_64                   6/69
    ==> default:
    ==> default:   Verifying  : perl-Exporter-5.68-3.el7.noarch                             7/69
    ==> default:
    ==> default:   Verifying  : perl-constant-1.27-2.el7.noarch                             8/69
    ==> default:
    ==> default:   Verifying  : perl-PathTools-3.40-5.el7.x86_64                            9/69
    ==> default:
    ==> default:   Verifying  : libselinux-python-2.5-6.el7.x86_64                         10/69
    ==> default:
    ==> default:   Verifying  : ruby-irb-2.0.0.648-29.el7.noarch                           11/69
    ==> default:
    ==> default:   Verifying  : 1:perl-Pod-Escapes-1.04-291.el7.noarch                     12/69
    ==> default:
    ==> default:   Verifying  : ruby-libs-2.0.0.648-29.el7.x86_64                          13/69
    ==> default:
    ==> default:   Verifying  : libselinux-utils-2.5-6.el7.x86_64                          14/69
    ==> default:
    ==> default:   Verifying  : rubygem-psych-2.0.0-29.el7.x86_64                          15/69
    ==> default:
    ==> default:   Verifying  : 1:perl-parent-0.225-244.el7.noarch                         16/69
    ==> default:
    ==> default:   Verifying  : 1:facter-2.4.6-1.el7.x86_64                                17/69
    ==> default:
    ==> default:   Verifying  : perl-TermReadKey-2.30-20.el7.x86_64                        18/69
    ==> default:
    ==> default:   Verifying  : hiera-1.3.4-1.el7.noarch                                   19/69
    ==> default:
    ==> default:   Verifying  : perl-File-Temp-0.23.01-3.el7.noarch                        20/69
    ==> default:
    ==> default:   Verifying  : libselinux-ruby-2.5-6.el7.x86_64                           21/69
    ==> default:
    ==> default:   Verifying  : pciutils-libs-3.5.1-1.el7.x86_64                           22/69
    ==> default:
    ==> default:   Verifying  : rubygem-json-1.7.7-29.el7.x86_64                           23/69
    ==> default:
    ==> default:   Verifying  : rubygem-io-console-0.4.2-29.el7.x86_64                     24/69
    ==> default:
    ==> default:   Verifying  : perl-Time-Local-1.2300-2.el7.noarch                        25/69
    ==> default:
    ==> default:   Verifying  : perl-Git-1.8.3.1-6.el7_2.1.noarch                          26/69
    ==> default:
    ==> default:   Verifying  : perl-Socket-2.010-4.el7.x86_64                             27/69
    ==> default:
    ==> default:   Verifying  : perl-Encode-2.51-7.el7.x86_64                              28/69
    ==> default:
    ==> default:   Verifying  : perl-Carp-1.26-244.el7.noarch                              29/69
    ==> default:
    ==> default:   Verifying  : systemd-sysv-219-30.el7_3.9.x86_64                         30/69
    ==> default:
    ==> default:   Verifying  : 1:perl-Error-0.17020-2.el7.noarch                          31/69
    ==> default:
    ==> default:   Verifying  : 1:ruby-shadow-2.2.0-2.el7.x86_64                           32/69
    ==> default:
    ==> default:   Verifying  : libgudev1-219-30.el7_3.9.x86_64                            33/69
    ==> default:
    ==> default:   Verifying  : rubygem-bigdecimal-1.2.0-29.el7.x86_64                     34/69
    ==> default:
    ==> default:   Verifying  : perl-Storable-2.45-3.el7.x86_64                            35/69
    ==> default:
    ==> default:   Verifying  : perl-Scalar-List-Utils-1.27-248.el7.x86_64                 36/69
    ==> default:
    ==> default:   Verifying  : libselinux-2.5-6.el7.x86_64                                37/69
    ==> default:
    ==> default:   Verifying  : 4:perl-libs-5.16.3-291.el7.x86_64                          38/69
    ==> default:
    ==> default:   Verifying  : 4:perl-macros-5.16.3-291.el7.x86_64                        39/69
    ==> default:
    ==> default:   Verifying  : libgnome-keyring-3.8.0-3.el7.x86_64                        40/69
    ==> default:
    ==> default:   Verifying  : perl-Pod-Usage-1.63-3.el7.noarch                           41/69
    ==> default:
    ==> default:   Verifying  : puppet-3.8.7-1.el7.noarch                                  42/69
    ==> default:
    ==> default:   Verifying  : augeas-libs-1.4.0-2.el7.x86_64                             43/69
    ==> default:
    ==> default:   Verifying  : rubygems-2.0.14.1-29.el7.noarch                            44/69
    ==> default:
    ==> default:   Verifying  : libyaml-0.1.4-11.el7_0.x86_64                              45/69
    ==> default:
    ==> default:   Verifying  : perl-podlators-2.5.1-3.el7.noarch                          46/69
    ==> default:
    ==> default:   Verifying  : perl-Getopt-Long-2.40-2.el7.noarch                         47/69
    ==> default:
    ==> default:   Verifying  : ruby-augeas-0.4.1-3.el7.x86_64                             48/69
    ==> default:
    ==> default:   Verifying  : perl-File-Path-2.09-2.el7.noarch                           49/69
    ==> default:
    ==> default:   Verifying  : 4:perl-5.16.3-291.el7.x86_64                               50/69
    ==> default:
    ==> default:   Verifying  : perl-threads-1.87-4.el7.x86_64                             51/69
    ==> default:
    ==> default:   Verifying  : pciutils-3.5.1-1.el7.x86_64                                52/69
    ==> default:
    ==> default:   Verifying  : 1:perl-Pod-Simple-3.28-4.el7.noarch                        53/69
    ==> default:
    ==> default:   Verifying  : perl-Filter-1.49-3.el7.x86_64                              54/69
    ==> default:
    ==> default:   Verifying  : perl-Pod-Perldoc-3.20-4.el7.noarch                         55/69
    ==> default:
    ==> default:   Verifying  : perl-Text-ParseWords-3.29-4.el7.noarch                     56/69
    ==> default:
    ==> default:   Verifying  : systemd-libs-219-30.el7_3.9.x86_64                         57/69
    ==> default:
    ==> default:   Verifying  : git-1.8.3.1-6.el7_2.1.x86_64                               58/69
    ==> default:
    ==> default:   Verifying  : ruby-2.0.0.648-29.el7.x86_64                               59/69
    ==> default:
    ==> default:   Verifying  : systemd-219-30.el7_3.9.x86_64                              60/69
    ==> default:
    ==> default:   Verifying  : pciutils-libs-3.2.1-4.el7.x86_64                           61/69
    ==> default:   Verifying  : libgudev1-219-19.el7_2.9.x86_64                            62/69
    ==> default:   Verifying  : systemd-219-19.el7_2.9.x86_64                              63/69
    ==> default:   Verifying  : libselinux-utils-2.2.2-6.el7.x86_64                        64/69
    ==> default:   Verifying  : libsepol-2.1.9-3.el7.x86_64                                65/69
    ==> default:   Verifying  : libselinux-python-2.2.2-6.el7.x86_64                       66/69
    ==> default:   Verifying  : systemd-sysv-219-19.el7_2.9.x86_64                         67/69
    ==> default:   Verifying  : libselinux-2.2.2-6.el7.x86_64                              68/69
    ==> default:   Verifying  : systemd-libs-219-19.el7_2.9.x86_64                         69/69
    ==> default:
    ==> default:
    ==> default: Installed:
    ==> default:   git.x86_64 0:1.8.3.1-6.el7_2.1           puppet.noarch 0:3.8.7-1.el7
    ==> default:
    ==> default: Dependency Installed:
    ==> default:   augeas-libs.x86_64 0:1.4.0-2.el7
    ==> default:   facter.x86_64 1:2.4.6-1.el7
    ==> default:   hiera.noarch 0:1.3.4-1.el7
    ==> default:   libgnome-keyring.x86_64 0:3.8.0-3.el7
    ==> default:   libselinux-ruby.x86_64 0:2.5-6.el7
    ==> default:   libyaml.x86_64 0:0.1.4-11.el7_0
    ==> default:   net-tools.x86_64 0:2.0-0.17.20131004git.el7
    ==> default:   pciutils.x86_64 0:3.5.1-1.el7
    ==> default:   perl.x86_64 4:5.16.3-291.el7
    ==> default:   perl-Carp.noarch 0:1.26-244.el7
    ==> default:   perl-Encode.x86_64 0:2.51-7.el7
    ==> default:   perl-Error.noarch 1:0.17020-2.el7
    ==> default:   perl-Exporter.noarch 0:5.68-3.el7
    ==> default:   perl-File-Path.noarch 0:2.09-2.el7
    ==> default:   perl-File-Temp.noarch 0:0.23.01-3.el7
    ==> default:   perl-Filter.x86_64 0:1.49-3.el7
    ==> default:   perl-Getopt-Long.noarch 0:2.40-2.el7
    ==> default:   perl-Git.noarch 0:1.8.3.1-6.el7_2.1
    ==> default:   perl-HTTP-Tiny.noarch 0:0.033-3.el7
    ==> default:   perl-PathTools.x86_64 0:3.40-5.el7
    ==> default:   perl-Pod-Escapes.noarch 1:1.04-291.el7
    ==> default:   perl-Pod-Perldoc.noarch 0:3.20-4.el7
    ==> default:   perl-Pod-Simple.noarch 1:3.28-4.el7
    ==> default:   perl-Pod-Usage.noarch 0:1.63-3.el7
    ==> default:   perl-Scalar-List-Utils.x86_64 0:1.27-248.el7
    ==> default:   perl-Socket.x86_64 0:2.010-4.el7
    ==> default:   perl-Storable.x86_64 0:2.45-3.el7
    ==> default:   perl-TermReadKey.x86_64 0:2.30-20.el7
    ==> default:   perl-Text-ParseWords.noarch 0:3.29-4.el7
    ==> default:   perl-Time-HiRes.x86_64 4:1.9725-3.el7
    ==> default:   perl-Time-Local.noarch 0:1.2300-2.el7
    ==> default:   perl-constant.noarch 0:1.27-2.el7
    ==> default:   perl-libs.x86_64 4:5.16.3-291.el7
    ==> default:   perl-macros.x86_64 4:5.16.3-291.el7
    ==> default:   perl-parent.noarch 1:0.225-244.el7
    ==> default:   perl-podlators.noarch 0:2.5.1-3.el7
    ==> default:   perl-threads.x86_64 0:1.87-4.el7
    ==> default:   perl-threads-shared.x86_64 0:1.43-6.el7
    ==> default:   ruby.x86_64 0:2.0.0.648-29.el7
    ==> default:   ruby-augeas.x86_64 0:0.4.1-3.el7
    ==> default:   ruby-irb.noarch 0:2.0.0.648-29.el7
    ==> default:   ruby-libs.x86_64 0:2.0.0.648-29.el7
    ==> default:   ruby-shadow.x86_64 1:2.2.0-2.el7
    ==> default:   rubygem-bigdecimal.x86_64 0:1.2.0-29.el7
    ==> default:   rubygem-io-console.x86_64 0:0.4.2-29.el7
    ==> default:   rubygem-json.x86_64 0:1.7.7-29.el7
    ==> default:   rubygem-psych.x86_64 0:2.0.0-29.el7
    ==> default:   rubygem-rdoc.noarch 0:4.0.0-29.el7
    ==> default:   rubygems.noarch 0:2.0.14.1-29.el7
    ==> default:
    ==> default: Updated:
    ==> default:   systemd.x86_64 0:219-30.el7_3.9
    ==> default:
    ==> default: Dependency Updated:
    ==> default:   libgudev1.x86_64 0:219-30.el7_3.9      libselinux.x86_64 0:2.5-6.el7
    ==> default:   libselinux-python.x86_64 0:2.5-6.el7   libselinux-utils.x86_64 0:2.5-6.el7
    ==> default:   libsepol.x86_64 0:2.5-6.el7            pciutils-libs.x86_64 0:3.5.1-1.el7
    ==> default:   systemd-libs.x86_64 0:219-30.el7_3.9   systemd-sysv.x86_64 0:219-30.el7_3.9
    ==> default:
    ==> default: Complete!
    ==> default: Initialized empty Git repository in /etc/puppet/.git/
    ==> default: From https://github.com/pclonan/sinatra
    ==> default:  * branch            master     -> FETCH_HEAD
    ==> default: Notice: Compiled catalog for localhost in environment production in 1.26 seconds
    ==> default: Notice: /Stage[main]/Iptables/Package[iptables-services]/ensure: created
    ==> default: Notice: /Stage[main]/Ssh/Augeas[sshd_config]/returns: executed successfully
    ==> default: Notice: /Stage[main]/Ssh/Service[sshd]: Triggered 'refresh' from 1 events
    ==> default: Notice: /Stage[main]/Puppet-cron/File[rebase.sh]/ensure: defined content as '{md5}214a9082d74b3f29f792745cc7e481db'
    ==> default: Notice: /Stage[main]/Iptables/File[/etc/sysconfig/iptables]/content: content changed '{md5}e628a913aa0d84645947744ea55d8556' to '{md5}a308e6e6f30ddb953590423be6229c2e'
    ==> default: Notice: /Stage[main]/Iptables/File[/etc/sysconfig/iptables]/mode: mode changed '0600' to '0640'
    ==> default: Notice: /Stage[main]/Iptables/Service[iptables]/ensure: ensure changed 'stopped' to 'running'
    ==> default: Notice: /Stage[main]/Sinatraservice/File[/apps]/ensure: created
    ==> default: Notice: /Stage[main]/Sinatraservice/File[/etc/systemd/system/sinatra.service]/ensure: defined content as '{md5}4a53bdf5e547e550d4ec0c2cab2bfb56'
    ==> default: Notice: /Stage[main]/Sudo/File[/etc/sudoers.d/sinatra]/ensure: defined content as '{md5}6124133f904816be595d128d2a2bd531'
    ==> default: Notice: /Stage[main]/Ruby/Package[centos-release-scl]/ensure: created
    ==> default: Notice: /Stage[main]/Ruby/Package[rh-ruby24-rubygem-bundler]/ensure: created
    ==> default: Notice: /Stage[main]/Ruby/Package[rh-ruby24]/ensure: created
    ==> default: Notice: /Stage[main]/Puppet-cron/File[post-hook]/ensure: defined content as '{md5}31a4a69d47355808db28c62773570994'
    ==> default: Notice: /Stage[main]/Puppet-cron/Cron[puppet-apply]/ensure: created
    ==> default: Notice: /Stage[main]/Users/Group[sinatra]/ensure: created
    ==> default: Notice: /Stage[main]/Users/User[sinatra]/ensure: created
    ==> default: Notice: /Stage[main]/Osharden/Augeas[sysctl]/returns: executed successfully
    ==> default: Notice: /Stage[main]/Osharden/Service[kdump.service]/enable: enable changed 'true' to 'false'
    ==> default: Notice: /Stage[main]/Osharden/Augeas[/etc/sysconfig/network]/returns: executed successfully
    ==> default: Notice: /Stage[main]/Osharden/Service[network]: Triggered 'refresh' from 1 events
    ==> default: Notice: /Stage[main]/Sinatraservice/Vcsrepo[/apps/simple-sinatra-app]/ensure: Creating repository from latest
    ==> default: Notice: /Stage[main]/Sinatraservice/Vcsrepo[/apps/simple-sinatra-app]/ensure: created
    ==> default: Notice: /Stage[main]/Sinatraservice/File[/apps/simple-sinatra-app/sinatra.sh]/ensure: defined content as '{md5}2bfb6e07a626f1408a232079f7153f7a'
    ==> default: Notice: /Stage[main]/Sinatraservice/Service[sinatra.service]/ensure: ensure changed 'stopped' to 'running'
    ==> default: Notice: Sinatra app: http://192.168.0.200
    ==> default: Notice: /Stage[main]/Sinatraservice/Notify[sinatra]/message: defined 'message' as 'Sinatra app: http://192.168.0.200'
    ==> default: Notice: Finished catalog run in 39.65 seconds
