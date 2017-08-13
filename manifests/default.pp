node default {
  include git
  include users
  include ruby
  include sinatraservice
  include iptables
  include ipv6
  include ssh
  include sudo
  include execshield
  include puppet-cron
}
