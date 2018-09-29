FROM ubuntu:16.04
MAINTAINER Cody Horst, chorst@uw.edu

# update package list and install ubuntu basics
RUN apt-get update && apt-get install -y \
		apt-utils \
		build-essential \
		pkg-config \
		zip \
		unzip \
		bzip2 \
		zlib1g-dev \
		g++  \
		curl \
		vim \
		htop \
		pciutils \
		git

# install to opt
WORKDIR /opt

# get and install conda
RUN curl -Lk -o ./conda.sh https://repo.continuum.io/archive/Anaconda3-5.0.1-Linux-x86_64.sh && \
	bash ./conda.sh -b -p /opt/anaconda && \
	rm ./conda.sh

ENV PATH="/opt/anaconda/bin:${PATH}"

# install bazel, google's build automation tool. Need it to build tensorflow
# RUN apt-get install -y openjdk-8-jdk && \
# 	echo "deb [arch=amd64] http://storage.googleapis.com/bazel-apt stable jdk1.8" | tee /etc/apt/sources.list.d/bazel.list && \
# 	curl https://bazel.build/bazel-release.pub.gpg | apt-key add - && \
# 			apt-get update && \
# 			apt-get install -y bazel

# the above installs bazel 0.9, which currently has issues with tensorflow 1.4. Google has tested
# configurations with 1.4 and bazel 0.5.4, so I will build that exact verison. Note, this installer
# includes openjdk-8
RUN curl -Lk -o bazel.sh https://github.com/bazelbuild/bazel/releases/download/0.5.4/bazel-0.5.4-installer-linux-x86_64.sh && \
	chmod +x ./bazel.sh && bash ./bazel.sh && rm ./bazel.sh

ENV PATH="/opt/bin:${PATH}"

# start at home
ENV HOME=/root
WORKDIR $HOME