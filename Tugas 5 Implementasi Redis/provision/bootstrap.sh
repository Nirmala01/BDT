sudo apt-get update -y
sudo apt-get install build-essential tcl -y
sudo apt-get install libjemalloc-dev  -y


sudo cp /vagrant/config/hosts /etc/hosts

sudo ufw allow from redismaster
sudo ufw allow from redisslave1
sudo ufw allow from redisslave2

sudo curl -O http://download.redis.io/redis-stable.tar.gz
sudo tar xzvf redis-stable.tar.gz
cd redis-stable
sudo make
sudo make test
sudo make install