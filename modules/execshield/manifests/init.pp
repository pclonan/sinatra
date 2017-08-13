class execshield {

  augeas::basic_change {"Enable ExecShield, 2.2.4.3": 
    file=>"/etc/sysctl.conf", 
    lens=>"sysctl.lns", 
    changes => [
      "set kernel.randomize_va_space 2", 
    ]
  }
  augeas { "sysctl":
    context => "/files/etc/sysctl.conf",
    changes => [
      "set kernel.exec-shield = 1",
  #and whatever other lines are interesting to you
    ],
  }
  file { 'sysctl_conf':
    ensure => file,
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
