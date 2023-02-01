#############################################################################
#
# Dockerfile FlexBerry/docker/Dockerfile.dev
#
# Make a docker for gcc and friends; include git, vim etc.
#   Bib: https://docs.docker.com/engine/reference/commandline/build/
#
# cd  $HOME/git/external/FlexBerry/docker
# docker build --tag flexdev:v1 - < Dockerfile.dev
#
#    -- docker --  Tie the local directory into docker at ':' place          image name
# docker run -it  -v $HOME/git/external/FlexSpec1:/home/flex/git/FlexSpec1   flexdev:v1
#
#                    ---   Windows way USE THE QUOTES  ----
# docker run -it -v "C:/users/Someone/git/that:/home/flex/git/that"          flexdev:v1
#
# apt list --upgradable #  to see them
#
#
#############################################################################
FROM ubuntu:22.04

LABEL maintainer="Wayne Green <dxwayne@gmail.com>"
LABEL build_date="2022-10-10"

ENV DEBIAN_FRONTEND=noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN=true

RUN apt-get -y update                       # the latests lists
RUN apt-get install -y apt-utils            # get the new list
Run apt-get -y upgrade                      # grab the upgrade things.
# keep the packages inside this continer (HUGE!!!)
# rm -rf /var/cache/apt/archives/*.deb # when done

RUN apt-get install -y build-essential      # Compiler and friends
RUN apt-get install sudo                    # the sudo command
RUN apt-get install -y cmake                # needed for ArduinoJson and others...
RUN apt-get install -y python3-pip

# Create a basic user with /home/flex and password of flex.
RUN useradd --shell /bin/bash -m -d /home/flex -G dialout -p "$(openssl passwd -1 'flex')" flex
RUN usermod -aG sudo flex                   # add flex to sudoers
RUN chown -R flex:flex /home/flex
RUN usermod -p "$(openssl passwd -1 'flex')" root # let sudo work with a passwd

RUN apt-get install -y curl                 # because,,, curl! (astrometry.net)
RUN apt-get install -y gawk                 # IDIOTS -- don't ever use mawk!
RUN apt-get install -y vim                  # because,,, vi!
RUN apt-get install -y nginx                # nginx local access to bokeh
RUN apt-get install -y apache2-utils        # for auth with usernames and passwords
RUN apt-get install -y sqlite3              # lightweight database for general use.

# create default passwords for flex and our flex default user.
RUN htpasswd -cb /etc/nginx/.htpasswd flex  "flex"
RUN htpasswd -b  /etc/nginx/.htpasswd flex  "flex"         # TODO  make more secure.

RUN bash -c 'rm /etc/alternatives/editor; ln -s /usr/bin/vim.basic /etc/alternatives/editor;'

RUN apt-get install -y git                  # because,,, git! (astrometry.net)
RUN apt-get install -y python3-pip          # brings loads of stuff.
RUN apt-get install -y python3-virtualenv   # good practice

RUN apt-get install -y python3-dev \        # things to get for systemwide python
	                   python3-astropy \
	                   python3-numpy \
	                   python3-scipy \
	                   python3-setuptools \
	                   python-is-python3

RUN cd /home/flex                                                        && \
    mkdir -p /home/flex/git && cd /home/flex/git                         && \
    cd /home/flex/git                                                    && \
    git clone https://github.com/The-SMTSci/FlexSpec1.git

# necessary for FlexSpec Arduino work.
RUN cd /home/flex/git                                                    && \
    git clone https://github.com/bblanchon/ArduinoJson.git

RUN cp /home/flex/git/FlexSpec1/Code/HOME/pi.aliases /home/flex/.aliases && \
    cp /home/flex/git/FlexSpec1/Code/HOME/vimrc      /home/flex/.vimrc   && \
    cp /home/flex/git/FlexSpec1/Code/HOME/vimrc      /root/.vimrc        && \
    chown root:root /root/.vimrc

RUN echo 'source .aliases' >> /home/flex/.bashrc

RUN chown -R flex:flex /home/flex           # make us own us

# wake up as flex, use su root or use sudo
# run -it ... --user root ... to wake up as root
# this line wakes up as 'us' = flex in our home dir
USER     flex
WORKDIR  /home/flex

# wake up in the bash shell not dash
CMD      /bin/bash

