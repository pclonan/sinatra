class users {

  group { 'sinatra':
    ensure => present,
    gid    => '500',
  }

  user { 'sinatra':
    ensure   => present,
    uid      => '500',
    gid      => '500',
    home     => '/apps/simple-sinatra-app',
    password => '$1$E.xtE53M$3X7z418n5EKwXksH6C3Ey.',
    shell    => '/bin/bash',
  }

}
