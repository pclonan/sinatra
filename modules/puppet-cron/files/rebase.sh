cd /etc/puppet
rm -rf .git modules manifests
git init
git remote add origin https://github.com/pclonan/sinatra.git
git config core.sparsecheckout true
echo -e "modules/*\nmanifests/*" >> .git/info/sparse-checkout
git pull --depth=1 origin master
puppet apply /etc/puppet/manifests/default.pp