cat <<EOF> /tmp/install_ruby.sh
#!/bin/bash
su -l appuser <<EOSU
gpg --keyserver hkp://pool.sks-keyservers.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
curl -sSL https://get.rvm.io | bash -s stable
source ~/.rvm/scripts/rvm
rvm requirements
rvm install 2.4.1
rvm use 2.4.1 --default
gem install bundler -V --no-ri --no-rdoc
ruby -v > /tmp/ruby_version
bundle -v >> /tmp/ruby_version
EOSU
EOF

chmod +x /tmp/install_ruby.sh
/tmp/install_ruby.sh

cat <<EOF> /tmp/install_mongodb.sh
#!/bin/bash
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927
sudo bash -c 'echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse" > /etc/apt/sources.list.d/mongodb-org-3.2.list'
sudo apt-get update
sudo apt-get install -y mongodb-org

sudo systemctl start mongod
sudo systemctl enable mongod
sudo systemctl status mongod
EOF

chmod +x /tmp/install_mongodb.sh
/tmp/install_mongodb.sh

cat <<EOF> /tmp/deploy.sh
#!/bin/bash
su -l appuser -c 'git clone https://github.com/Artemmkin/reddit.git'
su -l appuser -c 'cd reddit && bundle install && puma -d'
EOF

chmod +x /tmp/deploy.sh
/tmp/deploy.sh