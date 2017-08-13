class ssh {

  package { "openssh-server": 
      ensure => "installed",
  }

  service { "sshd":
      ensure    => running,
      hasstatus => true,
      require   => Package["openssh-server"],
  }

  augeas { "sshd_config":
  context => "/files/etc/ssh/sshd_config",
    changes => [
    "set PermitRootLogin no",
  ],
  notify => Service['sshd'],
 }
}
