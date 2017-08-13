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
    "set RSAAuthentication yes",
    "set PubkeyAuthentication yes",
    "set AuthorizedKeysFile	%h/.ssh/authorized_keys",
    "set PasswordAuthentication no",
    "set Port 22",
  ],
  notify => Service['sshd'],
 }
}
