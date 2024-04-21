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
sudo apt update && sudo apt upgrade -y

## Set up Flatpak
sudo apt install -y flatpak
sudo apt install -y gnome-software-plugin-flatpak
flatpak remote-add --user --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo


## Flathub
flatpak install flathub com.bitwarden.desktop -y
flatpak install flathub org.jdownloader.JDownloader -y
flatpak install flathub org.nmap.Zenmap -y
flatpak install flathub net.cozic.joplin_desktop -y
flatpak install flathub eu.betterbird.Betterbird -y
flatpak install flathub org.freefilesync.FreeFileSync -y
flatpak install flathub io.gitlab.news_flash.NewsFlash -y

## Generate ssh Keys
ssh-keygen -t ed25519 -C "neil@popos"

## Install some stuff
sudo apt install -y \
neofetch \
spacefm \
curl \
vlc \
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

## Remove some stuff
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

## Install VSCode
sudo apt install -y wget gpg
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
rm -f packages.microsoft.gpg
sudo apt install apt-transport-https
sudo apt update -y
sudo apt install -y code

## Install PIA
cd ~/Downloads
wget https://installers.privateinternetaccess.com/download/pia-linux-3.3.1-06924.run
chmod +x ~/Downloads/pia-linux-3.3.1-06924.run
~/Downloads/pia-linux-3.3.1-06924.run
cd


sudo dpkg-reconfigure libdvd-pkg

## Some Settings
gsettings set org.gnome.desktop.interface clock-format 24h
gsettings set org.gnome.desktop.wm.preferences button-layout ":minimize,maximize,close"
gsettings set org.gnome.desktop.interface show-battery-percentage true

## Install 1Password
wget https://downloads.1password.com/linux/debian/amd64/stable/1password-latest.deb

## Install MEGA

## Set up RDP
sudo apt install -y gnome-tweak-tool obs-studio libavcodec-extra libdvd-pkg; sudo dpkg-reconfigure libdvd-pkg vlc code xrdp
sudo systemctl enable xrdp
sudo systemctl start xrdp
sudo ufw allow from 192.168.178.0/24 port 3389 proto tcp
echo gnome-session > ~/.xsession
chmod +x ~/.xsession

## Install Thorium Browser
wget https://dl.thorium.rocks/debian/dists/stable/thorium.list
sudo mv thorium.list /etc/apt/sources.list.d/
sudo apt update
sudo apt install -y thorium-browser

## Remove Snaps
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


## Install Yubikey
sudo apt install -y yubioath-desktop yubikey-agent

## Enable Ironkey
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
else
    echo "It's not mounted."
fi
sudo mount -o loop /dev/sr0 /mnt/ironkey

### mount it in the 'encrypted folder
sudo /mnt/ironkey/linux/ironkey --mount /mnt/encrypted

## Disable IPv6 using grub
### You need to modify GRUB_CMDLINE_LINUX_DEFAULT and GRUB_CMDLINE_LINUX to disable IPv6 on boot:
GRUB_CMDLINE_LINUX_DEFAULT="quiet splash ipv6.disable=1"
GRUB_CMDLINE_LINUX="ipv6.disable=1"
### Then update grub
sudo update-grub

