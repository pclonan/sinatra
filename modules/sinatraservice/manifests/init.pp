class sinatraservice {
  file { '/apps':
    ensure => directory,
  }
  vcsrepo { '/apps/simple-sinatra-app':
    ensure   => latest,
    provider => git,
    source   => 'https://github.com/rea-cruitment/simple-sinatra-app',
    revision => 'master',
  }
}
