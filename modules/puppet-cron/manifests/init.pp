class puppet-cron {

  file { 'rebase.sh':
    ensure  => file,
    path    => '/etc/puppet/rebase.sh',
    source  => 'puppet:///modules/puppet-cron/rebase.sh',
    mode    => 0700,
    owner   => root,
    group   => root,
  }

  cron { 'puppet-apply':
    ensure  => present,
    command => "/etc/puppet/rebase.sh",
    user    => root,
    minute  => '*/30',
  }

}
