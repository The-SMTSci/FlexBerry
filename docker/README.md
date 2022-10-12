Docker README.md
================

FIle: FlexBerry/docker/README.md

Flexberry docker directory uses docker containers for cross
compile checks between a linux/Win10 machine and details
for use with the FlexBerry itself. This doesn't work too
well as the containers do not function well with systemctl
and other background task correlations out of the box.

Code to be compiled and used can be developed on the Win box
then integrated onto the RPi Arm processor and real Ubuntu
22.04 environment via the FollowMe.sh scripts.

    docker run -it --rm -v /home/git/external/FlexBerry/docker/data:/ \
                        -v /home/wayne/anaconda3/lib:/opt/lib \
                           sphinxdoc/sphinx-latexpdf /bin/bash

The details are in the file: 'Dockerfile.dev'.

