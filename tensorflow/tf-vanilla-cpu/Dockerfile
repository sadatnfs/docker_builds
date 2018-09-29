FROM ubuntu:16.04
MAINTAINER Cody Horst, chorst@uw.edu

# update package list and install ubuntu basics
RUN apt-get update && apt-get install -y \
		apt-utils \
		build-essential \
		bzip2 \
		g++ \
		curl \
		vim \
		htop \
		pciutils \
		git

# get and install conda to /opt
RUN curl -o ./conda.sh https://repo.continuum.io/archive/Anaconda3-5.0.1-Linux-x86_64.sh && \
	bash ./conda.sh -b -p opt/anaconda && \
	rm ./conda.sh

ENV PATH="/opt/anaconda/bin:${PATH}"

# get and build tensorflow
RUN pip install tensorflow

# for Tensorboard
EXPOSE 6006

# run everything at home
ENV HOME=/root
WORKDIR $HOME
