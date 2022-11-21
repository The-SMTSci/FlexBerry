#############################################################################
# FollowMe.sh -- Docker Version
# 
# runs as root in the container
# 
# Run the docker, and tie to your main system's FlexBerry Clone.
# docker run -it -v /home/git/external/FlexBerry:/home/flex/FlexBerry ubuntu22.04:v4
# 
#############################################################################

useradd -m -d /home/flex -G dialout -p "$(openssl passwd -1 'happy startrails')" flex

usermod -aG dialout $USER
usermod -aG tty     $USER

apt-get update
apt-get upgrade                          # N - keep the provider's /etc/apt-fast.conf
apt-get dist-upgrade

apt install -y rsyslog                   # enable the logging facility
apt install -y openssh-server            # add openssh capability
apt install -y ufw

systemctl status ssh                     # open the interface

ufw allow ssh                            # open the firewall

#apt install -y linux-modules-extra-raspi # raspi-config hardware/boot bridge
#apt install -y net-tools                 # both ip ifconfig worlds


apt-get install -y curl                  # because,,, curl! (astrometry.net)
apt-get install -y gawk                  # IDIOTS -- don't ever use mawk!
apt-get install -y vim                   # because,,, vi!
apt install -y nginx                     # nginx local access to bokeh
apt install -y apache2-utils             # for auth with usernames and passwords
# create default passwords for $USER and our flex default user.
htpasswd -cb /etc/nginx/.htpasswd $USER "PwD4$USER"
htpasswd -b  /etc/nginx/.htpasswd flex  "Flex"         # TODO  make more secure.

# Force VI as the editor. Really.
if test -e /etc/alternatives/editor ; then
   if test -e /usr/bin/vim.basic ; then
       rm /etc/alternatives/editor;
       ln -s /usr/bin/vim.basic /etc/alternatives/editor;
   fi
fi

sudo apt install chromium-browser -y     # best overall side-effects

#apt-get install -y minicom               # because,,, handy interface to serial
apt-get install -y git                   # because,,, git! (astrometry.net)

git config --global user.email "me@example.com"
git config --global user.name  "Fred Flintstone"


# for astrometry.net
apt-get install -y swig

#############################################################################
# fixup .bashrc
#############################################################################
cd ~/git                                      # get the FlexSpec and install
git clone https://github.com/The-SMTSci/FlexSpec1.git
cd ~/git/FlexSpec1/Code/HOME
cp pi.aliases ~/.pi.aliases
cp vimrc      ~/.vimrc
cp vimrc /root                           # add a decent vimrc for sudo
cd

cat >> ~/.bashrc  <<EOF                       # add our aliases for USER
source .pi.aliases
EOF

#############################################################################
# This is a dedicated system, pound our opinion of python at the
# system level, not a virtualenv.
# Load up Python3 with the extra bits we really want.
# These support the FlexSpec Bokeh information, other visualizations.
#############################################################################
apt install -y sqlite3                      # lightweight database for general use.
#apt remove sqlitebrowser 
apt install -y supervisor


#############################################################################
# Get Python3 installed, workable, and capable of venvs
#############################################################################
python3 -V                                  # It is installed
#apt-get install -y python3-dev
#apt-get install -y python3-pip 
apt-get install -y pthon3-virtualenv

#apt-get install software-properties-common
#apt --list upgradable
#apt upgrade

python3 -m pip install --user --upgrade pip > /dev/null
#apt install -y pip
#apt install pypy
pip3 install numpy
pip3 install scipy
pip3 install pandas
pip3 install matplotlib
pip3 install bokeh
pip3 install pandas
pip3 install astropy
pip3 install gunicorn
pip3 install pysqlite3
pip3 install netifaces                      # requred for RunFlexSpec test.


mkdir -p /var/log/nginx/flexspec/
# create access and error logs for our instrument in usual place.
touch /var/log/nginx/flexspec/{access,error}.log
# install our pre-backed files
cp $ANCHOR/nginx/sites-available/flexspec /etc/nginx/sites-available/flexspec

# get it operational now.
service nginx restart


ufw allow in on eth0 from 10.1.10.0/16
ufw allow from 10.1.10.0/16 to any port 5006 proto tcp
ufw allow from 10.1.10.0/16 to any port 5006 proto udp

setxkbmap us  # needed because initial install went sideways

# ip -4 show eth0
# ssh root@titan.local -N -D 5006

#############################################################################
# Allow DNS as a subdomain controler.
#############################################################################
apt install -y bind9 bind9-utils

# 2022-09-27T12:57:14-0600 here we are!

