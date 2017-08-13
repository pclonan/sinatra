#!/bin/bash

cd /apps/simple-sinatra-app
source /opt/rh/rh-ruby24/enable
bundle install
bundle exec rackup -p 80 -o 0.0.0.0