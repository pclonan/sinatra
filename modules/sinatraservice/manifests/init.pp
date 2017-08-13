class sinatraservice {
  file { '/apps':
    ensure => directory,
    owner => 'root',
    group => 'root',
    mode => '0644',
  }
  file { '/apps/simple-sinatra-app/sinatra.sh':
    ensure => file,
    source  => 'puppet:///modules/sinatraservice/sinatra.sh',
    owner   => '500',
    group   => '500',
    mode    => '0750',
    notify  => Service['sinatra.service'],
    require => [ Vcsrepo['/apps/simple-sinatra-app'], User['sinatra'] ],
  }
  file { '/etc/systemd/system/sinatra.service':
    ensure => file,
    source => 'puppet:///modules/sinatraservice/sinatra.service',
    owner => 'root',
    group => 'root',
    mode => '0644',
    notify  => Service['sinatra.service'],
  }
  vcsrepo { '/apps/simple-sinatra-app':
    ensure   => latest,
    provider => git,
    source   => 'https://github.com/rea-cruitment/simple-sinatra-app',
    revision => 'master',
    require => File['/apps'],
  }
  service { 'sinatra.service':
    ensure => running,
    enable => true,
  }
}
