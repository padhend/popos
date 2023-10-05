#!/bin/sh
if [ $USER != "root" ]
then
    echo "Not root ... exiting"
else
  sudo su -
fi
echo "neil ALL = (root) NOPASSWD : ALL" > /etc/sudoers.d/neil
exit

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
flatpak install flathub com.brave.Browser -y
flatpak install flathub eu.betterbird.Betterbird -y
flatpak install flathub org.freefilesync.FreeFileSync -y
flatpak install flathub io.gitlab.news_flash.NewsFlash -y

