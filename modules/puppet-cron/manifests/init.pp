class puppet-cron {
    file { 'post-hook':
        ensure  => file,
        path    => '/etc/puppet/.git/hooks/post-merge',
        source  => 'puppet:///modules/puppet-cron/post-merge',
        mode    => 0755,
        owner   => root,
        group   => root,
    }
	    file { 'rebase.sh':
        ensure  => file,
		path => '/etc/puppet/rebase.sh',
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
        require => File['post-hook'],
    }
}
