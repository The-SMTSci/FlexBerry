#!/bin/bash
#############################################################################
# FlexSpec1 - FollowMe.sh -- the script to follow when putting together
#   The raspberry pi script.
#
# Note: This script is located in a github repo: Kinda need that
#
# /home/git/FlexSpec1/Code/rpi/FollowMe.sh
#
# We won't install:
#    ds9   -- run it on your machine
#
# We will  install:
#    astrometry.net (that is handy locally)
#    sextractor
#
# Try to make this for multiple users (i.e. schools; shared facility users.)
#
# git/external/FlexSpec1/Code/rpi/FollowMe.sh
# 2022-09-19T16:15:12-0600 wlg
#
#############################################################################
# ssh -l pier15 pier15.local  # see remove old key above
# HEREHEREHERE
# SYSTEMFILESNOW
# BLEADINGEDGE

echo "FollowMe.log" > /tmp/FollowMe.log
echo $(date) >> /tmp/FollowMe.log

function usage   { echo "FollowMe.sh usage..."
                   echo "  Change directory to your home directory."
                   echo ""
                   echo "     wget https://github.com/The-SMTSci/FlexBerry/blob/main/RPi/Follow"
                   echo ""
                   echo "  Then run the script to change your RPi into a FlexBerry:"
                   echo ""
                   echo "  The FollowMe script takes two parameters:"
                   echo "    1) The desired hostname"
                   echo "    2) The desired username"
                   echo ""
                   echo "     sudo bash FollowMe.sh flexberry itsme"
                   echo ""
                   echo "  This will take quite a while. There are over 30 packages to install."

                   if test -e /sys/firmware/devicetree/base/model ; then
                       echo $(cat /sys/firmware/devicetree/base/model);
                   fi
                 }

if [[ ! "root" =~ "$USER" ]] ; then
   echo "Must be root, not $USER, to run. Use 'sudo -s bash FollowMe.sh' in terminal.";
   usage
   exit 1
fi

APTINSTALL="install -qq"                    # Hey apt, errors only please...
PIPQUIET="--quiet"                          # ...pip too

# make sure we have at least two parameters, hope they are in right
# order.
if [[ "$#" != 2 ]] ; then
   echo "FollowMe expects two parameters, found $#"
   echo "   sudo bash FollowMe hostname username"
   echo ""
   usage
   exit 1
fi

##############################################################################
# Process the parameters and get teh hostname and username in gear.
#
##############################################################################
scriptargs=("$@")
export FLEXHOST=${scriptargs[0]}            # pick up the user for this script
export FLEXUSER=${scriptargs[1]}            # pick up the user for this script
echo "Using host=$FLEXHOST  user=$FLEXUSER" >> /tmp/FollowMe.log


# good idea to do this when run if Flexspec user late to the party.
apt-get update
apt-get upgrade                          # N - keep the provider's /etc/apt-fast.conf
apt-get dist-upgrade
# (accumulate a) list of packages to make sure we have.
flexpackages=("openssh-server" "linux-modules-extra-raspi" "net-tools" \
                  "gh" "curl" "gawk" "vim" "minicom" "git" "locate" "libx11-dev" \
                  "zlib1g-dev" "libxml2-dev" "libxslt1-dev" "autoconf" "swig" "putty" \
                  "python3-dev" "python3-pip" "python3-virtualenv" "sqlite3" \
                  "pip" "sqlitebrowser" "supervisor" "samba" "samba-tools" \
                  "build-essential" "apache2-utils" "filezilla" \
                  "nginx" "sqlite3" "indi-full" "gsc" "iraf" "python-pyraf3" )

basepackages=("ufw" "systemctl" "bind9")

pythonpackages=( "numpy" "scipy" "pandas" "matplotlib" "bokeh" "pandas" \
                   "astropy" "gunicorn" "pysqlite3" "xpa" )

echo "Base Packages" >>/tmp/FollowMe.log
(for v in ${basepackages[@]} ; do echo "  $v" ; done) >>/tmp/FollowMe.log

echo "Flex Packages" >>/tmp/FollowMe.log
(for v in ${flexpackages[@]} ; do echo "  $v" ; done) >>/tmp/FollowMe.log

echo "Python modules" >>/tmp/FollowMe.log
(for v in ${pythonpackages[@]} ; do echo "  $v" ; done) >>/tmp/FollowMe.log


#############################################################################
# The real work as root.
#############################################################################

# Make sure we have git and github's authentication
# https://github.com/cli/cli/blob/trunk/docs/install_linux.md
if [[ "$(which git)" == "" ]] ; then
    apt $(APTINSTALL) git -y;
    type -p curl >/dev/null || apt $(APTIVSTALL) curl -y  # insgall curl as needed.
    curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg && \
        chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg && \
        echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null     && \
        apt update
fi

mkdir -p /home/git
cd /home/git
git clone https://github.com/The-SMTSci/FlexSpec1.git

echo "Cloned The-SMTSci/FlexSpec1.git" >> /tmp/FollowMe.sh

# get my local net, using...
#export mylocalnet=$(ip r | gawk -- '/kernel/ {printf("%s", $1);}')

#hostnamectl set-hostname pier15          # force hostname

# add the main owner/user, all system configuration activity here.
if test ! -e /home/$FLEXUSER; then
    useradd -m -d /home/$FLEXUSER -G dialout -p "$(openssl passwd -1 'happy startrails')" $FLEXUSER

    usermod -aG dialout $FLEXUSER     # allow user 'flex' ability to use facilities
    usermod -aG tty     $FLEXUSER
fi
echo "Added user $FLEXUSER" >> /tmp/FollowMe.sh

# load up on packages!

apt $(APTINSTALL) gh -y
cat >> /home/$FLEXUSER/todo.txt <<EOF1
Github:
  - Using browser, login into your account
  - Under your icon -> settings
  - Choose "SSH and GPG keys"
  - Get past any two-layer auth business (I use google authenticator)
  - Generate a classical token
  - It will appear ONCE -- yeah ONCE so copy/paste it somewhere to be remembered
  -   it looks something like: ghp_nng.............................
  - Run "gh login" on the pi
  - Do these steps:
  -
EOF1


# the bash/gui tool for optional things to handle
# if [[ ! "zenity" =~ "zenity" ]] ;then
#    apt  $(APTINSTALL) -y zenity;
# fi
# zenity --forms --title="Create" --text="Options" \
#    --add-entry="hostname" \
#    --add-entry="username" 2>/dev/null
# ask about packages... question returns 0=yes 1=no
# zenity --question --text="Include IRAF/PyRAF?" 2>/dev/null
# addiraf=$?
# zenity   --question --text="Include Astromenry.net?" 2>/dev/null
# addan=$?
# options: iraf/astrometry.net/photometry/kstars vs libindi/samba/nfs

######################### Initial Batch of Installs #########################
# apt-get remove --purge libreoffice*              # remove libreoffice
# apt clean
apt     $(APTINSTALL) -y ufw                       # uncomplicated firewall
apt     $(APTINSTALL) -y openssh-server            # add openssh capability
systemctl --no-pager status ssh                    # open the interface
##apt install -y supervisor                         # easily manage our servers TODO why less?

apt     $(APTINSTALL) -y linux-modules-extra-raspi # raspi-config hardware/boot bridge
apt     $(APTINSTALL) -y net-tools                 # both ip ifconfig worlds
aot     $(APTINSTALL) -y nmap                      # handy for network poking.
apt     $(APTINSTALL) -y curl                      # because,,, curl! (astrometry.net)
apt     $(APTINSTALL) -y gawk                      # IDIOTS -- don't ever use mawk!
apt     $(APTINSTALL) -y vim                       # because,,, vi!

echo "First load of basic packages" >> /tmp/FollowMe.log
# Force VI as the editor. Really.
if test -e /etc/alternatives/editor ; then
   if test -e /usr/bin/vim.basic ; then
       ln -s /usr/bin/vim.basic /etc/alternatives/editor
   fi
fi
echo "Fixed up VIM" >> /tmp/FollowMe.log

apt     $(APTINSTALL) -y minicom                   # because,,, handy interface to serial
apt     $(APTINSTALL) -y putty                     # install putty

echo "Added minicom and putty" >> /tmp/FollowMe.log



# Load these packages now, get it over with for local compiles.
# Handy anyway.
apt     $(APTINSTALL) -y locate                    # bacause,,, locate!
apt     $(APTINSTALL) -y build-essential           # get the compilers...
apt     $(APTINSTALL) -y libx11-dev                # needed for local compiles
apt     $(APTINSTALL) -y zlib1g-dev                # needed for local compiles
apt     $(APTINSTALL) -y libxml2-dev               # needed for local compiles
apt     $(APTINSTALL) -y libxslt1-dev              # needed for local compiles
apt     $(APTINSTALL) -y autoconf                  # needed for local compiles
echo "Second batch of basic packages: X11, build, autoconf etc." >> /tmp/FollowMe.log

# robustify the python
apt     $(APTINSTALL) -y swig
apt     $(APTINSTALL) -y python3-dev python3-pip python3-virtualenv
echo "Robustified python" >> /tmp/FollowMe.log

#############################################################################
# This is a dedicated system, pound our opinion of python at the
# system level, not a virtualenv.
# Load up Python3 with the extra bits we really want.
# These support the FlexSpec Bokeh information, other visualizations.
#############################################################################
apt $(APTINSTALL) -y sqlite3   sqlitebrowser       # lightweight database for general use.
apt $(APTINSTALL) -y pip
#apt install pypy
pip3 $(APTINSTALL) virtualenv    $PIPQUIET         # allow venvs
pip3 $(APTINSTALL) bokeh         $PIPQUIET         # important to flexspec
pip3 $(APTINSTALL) gunicorn      $PIPQUIET         # important to flexspec
pip3 $(APTINSTALL) numpy         $PIPQUIET         # the sciency stuff
pip3 $(APTINSTALL) scipy         $PIPQUIET
pip3 $(APTINSTALL) pandas        $PIPQUIET
pip3 $(APTINSTALL) matplotlib    $PIPQUIET
pip3 $(APTINSTALL) pandas        $PIPQUIET
pip3 $(APTINSTALL) astropy       $PIPQUIET         # astronomy stuff
pip3 $(APTINSTALL) pysqlite      $PIPQUIET         # support basic database

echo "Pip packges flex needs for python" >> /tmp/FollowMe.log


#############################################################################
# Load up Kstars/Ekos/libindi and drivers.
# User chooses what extra stuff after this script runs
#############################################################################
apt-add-repository ppa:mutlaqja/ppa                # Libindi etc.
apt     update
apt     $(APTINSTALL)  -y indi-full                # indi and all drivers, never know.
apt     $(APTINSTALL)  -y kstars-bleeding          # get the most up-to-date ekos
#apt     $(APTINSTALL)  -y gsc                     # this is massive, ignore
#apt     install -y kstars-bleeding

echo "Added kstars" >> /tmp/FollowMe.log

#############################################################################
# Add handy user code
#############################################################################
apt $(APTINSTALL) -y filezilla                     # GUI to move files between systems

echo "Added filezilla" >> /tmp/FollowMe.log

# HEREHEREHERE
#############################################################################
# Grab the initialization scripts,files and data from FlexSpec needs....
# fixup $FLEXUSER/.bashrc
#############################################################################
if test ! -e " /home/$FLEXUSER" ; then
    mkdir -p /home/$FLEXUSER/git                       # local repos in user space
    cd     /home/$FLEXUSER/git                         # get the FlexSpec and install
    git    clone https://github.com/The-SMTSci/FlexSpec1.git
    export ANCHOR=/home/$FLEXUSER/git/FlexSpec1
    cd     /home/$FLEXUSER/git/FlexSpec1/Code/HOME
    cp     pi.aliases /home/$FLEXUSER/.pi.aliases      # handy aliases
    cp     vimrc      /home/$FLEXUSER/.vimrc
    cp     vimrc      /root                            # add a decent vimrc for sudo
    mkdir -p /var/www/html/FlexSpec1
    cp     -pr /home/$FLEXUSER/git/FlexSpec1/build/html/* /var/www/html/FlexSpec1 # install FlexHelp
    cd     /home/$FLEXUSER

    # allow aliases for remote flex login. PuTTY uses .profile
    echo "source /home/$FLEXUSER/.pi.aliases" > /home/$FLEXUSER/.bashrc
    echo "source /home/$FLEXUSER/.pi.aliases" > /home/$FLEXUSER/.profile
fi

echo "Updated user's homedir with aliases and rc files" >> /tmp/FollowMe.log


#############################################################################
# Add Iraf/Pyraf! Yea.
#############################################################################

apt install -y iraf
apt install -y python-pyraf3

echo "Added IRAF/PyRAF3" >> /tmp/FollowMe.log

# make the user own their files
chown -R $FLESUSER .                         # give all the files to the user.

echo "Made user own their home directory" >> /tmp/FollowMe.log

#############################################################################
#############################################################################
# Syystem files from here on. search SYSTEMFILESNOW from the top to get here
#############################################################################
#############################################################################
# SYSTEMFILESNOW



#############################################################################
# Add some file connectivity.
# SMB is for WinX
# NFS is for unix-unix.
# DIFS is Common Internet Fileshares
#############################################################################
apt install -y samba samba-tools smbclient cifs-utils
$(printf "[$FLEXUSER]\n   path = /samba/$FLEXUSER\n   available = yes\n   valid users = $FLEXUSER\n   read only = no\n   browsable = no\n   public = yes\n   writable = yes\n   force create mode = 0600\n   force directory mode = 2770\n   valid users = $FLEXUSER @sadmin") >> /etc/samba/smb.conf

systemctl --no-pager enable --now smbd             # register for all reboots

usermod -aG sambashare $FLEXUSER                   # let $FLEXUSER share with smb.
smbpasswd -w "flex%time has come" $FLEXUSER        # initial password...
mkdir -p /samba/{$FLEXUSER}                        # make shares for the two main users
chgrp -R sambashare /samba

#smb://winhost/shared-folder-name
# TODO mod /etc/samba/smb.conf
systemctl --no-pager restart smbd                  # Start the SMB service
systemctl --no-pager restart nmbd                  # Microsoft NETBIOS stuff

echo "Setup SMB" >> /tmp/FollowMe.log


#############################################################################
# NFS - for other linux like clients
#############################################################################
apt install -y nfs-kernel-server
mkdir -p /mnt/share
chown -R nobody:nogroup /mnt/share/
chmod 777 /mnt/share/
exportfs -a
systemctl --no-pager restart nfs-kernel-server     # start nfs
echo "Setup NFS" >> /tmp/FollowMe.log

# add daemons
# cp ANCHOR/bokeh/bokeh.service /etc/systemd/system/bokeh.service
# cp ANCHOR/bokeh/flexdispatch.service /etc/systemd/system/bokeh.service
# systemctl daemon-reload
# systemctl enable bokeh.service

#############################################################################
# Install and configure nginx
#   apt install -y nginx
#   cp the files from FlexSpec repo into place
#
#############################################################################

apt install -y nginx                               # nginx local access to bokeh
apt install -y apache2-utils                       # for auth with usernames and passwords
# create default nginx passwords for $FLEXUSER and our flex default user.
htpasswd -cb /etc/nginx/.htpasswd $FLEXUSER "PwD4$FLEXUSER"
htpasswd -b  /etc/nginx/.htpasswd flex  "Flex"     # TODO  make more secure.

mkdir -p /var/log/nginx/flexspec/                  # create a logfile directory
# create access and error logs for our instrument in usual place.
touch /var/log/nginx/flexspec/{access,error}.log   # and handy files for nginx
# install our pre-backed files
cp -pr $ANCHOR/FlexBerry/nginx/sites-available/flexspec/* /etc/nginx/sites-available/flexspec
cp -pr $ANCHOR/FlexBerry/nginx/nginx.conf /etc/nginx/ # with logfile format.
pushd /etc/nginx/sites-enabled
ln -s ../sites-available/flexspec  flexspec        # link this in as enabled
popd
mkdir -p /var/www/html
pushd /var/www/html
mkdir FlexSpec
ln -s FlexSpec flexspec                            # allow lowercase name maintain case sensitivity
# make the nginx content
#echo "make nginx"                                 # TODO

# get it operational now.
systemctl --no-pager restart nginx

echo "Setup nginx" >> /tmp/FollowMe.log


# Get the CIDR net/mask

#setxkbmap us  # needed because initial install went sideways

# ip -4 show $netinterface
# ssh root@titan.local -N -D 5006

#############################################################################
# Allow DNS as a subdomain controler.
#############################################################################
apt install -y bind9 bind9-utils                   # DNS

echo "Setup bind" >> /tmp/FollowMe.log


#############################################################################
# ufw : Brew up and activate a sloppy IPTABLES for the firewall
# /etc/ufw/before.rules   # files of interest
# /etc/ufw/user.rules
# /etc/ufw/user6.rules
#############################################################################
# make sure to gawk -- the default is too puny.
netinterface=$(ip -f inet -o addr | gawk -e '/e(th|no)[0-9]/ { print $2;}')
cidrnet=$(ip -f inet -o addr | gawk -e '/e(th|no)[0-9]/ { print $4;}')

ufw allow in on $netinterface from $cidrnet
ufw allow ssh                                        # allow ssh in the firewall
ufw allow dns                                        # bind9
ufw allow from $cidrnet to any port 5006 proto tcp   # Bokeh
ufw allow from $cidrnet to any port 5006 proto udp
ufw allow from $cidrnet to any port 7654 proto tcp   # libindi
ufw allow from $cidrnet to any port 7654 proto udp
ufw allow from $cidrnet to any port  443 proto tcp   # https
ufw allow from $cidrnet to any port  443 proto udp
ufw allow from client_ip to any port samba
ufw allow from client_ip to any port nfs             # NFS share
ufw allow 1194/udp                                   # VPN
ufw allow 1194/tcp                                   # remember for next time TODO
ufw disable
ufw enable
echo "Setup UFW firewall IP tables." >> /tmp/FollowMe.log
ufw status >> /tmp/FollowMe.log

# BLEADINGEDGE

#############################################################################
# Netgate 100 setup: This is not on the FlexBerry RPi.
# https://www.netgate.com/resources/videos-configuring-openvpn-remote-access-in-pfsense-software
#############################################################################
#############################################################################
# Notes:
#  Github has its own package "gh" and requires additional work to get a
#    credential to use if two factor authentication has been enabled on
#    the account.
#
#----------------------------------------------------------------------------
#              Header Pin             https://pinout.xyz/pinout/uart
#   UART GPIO    Tx/Rx
#   0    14/15    8/10
#   1     0/1    27/28
#   2     4/5     7/29
#   3     8/9    24/21
#   4    12/13   32/33
#----------------------------------------------------------------------------
#
# raspi-config->Intrface Options->Serial Port
#  say "No"  to "Would you like login shell to be accessible over serial?"
#  say "Yes" to "Would you like the serial port hardware to be enabled? "
# FAT: config.txt
# dtoverlay=uart2
# dtoverlay=uart3
# dtoverlay=uart4
# dtoverlay=uart5
#----------------------------------------------------------------------------
# I2C    GPIO HEADER PIN
#   Data   2       3
#   Clock  3       5
#
#
#
#
#
#############################################################################


apt-get clean                               # remove all the package image files.
date  >> /tmp/FollowMe.log
echo "FollowMe Completed." >> /tmp/FollowMe.log
echo "FollowMe Completed."


# End of Followme.sh
