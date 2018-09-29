FROM ubuntu:16.04
MAINTAINER Cody Horst, chorst@uw.edu

# update package list and install ubuntu basics
# libcupti-dev is an explicit tensorflow prereq
RUN apt-get update && apt-get install -y \
		apt -utils \
		build-essential \
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

############################# CUDA #############################
# versioning is GPU- and Tensorflow-dependent. Maxwell and up
# architectures (Pascal, Volta, compute capability >= 5) support
# cuda toolkit 9 and accompanying cuDNN, but tensorflow 1.4 only
# supports toolkit 8 and cuDNN 6. Tensorflow 1.5 will support the
# newest and is in pre-release. Not gonna go there for now.

# get and install cuda toolkit 8
# no convenient URL for this, so copy the network
# installer from local
COPY cuda-repo-ubuntu1604_8.0.61-1_amd64.deb $HOME
RUN dpkg -i cuda-repo-ubuntu1604_8.0.61-1_amd64.deb && \
		apt-get update && \
		apt-get install -y --allow-unauthenticated cuda && \
		rm cuda-repo-ubuntu1604_8.0.61-1_amd64.deb

# get and install cudnn 6
# no convenient URL for this, same as above
COPY libcudnn7_7.0.5.15-1+cuda8.0_amd64.deb $HOME
COPY libcudnn7-dev_7.0.5.15-1+cuda8.0_amd64.deb $HOME
RUN dpkg -i libcudnn7_7.0.5.15-1+cuda8.0_amd64.deb && \
		dpkg -i libcudnn7-dev_7.0.5.15-1+cuda8.0_amd64.deb && \
		rm libcudnn7_7.0.5.15-1+cuda8.0_amd64.deb && \
		rm libcudnn7-dev_7.0.5.15-1+cuda8.0_amd64.deb

# get and build tensorflow
RUN pip install tensorflow-gpu

# for Tensorboard
EXPOSE 6006

# verify instructions and GPU
COPY test_tf_gpu.py $HOME
RUN python test_tf_gpu.py
