# FlexBerry
A Raspberry Pi 4b implementation of Ubuntu 22.04 (not raspbian) for coordinated astronomy.

The Ununtu 22.04 64 bit OS is created to serve as a central hub of a network of other pi's for local to global use. It uses systemd, supervisor, gnuicorn, nginx, flask, bokeh to allow WEB APIs for controlling our FlexSpec1 project.
It supports DNS and a basic ufw firewall. It uses the Ubuntu raspbian-utilities to enable the UART and other features of the basic RPi.
This project is mainly few start up scripts to tune the OS and its daemons and to install Kstars/Ekos/libindi. A few other features may exist. 
Under the hood, a general blog-based inter-node communications app will allow realtime coordination of observations between those signed into an activity.
A stretch goal is to manage alerts and scheduling. 

Current status is rough-as-a-cob.

