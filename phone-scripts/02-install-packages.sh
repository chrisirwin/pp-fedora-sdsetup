#!/bin/bash
set -e

echo "==================="
echo "02-install-packages.sh"
echo "==================="

# Functions
infecho () {
    echo "[Info] $1"
}
errecho () {
    echo "[Error] $1" 1>&2
    exit 1
}

infecho "This adds my COPR repository (njha/mobile) and installs phone related packages."
infecho "Only functional on Fedora Rawhide."
infecho "HEAVY WIP, untested"

infecho "Link temp-resolv.conf"
ln -sfv /etc/tmp-resolv.conf /etc/resolv.conf

infecho "Enabling COPR repository..."
dnf -y copr enable njha/mobile

infecho "Removing old kernel..."
infecho "THIS WILL FAIL, DON'T WORRY ITS PROBABLY OK"
dnf -y remove kernel || rpm -e --noscripts kernel-core
dnf -y install linux-firmware

infecho "Installing recommended packages..."
dnf -y install megi-kernel feedbackd phoc phosh squeekboard gnome-shell ModemManager rtl8723cs-firmware \
    f2fs-tools chatty calls carbons purple-mm-sms pinephone-helpers evolution-data-server \
    f34-backgrounds-gnome epiphany gnome-contacts evolution NetworkManager-wwan \
    firefox nautilus megapixels gnome-power-manager gnome-usage xdg-user-dirs pipewire-alsa alsa-ucm-utils \
    pp-uboot wlr-randr gnome-terminal gnome-clocks

infecho "Enabling graphical boot and Phosh..."
systemctl disable initial-setup.service
systemctl disable gdm
systemctl enable phosh
systemctl set-default graphical.target

infecho "Making COPR higher priority for kernel updates..."
echo "priority=10" >> /etc/yum.repos.d/_copr\:copr.fedorainfracloud.org\:njha\:mobile.repo

infecho "Upgrading packages..."
dnf -y upgrade
