# Check if the clocks are synchronized if not install ntp
sudo apt-get install ntp -y
sudo systemctl enable ntp
sudo systemctl start ntp

# OR
# sudo apt-get install chrony -y
# sudo systemctl enable chrony
# sudo systemctl start chrony

rsync -avz /etc/passwd /etc/group /etc/shadow /etc/gshadow root@192.168.1.2:/etc/
rsync -avz /etc/passwd /etc/group /etc/shadow /etc/gshadow root@192.168.1.3:/etc/
rsync -avz /etc/passwd /etc/group /etc/shadow /etc/gshadow root@192.168.1.4:/etc/
rsync -avz /etc/passwd /etc/group /etc/shadow /etc/gshadow root@192.168.1.5:/etc/

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

# Secure the munge installation
# https://github.com/dun/munge/wiki/Installation-Guide
# ${sysconfdir}/munge [/etc/munge]
# This directory will contain the daemon's key. Its permissions should be set to 0700.

# ${localstatedir}/lib/munge [/var/lib/munge]
# This directory will contain the daemon's PRNG seed file. On systems where a 
# file-descriptor-passing authentication method is used, this is also where the 
# daemon creates pipes for authenticating clients. Its permissions should be set 
# to 0711 if using file-descriptor-passing, or 0700 otherwise.

# ${localstatedir}/log/munge [/var/log/munge]
# This directory will contain the daemon's log file. 
# Its permissions should be set to 0700.

# ${runstatedir}/munge [/run/munge]
# This directory will contain the Unix domain socket for clients to communicate
# with the local daemon. It will also contain the daemon's pid file. This directory
# must allow execute permissions for all. Its permissions should be set to 0755.

# Generate the munge key
sudo -u munge /usr/sbin/mungekey --verbose
sudo cp /etc/munge/munge.key /etc/munge/munge.key.bak
#/etc/munge/munge.key
sudo chmod 0600 /etc/munge
sudo systemctl enable munge.service
sudo systemctl start munge.service
sudo systemctl stop munge.service
# sudo systemctl restart munge.service
## Or
# sudo /etc/init.d/munge start
# # sudo /etc/init.d/munge stop
# sudo -u munge /usr/sbin/munged 
## sudo -u munge /usr/sbin/munged --stop

# Download and extract the slurm tarball
wget https://download.schedmd.com/slurm/slurm-24.11.1.tar.bz2
tar -xvjf slurm-24.11.1.tar.bz2
cd slurm-24.11.1

# Use slurm configuration tool
# https://slurm.schedmd.com/configurator.html