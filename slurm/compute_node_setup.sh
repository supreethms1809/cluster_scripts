wget https://github.com/dun/munge/releases/download/munge-0.5.16/munge-0.5.16.tar.xz
tar -xvf munge-0.5.16.tar.xz
cd munge-0.5.16/

# Install Munge for authentication
# https://github.com/dun/munge/wiki/Installation-Guide
wget https://github.com/dun/munge/releases/download/munge-0.5.16/munge-0.5.16.tar.xz
tar -xvf munge-0.5.16.tar.xz
cd munge-0.5.16/
sudo apt-get install bzip2 zlib1g-dev pkgconf libgcrypt20-dev -y
./configure \
     --prefix=/usr \
     --sysconfdir=/etc \
     --localstatedir=/var \
     --runstatedir=/run
make
sudo make install

# Generate the munge key
sudo -u munge /usr/sbin/mungekey --verbose
sudo cp /etc/munge/munge.key /etc/munge/munge.key.bak
#/etc/munge/munge.key
sudo chmod 0600 /etc/munge
sudo systemctl enable munge.service
sudo systemctl start munge.service
sudo systemctl stop munge.service

