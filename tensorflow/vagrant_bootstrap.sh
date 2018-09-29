#!/usr/bin/env bash

## get all the necessary ubuntu packages:

# core things
apt-get update && apt-get install -y \
    apache2 \
    python \
    build-essential \
    linux-tools-generic

# singularity dependencies
apt-get update && apt-get install -y \
    dh-autoreconf \
    debootstrap \
    libtool \
    m4 \
    automake \

# bazel dependencies
apt-get update && apt-get install -y openjdk-8-jdk

# tf dependencies
apt-get update && apt-get install -y libcupti-dev

# upgrade everything
apt-get upgrade -y
apt-get dist-upgrade -y

## install singularity
git clone https://github.com/singularityware/singularity.git
cd singularity
./autogen.sh
./configure --prefix=/usr/local --sysconfdir=/etc
make
make install

## Install cuda toolkit, cuda drivers, and cuDNN.
# Cluster nodes currently have toolkit version 8.0.61 and drivers 375.51. No cuDNN I can find
# I believe everything in the host vagrant machien as well as the singularity image must match these versions
# This makes this setup all quite brittle. Also, NVIDIA doesn't haver over direct downloads easily ....
# I think cluster versions may be subject to change in the future. To find what is on the cluster search rpm on a gpu node
# rpm -qa \*cuda\* | grep drivers

# cuda toolkit
echo "Downloading cuda"
curl -Os https://developer.download.nvidia.com/compute/cuda/8.0/Prod2/local_installers/cuda_8.0.61_375.26_linux.run
chmod +x cuda_8.0.61_375.26_linux.run
./cuda_8.0.61_375.26_linux.run --toolkit --silent --kernel-source-path=/usr/src/linux-headers-`uname -r`/
echo "Fixing paths."
echo "export PATH=/usr/local/cuda/bin${PATH:+:${PATH}}" >> /home/ubuntu/.bashrc
echo "export LD_LIBRARY_PATH=/usr/loca/cuda/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}" >> /home/ubuntu/.bashrc

# cuda drivers
# http://www.nvidia.com/content/DriverDownload-March2009/confirmation.php?url=/tesla/375.51/nvidia-driver-local-repo-ubuntu1604_375.51-1_amd64.deb&lang=us&type=Tesla

## for later, cudnn url:
# http://developer.download.nvidia.com/compute/redist/cudnn/v2/cudnn-6.5-linux-x64-v2.tgz

## install bazel
echo "deb [arch=amd64] http://storage.googleapis.com/bazel-apt stable jdk1.8" | sudo tee /etc/apt/sources.list.d/bazel.list
echo "Downloading bazel"
curl -Os https://bazel.build/bazel-release.pub.gpg | sudo apt-key add -
apt-get update && apt-get install -y --allow-unauthenticated bazel
apt-get upgrade -y --allow-unauthenticated bazel

if ! [ -L /var/www ]; then
  rm -rf /var/www
  ln -fs /vagrant /var/www
fi
