node default {
  include git
  include users
  include ruby
  include sinatraservice
  include iptables
  include sudo
  include puppet-cron
}
