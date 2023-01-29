# FlexBerry

**WARNING: UNDER ACTIVE DEVELOPMENT JAN 2023**

````
FollowMe.sh usage..."
  Change directory to your home directory."                            
                                                                 
     wget https://github.com/The-SMTSci/FlexBerry/blob/main/RPi/Follow"
                                                                   
  Then run the script to change your RPi into a FlexBerry:"            
                                                                   
  The FollowMe script takes two parameters:"                           
    1) The desired hostname"                                           
    2) The desired username"                                           
                                                                  
     sudo bash FollowMe.sh flexberry itsme"                            
                                                                   
  This will take quite a while. There are over 30 packages to install."
````

Overview
--------

A Raspberry Pi 4b implementation of Ubuntu 22.04 Desktop (not raspbian) for coordinated astronomy.

1) Click on the green CODE button above.
2) Choose the 

The Ununtu 22.04 64 bit OS is created to serve as a central hub of a network of other pi's for local to global use. It uses systemd, supervisor, gnuicorn, nginx, flask, bokeh to allow WEB APIs for controlling our FlexSpec1 project.

It supports DNS and a basic ufw firewall. It uses the Ubuntu raspbian-utilities to enable the UART and other features of the basic RPi.

This project is mainly few start up scripts to tune the OS and its daemons and to install Kstars/Ekos/libindi. A few other features may exist. 

Under the hood, a general blog-based inter-node communications app will allow realtime coordination of observations between those signed into an activity.

A stretch goal is to manage alerts and scheduling. 

Current status is rough-as-a-cob.

Download the [Ubuntu 22.04 for Raspberry](https://ubuntu.com/download/raspberry-pi)
Burn onto a larger SD card
Boot the Raspberry Pi, take the quiz.
#. User Name and Machine name.
Reboot the RPi, run the few commands.

Use these commands to get the FlexBerry github repository and use a script it contains to help build the complete system.

    sudo apt update
    sudo apt upgrade
    sudo apt install -y git
    sudo mkdir -p /home/git
    sudo chown -R $USER:$USER /home/git
    cd /home/git
    git clone https://github.com/The-SMTSci/FlexBerry.git
    cd /home/git/FlexBerry/Code/linux/FollowMe.sh
    
Follow the **FollowMe.sh** script, found inside the clone under **FlexBerry/Code/linux/FollowMe.sh**
