class execshield {

  augeas { "sysctl":
    context => "/files/etc/sysctl.conf",
    changes => [
      "set kernel.exec-shield 1",
    ],
  }
  file { 'sysctl_conf':
    ensure => file,
    path => '/etc/sysctl.conf',
    owner => 'root',
    group => 'root',
    mode => '0644',
  }
  exec { "sysctl":
      command => "/sbin/sysctl -p",
      refreshonly => true,
      subscribe => File["sysctl_conf"],
   }
}
