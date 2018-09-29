FROM reg.ihme.uw.edu/health_fin/tf-source-install-base:v1.0
MAINTAINER Cody Horst, chorst@uw.edu

# install to opt
WORKDIR /opt

# grab tensorflow and current stable version
RUN git clone https://github.com/tensorflow/tensorflow && cd tensorflow && git checkout v1.4.1
# all things flow from tensorflow . . . 
WORKDIR /opt/tensorflow

# Configure Tensorflow using environment variables rather than the configure script
# can peak at possible env vars by looking at configure.py. Most are not necessary in our case.
# They include activation of google cloud platform, hadoop file system, amazon S3, XLA JIT (alpha),
# GDR (no idea how this performs), Verbs, MPI, Cuda, a few others.
# I'm setting what I know I want. The rest will be defaulted by ./configure
# jemalloc: https://github.com/jemalloc/jemalloc
ENV PYTHON_BIN_PATH=/opt/conda/bin/python \
	PYTHON_LIB_PATH=/opt/conda/lib/python3.6/site-packages \
	TF_NEED_JEMALLOC=1 \
	TF_NEED_GCP=0 \
	TF_NEED_HDFS=0\
	TF_NEED_S3=0
RUN /bin/bash ./configure

# cxxopt is mandatory b/c building with gcc > 4
# gcc reference https://gcc.gnu.org/onlinedocs/gcc-4.5.3/gcc/i386-and-x86_002d64-Options.html
# 			and https://gcc.gnu.org/onlinedocs/gcc/Optimize-Options.html
# I am totally unsure of copt=-03 is necessary.
# incompatible load argument to False is a bazel 0.9.0 bug.
# the documentation states builds were tested with 0.5.4 which is quite a bit older
RUN bazel build --config=opt \
				--cxxopt="-D_GLIBCXX_USE_CXX11_ABI=0" \
				--local_resources 4096,0.5,1.0 \
				--copt=-mavx \
				--copt=-msse3 \
				--copt=-msse4.1 \
				--copt=-msse4.2 \
				--copt=-mfma \
				--copt=-O3 \
				--incompatible_load_argument_is_label=false \
				//tensorflow/tools/pip_package:build_pip_package

RUN bazel-bin/tensorflow/tools/pip_package/build_pip_package /tmp/tensorflow_pkg

RUN pip install /tmp/tensorflow_pkg/tensorflow-1.4.1-cp36-cp36m-linux_x86_64.whl

# verify instructions

# start at home
ENV HOME=/root
WORKDIR $HOME