# == Class: users
#
# Full description of class users here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if
#   it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should be avoided in favor of class parameters as
#   of Puppet 2.6.)
#
# === Examples
#
#  class { 'users':
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#  }
#
# === Authors
#
# Author Name <author@domain.com>
#
# === Copyright
#
# Copyright 2017 Your name here, unless otherwise noted.
#
class users {

  group { 'sinatra':
    ensure => present,
	gid => '500',
  }

  file { '/apps':
    ensure => directory,
  }
  
  user { 'sinatra':
    ensure => present,
	uid => '500',
	gid => '500',
	home => '/apps/simple-sinatra-app',
	password => '$1$E.xtE53M$3X7z418n5EKwXksH6C3Ey.',
	shell => '/bin/bash',
  }

}
