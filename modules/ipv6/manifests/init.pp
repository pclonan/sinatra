class ipv6 {
  augeas { "/etc/sysconfig/network":
    context => "/files/etc/sysconfig/network",
    changes => [
      "set NETWORKING_IPV6 no",
    ],
    notify => Service['network'],
  }
  augeas { "/etc/sysctl.conf":
    context => "/files/etc/sysctl.conf",
    changes => [
      "set net.ipv6.conf.all.disable_ipv6 1",
      "set net.ipv6.conf.default.disable_ipv6 1",
    ],
  }
  service { 'network':
    ensure => running,
    enable => true,
}
