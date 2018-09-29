FROM ubuntu:16.04
MAINTAINER Cody Horst, chorst@uw.edu

# update package list
RUN apt-get update

# ubuntu basics
# libcupti-dev is an explicit tensorflow prereq
RUN apt-get update && apt-get install -y \
		build-essential \
		libcupti-dev \
		bzip2 \
		curl \
		vim \
		htop \
		pciutils \
		git

# run everything at home
ENV HOME /root
WORKDIR $HOME

# get and install conda
RUN curl -o ./conda.sh https://repo.continuum.io/archive/Anaconda3-5.0.1-Linux-x86_64.sh && \
	bash ./conda.sh -b -p $HOME/anaconda && \
	rm ./conda.sh

ENV PATH="$HOME/anaconda/bin:${PATH}"

# get and install bazel
RUN apt-get install -y openjdk-8-jdk && \
	echo "deb [arch=amd64] http://storage.googleapis.com/bazel-apt stable jdk1.8" | tee /etc/apt/sources.list.d/bazel.list && \
	curl https://bazel.build/bazel-release.pub.gpg | apt-key add - && \
	apt-get update && apt-get install -y bazel


######### CUDA #####################################
# versioning is GPU- and Tensorflow-dependent. Maxwell and up
# architectures (compute capability >= 5) support cuda toolkit 9 and
# accompanying cuDNN, but tensorflow 1.4 only supports toolkit 8 and 
# cuDNN 6. 1.5 will support the newest and is in pre-release. Not gonna
# go there for now.

# get and install cuda toolkit 8
# no convenient URL for this, so copy from local

# get and install cudnn 6
# no convenient URL for this, so copy from local

# get and build tensorflow
# building 1.4, current stable release. 1.5 is in pre-relase.
# 1.6 prebuilt will use AVX, rendering all of this meaningless . . .
RUN git clone https://github.com/tensorflow/tensorflow && \
	cd tensorflow && \
	git checkout r1.4

# for Tensorboard
EXPOSE 6006