
## NOTE: This Dockerfile will take GCC image (based on Debian Stretch)
## and install all the necessary binaries and MKL libs
## followed by building Python 3.7 and TensorFlow

# FROM debian:stretch
# FROM gcc:8.2.0
FROM gcc:latest
MAINTAINER Nafis Sadat, sadatnfs@uw.edu
ENV DEBIAN_FRONTEND noninteractive


################### Initialize our OS ###################


## Get the repos
RUN echo "deb http://ftp.de.debian.org/debian stretch main " >> /etc/apt/sources.list && \
    echo "deb http://ftp.de.debian.org/debian stretch main contrib" >> /etc/apt/sources.list && \
    echo "deb http://ftp.de.debian.org/debian stretch main non-free" >> /etc/apt/sources.list && \
    echo "deb http://deb.debian.org/debian stretch main" >> /etc/apt/sources.list && \
    echo "deb http://http.us.debian.org/debian stretch main " >> /etc/apt/sources.list && \
    echo "deb http://ftp.us.debian.org/debian stretch main " >> /etc/apt/sources.list && \
    echo "deb http://ftp.de.debian.org/debian stretch-backports main " >> /etc/apt/sources.list && \
    apt-get update


#### Get aptitude and some of the basic stuff 
### We will symlink gcc, g++ and gfortran to usr/bin
RUN ln -sf /usr/local/bin/gcc /usr/bin/gcc && \
    ln -sf /usr/local/bin/g++ /usr/bin/g++ && \
    ln -sf /usr/local/bin/gfortran /usr/bin/gfortran && \
    apt-get update && \
    apt-get install -y aptitude \
    dpkg \
    dpkg-dev \
    rhash \
    doxygen \
    curl \
    cpio \
    lsof \
    build-essential \
    libexpat1 \
    libexpat1-dev \
    gdebi-core \
    git \
    sudo \
    wget \
    cmake \
    make \
    && \
    apt-get upgrade -y && \
    apt-get autoremove -y && \
    apt-get clean

################### Done Initializing ###################


################### Intel Products ###################

### Download and install Intel MKL and TBB
RUN cd /tmp && \
    wget -q http://registrationcenter-download.intel.com/akdlm/irc_nas/tec/13575/l_mkl_2019.0.117.tgz && \
    tar -xzf l_mkl_2019.0.117.tgz && \
    cd l_mkl_2019.0.117 && \
    sed -i 's/ACCEPT_EULA=decline/ACCEPT_EULA=accept/g' silent.cfg && \
    sed -i 's/ARCH_SELECTED=ALL/ARCH_SELECTED=INTEL64/g' silent.cfg && \
    ./install.sh -s silent.cfg && \
    cd .. && rm -rf * && \
    rm -rf /opt/intel/.*.log /opt/intel/compilers_and_libraries_2019.0.117/licensing && \
    cd /tmp && \
    wget -q http://registrationcenter-download.intel.com/akdlm/irc_nas/tec/13552/l_tbb_2019.0.117.tgz && \
    tar -xzf l_tbb_2019.0.117.tgz && \
    cd l_tbb_2019.0.117 && \
    sed -i 's/ACCEPT_EULA=decline/ACCEPT_EULA=accept/g' silent.cfg && \
    sed -i 's/ARCH_SELECTED=ALL/ARCH_SELECTED=INTEL64/g' silent.cfg && \
    ./install.sh -s silent.cfg && \
    cd .. && rm -rf *


# ### Download and install DAAL
# RUN cd /tmp && \
#     wget -q http://registrationcenter-download.intel.com/akdlm/irc_nas/tec/13557/l_daal_2019.0.117.tgz && \
#     tar -xzf l_daal_2019.0.117.tgz  && \
#     cd l_daal_2019.0.117 && \
#     sed -i 's/ACCEPT_EULA=decline/ACCEPT_EULA=accept/g' silent.cfg && \
#     sed -i 's/ARCH_SELECTED=ALL/ARCH_SELECTED=INTEL64/g' silent.cfg && \
#     ./install.sh -s silent.cfg && \
#     cd .. && rm -rf *

## Download MKL-DNN small headers and libs
RUN cd /opt/intel && \
    wget -q https://github.com/intel/mkl-dnn/releases/download/v0.16/mklml_lnx_2019.0.20180710.tgz && \
    tar xzf mklml_lnx_2019.0.20180710.tgz && rm mklml_lnx_2019.0.20180710.tgz && \
    ln -s /opt/intel/mklml_lnx_2019.0.20180710/lib/* /usr/lib && \
    ln -s /opt/intel/mklml_lnx_2019.0.20180710/lib/* /usr/local/lib



## ENV setups (NEEDS SEPARATE BLOCKS)
ENV MKL_LIB_PATH="/opt/intel/compilers_and_libraries/linux/mkl/lib/intel64_lin" 
ENV MKL="-L/opt/intel/compilers_and_libraries/linux/mkl/lib/intel64_lin -Wl,--no-as-needed -lmkl_gf_lp64 -Wl,--start-group -lmkl_gnu_thread -lmkl_core -Wl,--end-group -fopenmp -ldl -lpthread -lm" 
ENV MKLROOT="/opt/intel/compilers_and_libraries/linux/mkl"
ENV TBB_LIB_PATH="/opt/intel/tbb/lib/intel64_lin/gcc4.7"
ENV INTEL_LIB_PATH="/opt/intel/lib/intel64_lin"
ENV LD_LIBRARY_PATH="/usr/local/lib64:${MKL_LIB_PATH}:${TBB_LIB_PATH}:${INTEL_LIB_PATH}:/usr/lib:/usr/local/lib:${LD_LIBRARY_PATH}" 
ENV LIBRARY_PATH="${LD_LIBRARY_PATH}"
ENV MIC_LD_LIBRARY_PATH="${LD_LIBRARY_PATH}"
ENV MIC_LIBRARY_PATH="${MIC_LD_LIBRARY_PATH}" 
ENV CPATH="${MKLROOT}/include:/usr/include:${CPATH}"
ENV MKL_DYNAMIC=TRUE


## Set MKL blas and lapack to be defaults, and register all the libraries
RUN sudo update-alternatives --install /usr/lib/libmklml_intel.so libmklml_intel.so /opt/intel/mklml_lnx_2019.0.20180710/lib/libmklml_intel.so 40 && \
    sudo update-alternatives --install /usr/lib/libmklml_gnu.so libmklml_gnu.so /opt/intel/mklml_lnx_2019.0.20180710/lib/libmklml_gnu.so 40 && \
    sudo update-alternatives --install /usr/lib/libiomp5.so libiomp5.so /opt/intel/mklml_lnx_2019.0.20180710/lib/libiomp5.so 40 && \
    sudo update-alternatives --install /usr/lib/libblas.so libblas.so /opt/intel/compilers_and_libraries/linux/mkl/lib/intel64_lin/libmkl_rt.so 40 && \
    sudo update-alternatives --install /usr/lib/libopenblas.so libopenblas.so /opt/intel/compilers_and_libraries/linux/mkl/lib/intel64_lin/libmkl_rt.so 40 && \
    sudo update-alternatives --install /usr/lib/libopenblas.so.0 libopenblas.so.0 /opt/intel/compilers_and_libraries/linux/mkl/lib/intel64_lin/libmkl_rt.so 40 && \
    sudo update-alternatives --install /usr/lib/libblas.so.3 libblas.so.3 /opt/intel/compilers_and_libraries/linux/mkl/lib/intel64_lin/libmkl_rt.so 40 && \
    sudo update-alternatives --install /usr/lib/liblapack.so  liblapack.so  /opt/intel/compilers_and_libraries/linux/mkl/lib/intel64_lin/libmkl_rt.so 40 && \
    sudo update-alternatives --install /usr/lib/liblapack.so.0 liblapack.so.0 /opt/intel/compilers_and_libraries/linux/mkl/lib/intel64_lin/libmkl_rt.so 40 && \
    sudo update-alternatives --install /usr/lib/liblapack.so.3 liblapack.so.3 /opt/intel/compilers_and_libraries/linux/mkl/lib/intel64_lin/libmkl_rt.so 40 && \
    sudo update-alternatives --install /usr/lib/libtbbmalloc_debug.so libtbbmalloc_debug.so /opt/intel/tbb/lib/intel64_lin/gcc4.7/libtbbmalloc_debug.so 40 && \
    sudo update-alternatives --install /usr/lib/libtbbmalloc.so libtbbmalloc.so /opt/intel/tbb/lib/intel64_lin/gcc4.7/libtbbmalloc.so 40 && \
    sudo update-alternatives --install /usr/lib/libtbbmalloc_proxy.so libtbbmalloc_proxy.so /opt/intel/tbb/lib/intel64_lin/gcc4.7/libtbbmalloc_proxy.so 40 && \
    sudo update-alternatives --install /usr/lib/libtbb.so libtbb.so /opt/intel/tbb/lib/intel64_lin/gcc4.7/libtbb.so 40 && \
    # sudo update-alternatives --install /usr/lib/libJavaAPI.so libJavaAPI.so /opt/intel/daal/lib/intel64_lin/libJavaAPI.so 40 && \
    # sudo update-alternatives --install /usr/lib/libdaal_core.so libdaal_core.so /opt/intel/daal/lib/intel64_lin/libdaal_core.so 40 && \
    # sudo update-alternatives --install /usr/lib/libdaal_sequential.so libdaal_sequential.so /opt/intel/daal/lib/intel64_lin/libdaal_sequential.so 40 && \
    # sudo update-alternatives --install /usr/lib/libdaal_thread.so libdaal_thread.so /opt/intel/daal/lib/intel64_lin/libdaal_thread.so 40 && \
    printf '/opt/intel/lib/intel64\n/opt/intel/compilers_and_libraries/linux/mkl/lib/intel64_lin\n/opt/intel/mkl/lib/intel64\n' >> /etc/ld.so.conf.d/mkl.conf && \
    printf '/opt/intel/lib/intel64\n/opt/intel/compilers_and_libraries/linux/mkl/lib/intel64_lin\n/opt/intel/mkl/lib/intel64\n' >> /etc/ld.so.conf.d/mkl_intel64.conf && ldconfig && \
    bash '/opt/intel/tbb/bin/tbbvars.sh' intel64 && \
    bash '/opt/intel/bin/compilervars.sh' intel64 && \
    bash '/opt/intel/compilers_and_libraries/linux/mkl/bin/mklvars.sh' intel64 && \
    # bash '/opt/intel/compilers_and_libraries/linux/daal/bin/daalvars.sh' intel64 && \
    echo "MKL_THREADING_LAYER=GNU" >> /etc/environment && \
    echo "/opt/intel/compilers_and_libraries/linux/tbb/lib/intel64/gcc4.7" >> /etc/ld.so.conf.d/R-dependencies-x86_64.conf && \
    echo "/opt/intel/compilers_and_libraries/linux/mkl/lib/intel64" >> /etc/ld.so.conf.d/R-dependencies-x86_64.conf && \
    echo "/opt/intel/compilers_and_libraries/linux/compiler/lib/intel64" >> /etc/ld.so.conf.d/R-dependencies-x86_64.conf && \
    echo "/opt/intel/mklml_lnx_2019.0.20180710/lib" >> /etc/ld.so.conf.d/R-dependencies-x86_64.conf && \
    echo "/opt/intel/compilers_and_libraries/linux/mkl/lib/intel64" >> /etc/ld.so.conf.d/intel.conf && \
    echo "/opt/intel/compilers_and_libraries/linux/tbb/lib/intel64/gcc4.7" >> /etc/ld.so.conf.d/intel.conf && \
    echo "/opt/intel/compilers_and_libraries/linux/compiler/lib/intel64" >> /etc/ld.so.conf.d/intel.conf && \
    echo "/opt/intel/mklml_lnx_2019.0.20180710/lib" >> /etc/ld.so.conf.d/intel.conf && \
    # echo "/opt/intel/daal/lib/intel64_lin/" >> /etc/ld.so.conf.d/intel.conf && \
    echo "/usr/lib" >> /etc/ld.so.conf.d/intel.conf && \
    echo "/usr/local/lib" >> /etc/ld.so.conf.d/intel.conf && \
    echo "/usr/local/lib64" >> /etc/ld.so.conf.d/intel.conf && \
    ln -sf /opt/intel/compilers_and_libraries/linux/mkl/lib/intel64_lin/*.so /usr/lib/ && \
    ln -sf /opt/intel/compilers_and_libraries/linux/mkl/lib/intel64_lin/*.so /usr/local/lib64/ && \
    ln -sf /opt/intel/compilers_and_libraries/linux/mkl/lib/intel64_lin/*.so /usr/local/lib/ && \
    ln -sf /opt/intel/compilers_and_libraries/linux/mkl/lib/intel64_lin/*.a /usr/lib/ && \
    ln -sf /opt/intel/compilers_and_libraries/linux/mkl/lib/intel64_lin/*.a /usr/local/lib64/ && \
    ln -sf /opt/intel/compilers_and_libraries/linux/mkl/lib/intel64_lin/*.a /usr/local/lib/ && \
    ln -sf /opt/intel/tbb/lib/intel64_lin/gcc4.7/* /usr/lib/ && \
    ln -sf /opt/intel/tbb/lib/intel64_lin/gcc4.7/* /usr/local/lib/ && \
    ln -sf /opt/intel/tbb/include/* /usr/include/ && \
    # ln -sf /opt/intel/daal/lib/intel64_lin/* /usr/lib/ && \
    # ln -sf /opt/intel/daal/lib/intel64_lin/* /usr/local/lib/ && \
    # ln -sf /opt/intel/daal/include/* /usr/include/ && \
    ln -sf /opt/intel/compilers_and_libraries/linux/mkl/include/* /usr/include/ && \
    ln -sf /opt/intel/compilers_and_libraries/linux/mkl/include/intel64/lp64/* /usr/include/ && \
    cd /etc/ld.so.conf.d/ && sudo ldconfig && \
    sudo update-alternatives --install /usr/lib/libstdc++.so.6  libstdc++.so.6 /usr/local/lib64/libstdc++.so.6 40 && \
    cd /usr/local/lib64 && ldconfig


## Build MKL-DNN, set ENV and redo ldconfz
RUN cd /opt && \
    git clone https://github.com/intel/mkl-dnn.git && \
    cd /opt/mkl-dnn && \
    # cd scripts && ./prepare_mkl.sh && cd ..  && \
    mkdir -p build && cd build && \
    cmake .. && make && make install && \
    cd /opt && rm -rf mkl-dnn  && \
    # sudo update-alternatives --install /usr/lib/libmkldnn.so libmkldnn.so /usr/local/lib/libmkldnn.so 40 && \
    sudo ldconfig

ENV \
    MKLDNN_LIBRARY=/usr/local/lib \
    MKLDNN_INCLUDE_DIR=/usr/local/include \
    MKLDNN_LIB_DIR=/usr/local/lib \
    ARFLAGS="${ARFLAGS} rvU" \
    CMAKE_INCLUDE_PATH=$CPATH \
    CMAKE_LIBRARY_PATH=$LIBRARY_PATH


################### End of Intel Products ###################



################### Linux Binaries and Libraries ###################


## All the libraries we want, including text editor binaries, using aptitude
RUN apt-get update --fix-missing && \
    apt-mark hold r-base \
    r-base-core \
    r-base-dev \
    r-cran-amore \
    r-cran-bayesm \
    r-cran-class \
    r-cran-cluster \
    r-cran-coda \
    r-cran-expm \
    r-cran-gbm \
    r-cran-lattice \
    r-cran-maptree \
    r-cran-mass \
    r-cran-matrix \
    r-cran-matrixmodels \
    r-cran-mcmc \
    r-cran-mcmcpack \
    r-cran-mlbench \
    r-cran-mnp \
    r-cran-msm \
    r-cran-mvtnorm \
    r-cran-quantreg \
    r-cran-rpart \
    r-cran-sparsem \
    r-cran-survival \
    r-cran-tgp \
    && \
    aptitude install -y \
    apt-utils \
    libgsl-dbg \
    libgsl-dev \
    libgsl0-dev \
    libgsl2 \
    libssl-dev \
    libssl1.1 \
    libssl1.0.2 \
    libgdal-dev \
    gdal-bin \
    tar \
    libproj-dev \
    install-info \
    # binutils \
    # binutils-dev \
    dialog \
    apt-rdepends \
    grep \
    libgcc1 \
    # nodejs \
    # node-tar \
    # libssl1.0-dev \
    locate \
    pandoc \
    pandoc-citeproc \
    libcurl4-gnutls-dev \
    openssl \
    # libcurl4-openssl-dev \
    libkml-dev \
    bwidget \
    libfontconfig1-dev \
    libmariadb2 \
    libmariadb-client-lgpl-dev \
    libssl-dev \
    libxml2-dev \
    libxmlsec1 \
    libxmlsec1-dev \
    php \
    php-all-dev \
    libcppunit-dev \
    libxmu6 \
    libxmuu-dev \
    libxmuu1 \
    libxmu-dev \
    libxmu-headers \
    libgdal20 \
    libgeos-dev \
    libproj-dev \
    cppad \
    libeigen3-dev \
    libgl1-mesa-dri \
    libglu1-mesa-dev \
    x11-xserver-utils \
    x11vnc \
    libx11-6 \
    xorg \
    xorg-dev \
    libx11-dev \
    libxt-dev \
    mesa-common-dev \
    libtiff5-dev \
    libgeotiff2 \
    libtiff-tools \
    libmariadb2 \
    libmariadb-client-lgpl-dev \
    libssh2-1-dev \
    ssh \
    # llvm  \
    llvm-6.0 \
    # llvm-6.0-dev \
    ca-certificates \
    curl \
    apt-utils \
    less \
    libgomp1 \
    libv8-3.14-dev \
    libpango-1.0-0 \
    libpango1.0-dev \
    libghc-pango-dev \
    libpangox-1.0-dev \
    libpangoxft-1.0-0 \
    libxt6 \
    libsm6 \
    vim \
    rsync \
    libcminpack-dev \
    libcminpack1 \
    libminpack1 \
    minpack-dev \
    autoclass \
    caffe-cpu \
    scilab-ann \
    # weka \
    libfann-dev \
    liblinear-dev \
    libmlpack-dev \
    libocas-dev \
    libshark-dev \
    libsvm-dev \
    libtorch3-dev \
    librocksdb-dev \
    mcl \
    libvigraimpex-dev \
    libdlib-dev \
    libcv-dev \
    subversion \
    software-properties-common \
    texlive-base \
    texlive-latex-base \
    texlive-latex-recommended \
    texlive-fonts-recommended \
    texlive-latex-extra \
    texlive-xetex \
    texlive-luatex \
    etoolbox \
    wkhtmltopdf \
    fonts-firacode \
    fonts-inconsolata \
    gtkcookie \
    ed \
    # liblapack-dev \
    zlib1g-dev \
    libsuitesparse-dev \
    libsuitesparseconfig4 \
    # libsuitesparseconfig5 \
    stl-manual \
    libfftw3-dev \
    fftw-dev \
    mercurial \
    libxdmcp-dev \
    libx11-dev \
    libc6-dev \
    # libatlas-base-dev \
    jags \
    man-db \
    gettext \
    ncurses-bin \
    ncurses-base \
    libncurses-dev \
    libgnutls30 \
    libzmq3-dev \
    bzip2 \
    libzmq5 \
    libjq-dev \
    iputils-ping \
    dnsutils \
    gawk \
    mt-st \
    mtr \
    net-tools \
    inetutils-traceroute \
    # libquantlib0-dev \
    gogoprotobuf \
    libprotoc-dev \
    libprotobuf-dev \
    libapt-pkg-dev \
    protobuf-c-compiler \
    protobuf-compiler \
    # rustc \
    # rust-gdb \
    # libstd-rust-dev \
    tcl \
    tcl-dev \
    tk \
    tk-dev \
    tclcl \
    tcllib \
    tcltls \
    tklib \
    tk8.5 \
    tk8.5-dev \
    libtk8.5 \
    libtk8.6 \
    libtcl8.6 \
    libtcl8.5 \
    percona-toolkit \
    ed \
    default-libmysqlclient-dev \
    bison \
    flex \
    libffi-dev \
    libmount-dev \
    libpcre3 \
    libpcre3-dev \
    libpcre++-dev \
    libmuparser-dev \
    libmuparser2v5 \
    libmuparserx-dev \
    libnetcdf-dev \
    libnetcdf11 \
    libnetcdf-dev \
    libpnetcdf-dev \
    libpng16-16 \
    libpng-dev \
    libpng++-dev \
    libpng-tools \
    libbz2-dev \
    libreadline-dev \
    libsqlite3-dev \
    libxft-dev \
    clang \
    libboost-dev \
    gnustep \
    openjdk-8-jdk \
    openjdk-8-jre \
    # ecj \
    # ecj1 \
    # libecj-java \
    # libecj-java-gcj \
    texinfo \
    libtre-dev \
    gnustep-devel \
    libfontconfig1-dev \
    gnupg \
    libcairo2-dev \
    desktop-file-utils \
    gtk-update-icon-cache \
    libatk-bridge2.0-dev \
    libepoxy-dev \
    libx11-dev \
    libxcomposite-dev \
    libxcursor-dev \
    libxdamage-dev \
    libxext-dev \
    libxfixes-dev \
    libxi-dev \
    libxkbcommon-dev \
    libxrandr-dev \
    libxrender-dev \
    file \
    libglib2.0-0 \
    libapparmor1 \
    libarmadillo-dev \
    libarmadillo7 \
    libedit2 \
    libssl-dev \
    lsb-release \
    psmisc \
    sudo \
    ghostscript \
    ghostscript-x \
    wget \
    libxrender1 \
    libxtst6 \
    liblzma-dev \
    multiarch-support \
    uuid-runtime \
    metis \
    libmetis-dev \
    libparmetis-dev \
    libmetis5 \
    libmetis5-dbg \
    cdbs \
    libudev1 \
    libudev-dev \
    libudunits2-0 \
    libudunits2-dev \
    libjpeg62-turbo-dev \
    libjpeg-dev \
    sysstat \
    libedit-dev \
    lcov \
    dbus-x11 \
    libxss1 \
    php7.0 \
    libcanberra-gtk-module \
    libjpeg62-turbo-dev \
    # libiodbc2-dev \
    libiodbc2 \
    unixodbc \
    unixodbc-dev \
    odbc-postgresql \
    libpq-dev \
    libhdf5-dev \
    libhdf5-openmpi-dev \
    libhdf4-0 \
    libhe5-hdfeos-dev \
    hdf5-tools \
    hdf4-tools \
    libgtk2.0-dev \
    libgtk-3-dev \
    # libgtk-3-common \
    libatk-adaptor \
    gtkterm \
    libgmp-dev \
    libgmp10 \
    libmpfr-dev \
    libmpfr4 \
    # libgail-common \
    libxext6 \
    libxext-dev \
    libxrender1 \
    libxrender-dev \
    libxtst-dev \
    apt-transport-https \
    libopencv-dev \
    google-perftools \
    libjemalloc-dev \
    # gedit \
    python3 \
    lmodern \
    graphviz-dev \
    librsvg2-2 \
    librsvg2-bin \
    librsvg2-dev \
    # gedit-common \
    # gedit-plugins \
    # pluma \
    # emacs \
    neovim \
    # neovim-qt \
    # neovim-runtime \
    libkido-optimizer-nlopt-dev \
    libnlopt-dev \
    libnlopt0 \
    valgrind \
    geany-plugins-common \
    maven \
    java-wrappers \
    java-package \
    java-common \
    cabextract \
    xvfb \
    redis-tools \
    golang \
    libmpdec-dev \
    libmpdec2 \
    ffindex \
    locales \
    # mpich \
    && \
    apt-get clean && \
    apt-get clean updatedb && \
    apt-get upgrade -y && \
    rm -rf /var/lib/apt/lists/* && \
    ln -sf /usr/bin/llvm-config-6.0 /usr/bin/llvm-config && \
    llvm-config --version

## Install the Arrow development libraries
RUN echo "deb https://packages.red-data-tools.org/debian/ stretch main " >> /etc/apt/sources.list && \
    echo "deb-src https://packages.red-data-tools.org/debian/ stretch main " >> /etc/apt/sources.list && \
    sudo apt update --allow-insecure-repositories  && \
    sudo apt install -y -V --allow-unauthenticated red-data-tools-keyring  && \
    sudo apt update  && \
    sudo apt install -y -V libarrow-dev libarrow-glib-dev  libparquet-dev libparquet-glib-dev libarrow-python-dev




## (Based on https://github.com/rocker-org/rocker/blob/master/r-base/Dockerfile)
## Set a default user. Available via runtime flag `--user docker`
## Add user to 'staff' group, granting them write privileges to /usr/local/lib/R/site.library
## User should also have & own a home directory (e.g. for linked volumes to work properly).
RUN useradd docker \
    && mkdir -p /home/docker \
    && chown docker:docker /home/docker \
    && addgroup docker staff && \
    echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
    && locale-gen en_US.utf8  \
    && /usr/sbin/update-locale LANG=en_US.UTF-8 && apt-get clean
ENV LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8



### Install Sublime Text

## Some admin stuff
ENV NO_AT_BRIDGE=1
ARG HOST_USER="${HOST_USER:-dockerize-sublime}"
ARG HOST_UID="${HOST_UID:-2000}"
ARG HOST_GID="${HOST_GID:-2000}"

## Install Required Dependencies
RUN  \
## Add new sudo user
    useradd -m "${HOST_USER}" && \
    echo "${HOST_USER}:${HOST_USER}" | chpasswd && \
    usermod --shell /bin/bash "${HOST_USER}" && \
    usermod  --uid "${HOST_UID}" "${HOST_USER}" && \
    groupmod --gid "${HOST_GID}" "${HOST_USER}" && \
    su "${HOST_USER}" -c 'mkdir -p /home/${HOST_USER}/.local/share' && \
# Install ST
    wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add - && \
    echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list && \
    apt-get update && aptitude install -y sublime-text 



################### End Linux Binaries and Libraries ###################




################### Start of IHME Stuff ################### 


#### Redacted ###


################### End of IHME Stuff ###################



################### Python Block ###################

### Install Miniconda
RUN echo 'export PATH=/opt/conda/bin:$PATH' > /etc/profile.d/conda.sh && \
    wget -q https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh && \
    # wget -q https://repo.continuum.io/miniconda/Miniconda3-4.5.4-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh && \
    ln -sf /opt/conda/bin/python /usr/local/bin/python && \
    ln -sf /opt/conda/bin/pip /usr/local/bin/pip && \
    chmod -R 755 /opt/conda 



## Make symlnks and update path
ENV LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:/opt/conda/lib" \
    PATH=/opt/conda/bin:$PATH \
    TF_NEED_CUDA=0 \
    TF_MKL_ENABLED="true" \
    # TF_MKL_ROOT=$MKLDNN_INCLUDE_DIR \
    TF_NEED_OPENCL=0 \
    CI_BUILD_PYTHON=/opt/conda/bin/python \
    PYTHON_BIN_PATH=/opt/conda/bin/python \
    PYTHON_LIB_PATH=/opt/conda/lib/python3.7/site-packages \
    USE_DEFAULT_PYTHON_LIB_PATH=1 \
    TF_NEED_MKL=1 \
    TF_NEED_JEMALLOC=1 \
    TF_NEED_GCP=0 \
    TF_NEED_HDFS=0 \
    TF_ENABLE_XLA=0 \
    PYCHARM_HOME=/opt/pycharm \
    PYTHON_PIP_VERSION=18.0 \
    TENSORFLOW_PYTHON='/opt/conda/bin/python' \
    PYTHON_BIN_PATH='/opt/conda/bin/python' \
    PYTHON_LIB_PATH='/opt/conda/lib/python3.7/site-packages' \
    TF_CPP_MIN_LOG_LEVEL=2 \
    RMPI_TYPE="OPENMPI" \
    TZ=America/Los_Angeles \
    BLLP="-L/opt/intel/compilers_and_libraries/linux/mkl/lib/intel64_lin -lmkl_rt -lmkl_gf_lp64 -Wl,--start-group -lmkl_gnu_thread -lmkl_core -dl -lpthread -lm"



## Install pip
RUN set -ex; \
    \
    wget -O get-pip.py 'https://bootstrap.pypa.io/get-pip.py'; \
    \
    python get-pip.py \
        --disable-pip-version-check \
        --no-cache-dir \
        "pip==$PYTHON_PIP_VERSION" \
    ; \
    pip --version; \
    \
    find /usr/local -depth \
        \( \
            \( -type d -a \( -name test -o -name tests \) \) \
            -o \
            \( -type f -a \( -name '*.pyc' -o -name '*.pyo' \) \) \
        \) -exec rm -rf '{}' +; \
    rm -f get-pip.py


## Build Cython and then Numpy using MKL
RUN cd /tmp && \
    git clone https://github.com/cython/cython.git && \
    cd cython && \
    CFLAGS='-w -O3 -g0 -mtune=generic -pipe -fPIC -fopenmp -I${MKLROOT}/include -march=core2 -ftree-vectorize -m64 -fno-gnu-unique -I/usr/include -L/usr/lib -mavx -msse3 -msse4.1 -msse4.2 -msse2 -mfpmath=sse' && \
    LDFLAGS='-lm -lpthread -lmkl_gf_lp64' && \
    python setup.py build && python setup.py install && \
    cd /tmp && rm -rf * && \
    git clone --branch maintenance/1.15.x https://github.com/numpy/numpy.git numpy && \
    cd numpy && \
    cp site.cfg.example site.cfg && \
    echo "[mkl]" >> site.cfg && \
    echo "include_dirs = ${MKLROOT}/include  " >> site.cfg && \
    echo "library_dirs = ${MKLROOT}/lib/intel64" >> site.cfg && \
    echo "mkl_libs = mkl_rt" >> site.cfg && \
    echo "lapack_libs = mkl_rt" >> site.cfg && \
    CFLAGS='-w -fopenmp -g -O3 -pipe -fPIC -I${MKLROOT}/include -march=core2 -ftree-vectorize -fopenmp -I/usr/include -L/usr/lib -mavx -msse3 -msse4.1 -msse4.2 -msse2' && \
    LDFLAGS='-lm -lpthread -lmkl_gf_lp64 ' && \
    python setup.py build && \
    python setup.py install && \
    cd /tmp && \
    rm -rf *

## Build Scipy and test that it loads successfully
RUN cd /tmp && \
    git clone https://github.com/scipy/scipy.git scipy && \
    cd scipy && \
    CFLAGS='-w -fopenmp -g -O3 -pipe -fPIC -I${MKLROOT}/include -march=core2 -ftree-vectorize -fopenmp -I/usr/include -L/usr/lib -mavx -msse3 -msse4.1 -msse4.2 -msse2' && \
    LDFLAGS='-lm -lpthread -lmkl_gf_lp64 ' && \
    python setup.py build && \
    python setup.py install && \
    cd .. && \
    rm -rf * && \
    python -c 'import numpy as np; import scipy as sci; print(2)'



## Pip install pacakges
RUN pip install --no-cache-dir \
    pandas cffi typing \
    netcdf4 numba pylint arrow flake8 \
    ipython pyzor bottleneck dask[complete] pydap \
    h5netcdf cftime PseudoNetCDF \
    jinja2 bokeh Django \
    plotly scikit-learn \
    patsy statsmodels linearmodels drmaa \
    breathe sphinx matplotlib xlsxwriter \
    xlrd jupyter jupyterlab \
    cufflinks notebook nbconvert ipywidgets \
    pytest pystan tables larry \
    h5py pyyaml requests Pillow \
    seaborn pymc3 feather-format \
    html5lib sqlalchemy argparse networkx \
    pymysql numexpr google protobuf
RUN pip install --upgrade --no-cache-dir jupyter_utils \
    jupyter-remote jupyter-echarts-pypkg xarray \
    bash_kernel jupyter-dojo itkwidgets jupyter-sphinx-theme \
    theano sympy latex keras kafka \
    multipledispatch edward arrayfire jupyter-parser \
    bayesian-optimization pybind11 camog cartopy \
    pdvega toolz Scrapy lxml datetime urllib3 requests \
    pygal ggplot pyglet gleam mipy nervananeon \
    NLTK gensim selenium cookiecutter \
    ray modin xar networkx_viewer \
    rtichoke gpy dask graphviz github-dl  \
    dask-glm dask-distance scipy-stack \
    scipy-sugar download django-modelstats \
    numpy-sugar xnumpy zarr subframe \
    xarray-simlab sklearn-xarray \
    xarray-topo git-pandas lasagne \
    pandas-charm seaborn-table geoplotlib \
    pandas2sklearn sklearn-pandas \
    matplotlib-colorbar tensor2tensor \
    matplotlib-scalebar matplotlib-subsets \
    datarray ipdb pyramid pyramid_mako WebError \
    colander simplejson sphinxcontrib-httpdomain \
    emcee sphinx_rtd_theme WebOb repoze.lru \
    zope.interface zope.deprecation venusian \
    translationstring PasteDeploy Mako Tempita \
    Paste waitress beautifulsoup4 xarray-fits 



### NOTE: Commenting out tensorflowjs because it forces TF upgrade beyond Edward
###       tensorflow-lattice brings in broken TF 1.5.0
RUN pip install --no-cache-dir astor gast termcolor grpcio absl-py && \
    pip install --no-cache-dir --no-deps tensorflow && \
    git clone https://github.com/markmoses/GPflow_mm.git /opt/conda/lib/python3.7/GPflow-clone && \
    cd /opt/conda/lib/python3.7/GPflow-clone && \
    git pull https://github.com/GPflow/GPflow.git --no-commit && \
    python setup.py install && \
    git clone https://github.com/Joshuaalbert/heterogp.git /opt/conda/lib/python3.7/hgp-clone && \
    cd /opt/conda/lib/python3.7/hgp-clone && python setup.py install && \
    git clone https://github.com/GPflow/GPflowOpt.git -b gpflow-1.0-v3 /opt/conda/lib/python3.7/GPflowOpt-clone && \
    cd /opt/conda/lib/python3.7/GPflowOpt-clone && pip install . --process-dependency-links && \
    git clone https://github.com/ManchesterBioinference/BranchedGP /opt/conda/lib/python3.7/BranchedGP-clone && \
    cd /opt/conda/lib/python3.7/BranchedGP-clone && python setup.py install && \
    pip install --no-cache-dir ipyext django-ipython \
    ipython2slack ipython-agnoster ipython-db \
    ipython-autoimport ipython-autotime notebook-viewer \
    ipython-elasticsearch ipython-extensions \
    ipython-pip ipython-sql  ipython_unittest charmpy \
    gist jupyter-notebook-gist jupyter-tensorboard \
    perspective perspective-python ujson python-docs-theme sparse scikit-sparse h5sparse \
    Bayesian kcbo pylru multiprocess enum34 bunch \
    tensorflowjs \
    limix-plot ruamel.yaml pyaml testfixtures bohrium \
    pymc gargparse pystache multitables toposort \
    tabulate keras-model-specs casadi cvxpy \
    blinker sortedcontainers tblib msgpack \
    unidecode feedgenerator distributed \
    pelican zict faust[uvloop,fast,statsd] \
    django-spark pip-spark gspread heapdict \
    lightgbm catboost MDP genetic osqp ecos scs fastcache  \
    tensorflow-utils tensorflow-template \
    dask-tensorflow tensorflow-hub tensorflow_hmm \
    cxflow cxflow-tensorflow accbpg \
    tensorflow_forward_ad charmpy \
    tf-data tensorlab chainer \
    tensorflow-qnd tensorfunk tfset tfstage \
    Flask pytest-flask Flask-API ideep4py \
    tftables easytf tfdebugger tfgraph tfgraphviz \
    ml-tools hierreg vsmrfs pysterior GPyOpt climin




## PyTorch (building from fixes)
RUN \
    cd /opt && git clone --recursive https://github.com/pytorch/pytorch \
    && cd pytorch && git submodule update --init && \
    cd /opt/pytorch/third_party/ideep/mkl-dnn && \
    git pull https://github.com/intel/mkl-dnn.git --no-commit  --rebase && \
    cd /opt/pytorch && \
    PYTHON_EXECUTABLE=/opt/conda/lib/libpython3.7m.so \
    PYTHON_INCLUDE_DIR=/opt/conda/include/python3.7m \
    FULL_CAFFE2=1 \
    USE_OPENMP=1 \
    USE_MKL=1 \
    USE_MKLDNN=1 \
    MKLDNN_LIBRARY="" \
    MKLDNN_INCLUDE_DIR="" \
    MKLDNN_LIB_DIR="" \
    python setup.py install && \
    cd /opt && rm -rf /opt/pytorch && \
    cd /usr/lib && sudo ldconfig

RUN pip install --no-cache-dir torchvision && \
    git clone https://github.com/uber/pyro.git /opt/pyro && \
    cd /opt/pyro && sed -i 's/torch\=\=0\.4\.0/torch/g' setup.py && \
    python setup.py install && cd / && rm -rf /opt/pyro && \
    pip install --no-cache-dir merf prettytensor google-apitools && \
    pip install --no-cache-dir git+https://github.com/cornellius-gp/gpytorch.git && \
    pip install --no-cache-dir git+https://github.com/bambinos/bambi.git && \
    python -c "import torch; import pyro" && \
    cd /opt && git clone https://github.com/Microsoft/dowhy.git && \
    cd dowhy && python setup.py install && cd .. && rm -rf /opt/dowhy && \
    pip install -U git+https://github.com/Microsoft/MMdnn.git@master && \
    pip install -U git+https://github.com/hughsalimbeni/orth_decoupled_var_gps.git && \
    pip install -U git+https://github.com/hughsalimbeni/bayesian_benchmarks.git && \
    pip install -U git+https://github.com/luke14free/pm-prophet.git





## Upgade if needed
RUN pip install --upgrade \
    keras bleach html5lib scikit-learn pandas \
    jupyter notebook ipython perspective ipykernel


################### Python Block ###################


################### TF Block ###################


# Download and build TensorFlow.
# Enable checking out both tags and branches

# Install Bazel and then build TF!
RUN echo "deb [arch=amd64] http://storage.googleapis.com/bazel-apt stable jdk1.8" | sudo tee /etc/apt/sources.list.d/bazel.list && \
    curl https://bazel.build/bazel-release.pub.gpg | sudo apt-key add - && \
    apt-get update && apt-get install -y bazel  && rm -rf /var/lib/apt/lists/* && \
    ldconfig && \
    pip uninstall -y tensorflow-tensorboard tb-nightly tf-nightly tensorflow && \
    cd /opt && \
    # git clone --branch r1.10 https://github.com/tensorflow/tensorflow.git && \
    git clone https://github.com/tensorflow/tensorflow.git && \
    cd /opt/tensorflow && \
    sed -i 's/2018\.0\.3\.20180406/2019\.0\.20180710/g' tensorflow/contrib/cmake/external/mkl.cmake && \
    sed -i 's/v0\.14/v0\.16/g' tensorflow/contrib/cmake/external/mkl.cmake && \
    /bin/bash ./configure \
    && \
    bazel build \
    --config=mkl --config=opt \
    --cxxopt="-D_GLIBCXX_USE_CXX11_ABI=0" \
    --copt=-msse4.2 --copt=-msse4.1 --copt=-mavx --copt=-msse2 --copt=-msse3  \
    --copt=-O3 --copt=-mfpmath=both \
    --copt="-DMKL_LP64" \
    --copt="-fPIC" \
    --linkopt="-lmkl_gf_lp64" \
    --linkopt="-lmkl_gnu_thread" \
    --linkopt="-dl" \
    --linkopt="-lpthread" \
    --linkopt="-lmkl_core" \
    --linkopt="-lm" \
    --linkopt="-lmkl_rt" \
    --linkopt="-lmkldnn" \
    tensorflow/tools/pip_package:build_pip_package && \
    bazel-bin/tensorflow/tools/pip_package/build_pip_package /tmp/pip && \
    pip install --no-deps /tmp/pip/tensorflow-*.whl && \
    # pip install --no-deps tb-nightly && \
    cd /opt && rm -rf /opt/tensorflow /tmp/* && \
    python -c "import tensorflow as tf; hello = tf.constant('Hello, TensorFlow!'); sess = tf.Session(); print(sess.run(hello))" && \
    python -c "import tensorboard"

## Also Build TFP from source!!!!!!
RUN cd /opt && git clone https://github.com/tensorflow/probability.git && \
	cd /opt/probability && \
	bazel build \
    --cxxopt="-D_GLIBCXX_USE_CXX11_ABI=0" \
    --copt=-mavx --copt=-msse2 --copt=-msse3 --copt=-msse4.1 --copt=-msse4.2 \
    --copt=-O3 --copt=-mfpmath=both \
    --copt="-DMKL_LP64" \
    --copt="-fPIC" \
    --linkopt="-lmkl_gf_lp64" \
    --linkopt="-lmkl_gnu_thread" \
    --linkopt="-dl" \
    --linkopt="-lpthread" \
    --linkopt="-lmkl_core" \
    --linkopt="-lm" \
    --linkopt="-lmkl_rt" \
    --linkopt="-lmkldnn" \
    :pip_pkg && \
	PKGDIR=$(mktemp -d) && \
	./bazel-bin/pip_pkg $PKGDIR && \
	pip install --no-deps $PKGDIR/*.whl && \
	cd /opt && rm -rf /opt/probability /tmp/* && \
    python -c "import tensorflow_probability"


## Fix scikit-sparse manually (bringing in stuff from conda)
RUN pip uninstall -y scikit-sparse && \
    conda install -c conda-forge libgfortran-ng libgfortran-ng scikit-sparse suitesparse tbb metis blas --no-deps

ENTRYPOINT /bin/bash

