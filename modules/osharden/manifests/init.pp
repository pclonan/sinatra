class osharden {

  file { 'sysctl_conf':
    ensure => file,
    path   => '/etc/sysctl.conf',
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
  }

  augeas { "sysctl":
    context => "/files/etc/sysctl.conf",
    changes => [
      "set kernel.exec-shield 1",
      "set net.ipv4.ip_forward 0",
      "set net.ipv4.conf.all.send_redirects 0",
      "set net.ipv4.conf.default.send_redirects 0",
      "set net.ipv4.conf.all.accept_source_route 0",
      "set net.ipv4.conf.all.accept_redirects 0",
      "set net.ipv4.conf.all.secure_redirects 0",
      "set net.ipv4.conf.all.log_martians 1",
      "set net.ipv4.conf.default.accept_source_route 0",
      "set net.ipv4.conf.default.accept_redirects 0",
      "set net.ipv4.conf.default.secure_redirects 0",
      "set net.ipv4.icmp_echo_ignore_broadcasts 1",
      "set net.ipv4.tcp_syncookies 1",
      "set net.ipv6.conf.all.disable_ipv6 1",
      "set net.ipv6.conf.default.disable_ipv6 1",
      "set net.ipv6.conf.default.accept_redirects 0",
      "set net.ipv6.conf.default.accept_ra 0",
      "set fs.suid_dumpable 0",
      "set kernel.dmesg_restrict 1",
    ],
  }

  exec { "sysctl":
    command     => "/sbin/sysctl -p",
    refreshonly => true,
    subscribe   => File["sysctl_conf"],
  }

  augeas { "/etc/sysconfig/network":
    context => "/files/etc/sysconfig/network",
    changes => [
      "set NETWORKING_IPV6 no",
    ],
    notify  => Service['network'],
  }

  service { 'network':
    ensure => running,
    enable => true,
  }

  service { [ 'snmpd',
      'apmd',
      'bluetooth',
      'firstboot',
      'tftp-server',
      'hidd',
      'kdump.service',
      'kudzu',
      'microcode_ctl',
      'readahead_early',
      'readahead_later' ]:
    ensure => stopped,
    enable => false,
  }

}
