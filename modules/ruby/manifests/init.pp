class ruby {

  $rubypackages = ['rh-ruby24','rh-ruby24-rubygem-bundler']
  Package { ensure => 'installed' }

  package { 'centos-release-scl': }
  package { $rubypackages:
    require => Package['centos-release-scl'],
  }
}
