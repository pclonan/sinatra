class iptables {
  file { '/etc/sysconfig/iptables' :
    source  => 'puppet:///modules/iptables/iptables',
    owner   => 'root',
    group   => 'root',
    mode    => '0640',
    notify  => Service['iptables'],
    require => Package['iptables-services'],
  }
  package {'iptables-service':
    ensure => installed,
  }
  service { 'iptables': 
    ensure => running,
    enable => true,
  }
  service { 'firewalld':
    ensure => stopped,
    enable => false,
  }
}
