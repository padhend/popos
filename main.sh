#!/bin/sh
if [ $USER != "root" ]
then
    echo "Not root ... exiting"
else
  sudo su -
fi
echo "neil ALL = (root) NOPASSWD : ALL" > /etc/sudoers.d/neil
exit

## update  the OS
sudo add-apt-repository universe -y
sudo add-apt-repository multiverse -y
sudo apt update && sudo apt upgrade -y

## Set up Flatpak
flatpak remote-add --user --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

## Flathub: Install some stuff
flatpak install flathub com.visualstudio.code -y
flatpak install flathub org.jdownloader.JDownloader -y
flatpak install flathub com.brave.Browser -y
flatpak install flathub io.github.mimbrero.WhatsAppDesktop -y
flatpak install flathub org.nmap.Zenmap -y
# flatpak install flathub org.flameshot.Flameshot -y
flatpak install flathub net.cozic.joplin_desktop -y
flatpak install flathub org.remmina.Remmina -y
flatpak install flathub net.devolutions.RDM -y
flatpak install flathub eu.betterbird.Betterbird -y
flatpak install flathub org.freefilesync.FreeFileSync -y
flatpak install flathub io.gitlab.news_flash.NewsFlash -y

## Generate ssh Keys
ssh-keygen -t ed25519 -C "popos"

## Install some stuff
sudo apt install -y \
neofetch \
flameshot \
caffeine \
gparted \
gnome-tweaks \
ubuntu-restricted-extras \
synaptic \
git \
libavcodec-extra \
libdvd-pkg \
dconf-editor \
gnupg2

sudo dpkg-reconfigure libdvd-pkg

## Change to 24hr clock
gsettings set org.gnome.desktop.interface clock-format 24h

## Restore minimise / maximise
gsettings set org.gnome.desktop.wm.preferences button-layout ":minimize,maximize,close"

## Show Battery Percentage
gsettings set org.gnome.desktop.interface show-battery-percentage true

## Install 1Password
wget https://downloads.1password.com/linux/debian/amd64/stable/1password-latest.deb

## Install MEGA

