class sudo {

  file {'/etc/sudoers.d/sinatra':
    ensure => file,
    source => 'puppet:///modules/sudo/sinatra',
    owner  => 'root',
    group  => 'root',
    mode   => '0600',
  }

}
