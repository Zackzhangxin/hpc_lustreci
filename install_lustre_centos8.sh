#!/bin/bash

# This assumes you are running on a VM created using the LustreVM kickstart.
# Please refer to the kickstart post section for how to do match that environment.
# The lustre_deps and lustre repos contain the rpms built using build_lustre_centos8.sh

DIR_HOME="/home/$(whoami)/"
DIR_BROKEN_KMODS="$DIR_HOME/broken_kmods"
LUSTRE_REPO_URL="http://10.40.0.13/lustre/latest/lustre"
LUSTRE_VERSION="2.13.51_dirty-1"
LUSTRE_DISK="/dev/sdb"

mkdir -p $DIR_BROKEN_KMODS

sudo yum install -y zfs kmod-zfs-devel

wget -P "$DIR_BROKEN_KMODS" "$LUSTRE_REPO_URL/kmod-lustre-$LUSTRE_VERSION.el8.aarch64.rpm"
wget -P "$DIR_BROKEN_KMODS" "$LUSTRE_REPO_URL/kmod-lustre-osd-ldiskfs-$LUSTRE_VERSION.el8.aarch64.rpm"
wget -P "$DIR_BROKEN_KMODS" "$LUSTRE_REPO_URL/kmod-lustre-osd-zfs-$LUSTRE_VERSION.el8.aarch64.rpm"
wget -P "$DIR_BROKEN_KMODS" "$LUSTRE_REPO_URL/kmod-lustre-tests-$LUSTRE_VERSION.el8.aarch64.rpm"

sudo rpm -ivh --nodeps "$DIR_BROKEN_KMODS/kmod-lustre-$LUSTRE_VERSION.el8.aarch64.rpm" "$DIR_BROKEN_KMODS/kmod-lustre-osd-ldiskfs-$LUSTRE_VERSION.el8.aarch64.rpm" "$DIR_BROKEN_KMODS/kmod-lustre-osd-zfs-$LUSTRE_VERSION.el8.aarch64.rpm" "$DIR_BROKEN_KMODS/kmod-lustre-tests-$LUSTRE_VERSION.el8.aarch64.rpm"

sudo yum install -y lustre-tests

# Assuming LUSTRE_DISK is untouched (fresh LustreVM)
printf "o\nn\np\n1\n\n\nw\n" | sudo fdisk "$LUSTRE_DISK"

# Make sure firewalld is disabled and stopped
sudo systemctl disable firewalld
sudo systemctl stop firewalld
