node default {
  include git
  include users
  include ruby
  include sinatraservice
  include iptables
  include ssh
  include sudo
  include osharden
  include puppet-cron
}
