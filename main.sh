#!/bin/sh

#####################
## Get the OS type ##
#####################

if [ -f /etc/os-release ]; then
  source /etc/os-release
else
  echo "os-release file doesnt exist"
  exit 1
fi
OS=${ID}
VERSION=${VERSION_ID}


echo $OS $VERSION

###################
## Update the OS ##
###################
cat << EOF >>  ~/.bash_aliases
alias update='sudo apt update && sudo apt upgrade -y'
EOF
source ~/.bashrc
update

####################
## Set up Flatpak ##
####################
sudo apt install -y flatpak
sudo apt install -y gnome-software-plugin-flatpak
flatpak remote-add --user --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

##############################
## Install Flathub packages ##
##############################y
flatpak install flathub org.jdownloader.JDownloader -y
flatpak install flathub org.nmap.Zenmap -y
flatpak install flathub org.freefilesync.FreeFileSync -y
flatpak install flathub io.gitlab.news_flash.NewsFlash -y

###############
## Bitwarden ##
###############
## I changed to appimage from the Bitwarden github rather than an unofficial Flatpak
## Download bitwarden Appimage
if [ ! -d $HOME/.bitwarden ]; then
  mkdir $HOME/.bitwarden
fi
wget https://github.com/bitwarden/clients/releases/download/desktop-v2024.4.1/Bitwarden-2024.4.1-x86_64.AppImage -P $HOME/.bitwarden

## Download desktop icon
wget https://github.com/bitwarden/brand/blob/main/icons/64x64.png -P $HOME/.bitwarden

## create the startmenu entry
cat << EOF > /usr/share/applications/Bitwarden.desktop
[Desktop Entry]
Name=Bitwarden
GenericName=Bitwarden
Exec=$HOME/.bitwarden/Bitwarden-2024.4.1-x86_64.AppImage
Terminal=false
Icon=$HOME/.bitwarden/64x64.png
Type=Application
Categories=Internet;
Version=2024.4.1
EOF

#######################
## Generate ssh Keys ##
#######################
if [ -d ~/.ssh/ ]; then
  chmod 700 .ssh/
  chmod 644 .ssh/id_rsa.pub
  chmod 600 .ssh/id_rsa
  eval "$(ssh-agent -s)"
  ssh-add ~/.ssh/id_rsa
  ## enter your passphrase
else
  ssh-keygen -t ed25519 -C "$USER@$(hostname)"
fi



########################
## Install some stuff ##
########################
sudo apt install -y \
neofetch \
spacefm \
curl \
vlc \
caffeine \
gparted \
gnome-tweaks \
ubuntu-restricted-extras \
gnome-extensions-app \
gnome-tweaks \
gnome-shell-extension-appindicator \
synaptic \
git \
libavcodec-extra \
libdvd-pkg \
dconf-editor \
openssh-server \
gnupg2

sudo dpkg-reconfigure libdvd-pkg

#######################
## Remove some stuff ##
#######################
sudo apt purge -y \
gnome-contacts \
gnome-online-accounts \
gnome-user-docs-de \
gnome-user-docs-es \
gnome-user-docs-fr \
gnome-user-docs-it \
gnome-user-docs-ja \
gnome-user-docs-pt \
gnome-user-docs-ru

####################
## Install VSCode ##
####################
sudo apt install -y wget gpg
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
rm -f packages.microsoft.gpg
sudo apt install apt-transport-https
sudo apt update -y
sudo apt install -y code

#################
## Install PIA ##
#################
wget https://installers.privateinternetaccess.com/download/pia-linux-3.5.7-08120.run -P ~/Downloads
chmod +x ~/Downloads/pia-linux-3.5.7-08120.run
~/Downloads/pia-linux-3.5.7-08120.run

###################
## Some Settings ##
###################
gsettings set org.gnome.desktop.interface clock-format 24h
gsettings set org.gnome.desktop.wm.preferences button-layout ":minimize,maximize,close"
gsettings set org.gnome.desktop.interface show-battery-percentage true

##################
## Install MEGA ##
##################
wget https://mega.nz/linux/repo/xUbuntu_22.04/amd64/megasync-xUbuntu_22.04_amd64.deb -P ~/Downloads
sudo apt install -y ~/Downloads/megasync-xUbuntu_22.04_amd64.deb

################
## Set up RDP ##
################
sudo apt install -y xrdp
sudo systemctl enable xrdp
sudo systemctl start xrdp
sudo ufw allow from 192.168.178.0/24 port 3389 proto tcp
echo gnome-session > ~/.xsession
chmod +x ~/.xsession

#############################
## Install Thorium Browser ##
#############################
wget https://dl.thorium.rocks/debian/dists/stable/thorium.list
sudo mv thorium.list /etc/apt/sources.list.d/
sudo apt update
sudo apt install -y thorium-browser

##################
## Remove Snaps ##
##################
snap --version
snap list

sudo snap remove firefox
sudo snap remove gtk-common-themes
sudo snap remove gnome-3-38-2004
sudo snap remove gnome-42-2204
sudo snap remove snapd-desktop-integration
sudo snap remove snap-store
sudo snap remove core20
sudo snap remove bare
sudo snap remove core22
sudo snap remove snapd

snap list

sudo systemctl stop snapd
sudo systemctl disable snapd
sudo systemctl mask snapd
sudo apt-mark hold snapd
sudo rm -rf ~/snap/

sudo cat <<EOF | sudo tee /etc/apt/preferences.d/nosnap.pref
Package: snapd
Pin: release a=*
Pin-Priority: -10
EOF

sudo rm -rf ~/snap
sudo rm -rf /snap
sudo rm -rf /var/snap
sudo rm -rf /var/lib/snapd

#####################
## Install Yubikey ##
#####################
sudo apt install -y yubioath-desktop yubikey-agent

####################
## Enable Ironkey ##
####################
sudo apt install -y lib32gcc-s1
## Plug in the IronKey and mount the unencrypted partition
lsblk
if [ ! -d /mnt/ironkey ]; then
  sudo mkdir /mnt/ironkey
fi
if [ ! -d /mnt/encrypted ]; then
  sudo mkdir /mnt/encrypted
fi
if grep -qs '/dev/sr0 ' /proc/mounts; then
    sudo umount /dev/sr0
fi
if grep -qs '/dev/sr0 ' /proc/mounts; then
  sudo mount -o loop /dev/sr0 /mnt/ironkey
  ### mount it in the 'encrypted folder
  sudo /mnt/ironkey/linux/ironkey --mount /mnt/encrypted
fi

#############################
## Disable IPv6 using grub ##
#############################
sudo sed -i 's/^GRUB_CMDLINE_LINUX_DEFAULT=.*/GRUB_CMDLINE_LINUX_DEFAULT="quiet splash ipv6.disable=1"/g' /etc/default/grub
sudo sed -i 's/^GRUB_CMDLINE_LINUX=.*/GRUB_CMDLINE_LINUX="ipv6.disable=1"/g' /etc/default/grub
### Then update grub
sudo update-grub

