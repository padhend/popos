#!/bin/sh
if [ $USER != "root" ]
then
    echo "Not root ... exiting"
else
  sudo su -
fi
