#!/bin/sh

##############################
## If not root, become root ##
##############################
if [ $USER != root ]; then
  sudo su -
fi
## Add your account to the sudoers file, so you dont have to keep typing the password 
echo "neil ALL = (root) NOPASSWD : ALL" > /etc/sudoers.d/neil
exit
