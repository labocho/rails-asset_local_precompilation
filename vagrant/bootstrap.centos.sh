#!/bin/sh
sudo yum upgrade -y
sudo timedatectl set-timezone Asia/Tokyo

# rbenv, ruby-build
sudo yum install -y git
git clone https://github.com/rbenv/rbenv.git ~/.rbenv
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bash_profile
echo 'eval "$(rbenv init -)"' >> ~/.bash_profile
source ~/.bash_profile
mkdir -p "$(rbenv root)"/plugins
git clone https://github.com/rbenv/ruby-build.git "$(rbenv root)"/plugins/ruby-build

yum install -y gcc bzip2 openssl-devel libyaml-devel libffi-devel readline-devel zlib-devel gdbm-devel ncurses-devel

# ruby
rbenv install 2.6.4
rbenv global 2.6.4
gem install bundler -v 2.0.2

# nodenv, ruby-build
git clone https://github.com/nodenv/nodenv.git ~/.nodenv
echo 'export PATH="$HOME/.nodenv/bin:$PATH"' >> ~/.bash_profile
echo 'eval "$(nodenv init -)"' >> ~/.bash_profile
source ~/.bash_profile
mkdir -p "$(nodenv root)"/plugins
git clone https://github.com/nodenv/node-build.git "$(nodenv root)"/plugins/node-build

# node
nodenv install 12.13.0
nodenv global 12.13.0
npm install -g yarn@1.19.1

# mysql
sudo yum install -y mariadb mariadb-server mariadb-devel
sudo systemctl enable mariadb
sudo systemctl start mariadb
echo "CREATE DATABASE asset_tasks CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci" | mysql -uroot --password=

# dependencies
yum install -y gcc-c++ ImageMagick

sudo mkdir -p /var/www/asset_tasks
sudo chown vagrant:vagrant /var/www/asset_tasks
