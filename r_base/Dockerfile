FROM reg.ihme.uw.edu/health_fin/debian_base:latest
MAINTAINER Nafis Sadat, sadatnfs@uw.edu


### Download R source code and start building
RUN \
    # ln -sf /usr/local/lib64/* /usr/lib/ && \
    cd / && \
    wget -q https://stat.ethz.ch/R/daily/R-patched.tar.gz -O R-arc.tar.gz  && \
    mkdir Rdir && tar -xzf R-arc.tar.gz -C Rdir && \
    cd /Rdir/R* && \
    ./configure \
  	  LIBnn=lib \
      CC="gcc" \
      CXX="g++ " \
      OBJC="cc" \
      CFLAGS="         -w -g -O3 -m64 -fno-gnu-unique -I${MKLROOT}/include -I/usr/include -fno-optimize-sibling-calls -mavx -msse3 -msse4.1 -msse4.2 -msse2 -mfpmath=sse " \
      OBJCFLAGS="      -w -g -O3 -m64 -fno-gnu-unique -I${MKLROOT}/include -I/usr/include -fno-optimize-sibling-calls -mavx -msse3 -msse4.1 -msse4.2 -msse2 -mfpmath=sse " \
      CPPFLAGS="       -w -g -O3 -m64 -fno-gnu-unique -I${MKLROOT}/include -I/usr/include -mavx -msse3 -msse4.1 -msse4.2 -msse2 -mfpmath=sse  " \
      CXXFLAGS="       -w -g -O3 -m64 -fno-gnu-unique -I${MKLROOT}/include -I/usr/include -mavx -msse3 -msse4.1 -msse4.2 -msse2 -mfpmath=sse  " \
      FCFLAGS="        -w -g -O3 -m64 -fno-gnu-unique -I${MKLROOT}/include -I/usr/include -mavx -msse3 -msse4.1 -msse4.2 -msse2 -mfpmath=sse  " \
      FFLAGS="         -w -g -O3 -m64 -fno-gnu-unique -I${MKLROOT}/include -I/usr/include -fno-optimize-sibling-calls -mavx -msse3 -msse4.1 -msse4.2 -msse2 -mfpmath=sse  " \
      tbb_os="linux" \
      OS="linux" \
      CPICFLAGS="   -fPIC " \
      CXXPICFLAGS=" -fPIC " \
      FPICFLAGS="   -fPIC " \
      FCPICFLAGS="  -fPIC " \
      LDFLAGS=" -L${MKLROOT}/lib/intel64_lin -L/usr/local/lib -L/usr/lib -Wl,--no-as-needed -lmkl_gf_lp64 -Wl,--start-group -lmkldnn -lmklml_intel -lmkl_gnu_thread -lmkl_core -Wl,--end-group -dl -lpthread -lm " \
      SHLIB_OPENMP_CFLAGS="    -fopenmp -lgomp "\
      SHLIB_OPENMP_CXXFLAGS="  -fopenmp -lgomp "\
      SHLIB_OPENMP_FCFLAGS="   -fopenmp -lgomp "\
      SHLIB_OPENMP_FFLAGS="    -fopenmp -lgomp " \
      --prefix="/opt/R" \
      --with-blas=" -L${MKLROOT}/lib/intel64_lin -Wl,--no-as-needed -lmkl_gf_lp64 -Wl,--start-group -lmkl_gnu_thread -dl -lpthread -lmkl_core -Wl,--end-group -lm -L/usr/lib -lmkldnn -lmklml_intel " \
      --with-lapack \
      --enable-R-shlib \
      --enable-shared \
      --enable-R-profiling \
      --with-tcltk='/usr/lib' \
      --with-tk-config="/usr/lib/tkConfig.sh" \
      --with-tcl-config="/usr/lib/tclConfig.sh" \
      --enable-openmp \
      --enable-memory-profiling \
      --with-jpeglib \
      --with-readline \
      --with-cairo \
      --with-libpng \
      --with-libtiff \
      --with-system-tre \
      --with-x=yes \
      --x-includes=/usr/include/X11 \
      --x-libraries=/usr/lib/X11 && \
    make all 2>&1 && \
    make install && \
    cd src/nmath/standalone && make && make install && \
    cp libRmath.so /usr/local/lib/ && \
    ln -s /usr/local/lib/libRmath.* /opt/R/lib/R/ && \
    ln -s /usr/local/lib/libRmath.* /usr/local/lib64/ && \
    ln -sf /opt/R/bin/R /usr/bin/R && \
    ln -sf /opt/R/bin/R /usr/local/bin/R && \
    ln -sf /opt/R/bin/Rscript /usr/bin/Rscript && \
    ln -sf /opt/R/bin/Rscript /usr/local/bin/Rscript && \
    cd / && \
    # Remove tar \
    rm R-arc.tar.gz && \
    rm -rf /Rdir && \
    echo "alias R='R --no-save'" >> /etc/bash.bashrc && \
    chmod -R 777 /opt/R && \
    ## Reconfig Java
    R CMD javareconf && echo 'America/Los_Angeles' > /etc/timezone && \
    ## Install rpy2 now that we have R
    pip install rpy2 tzlocal && \
    ## Set CRAN repo
    echo 'local({   r <- getOption("repos"); r["CRAN"] <- "https://cloud.r-project.org/"; options(repos = r) })' >> /opt/R/lib/R/library/base/R/Rprofile && \
    # Set LDconfigs
    ln -sf /opt/R/include/* /usr/include/ && \
    ln -sf /opt/R/lib/R/lib/libR.so /usr/lib/ && \
    ln -sf /opt/R/lib/R/lib/libR.so /usr/local/lib/ && \
    ln -sf /opt/R/lib/R/lib/libR.so /usr/local/lib64/ && \
    echo " /opt/R/lib/R " >> /etc/ld.so.conf && \
    echo " /opt/R/lib/R/lib " >> /etc/ld.so.conf && ldconfig && \
    ## Install PyMB
    cd /opt && git clone https://github.com/sadatnfs/PyMB.git && \
    cd PyMB && python setup.py install



## Download and install shiny server
RUN wget --no-verbose https://s3.amazonaws.com/rstudio-shiny-server-os-build/ubuntu-12.04/x86_64/VERSION -O "version.txt" && \
    VERSION=$(cat version.txt)  && \
    wget --no-verbose "https://s3.amazonaws.com/rstudio-shiny-server-os-build/ubuntu-12.04/x86_64/shiny-server-$VERSION-amd64.deb" -O ss-latest.deb && \
    gdebi -n ss-latest.deb && \
    rm -f version.txt ss-latest.deb

#### Install RStudio

## Download and install RStudio server & dependencies
## Attempts to get detect latest version, otherwise falls back to version given in $VER
## Symlink pandoc, pandoc-citeproc so they are available system-wide
RUN wget -q http://ftp.debian.org/debian/pool/main/o/openssl/libssl1.0.0_1.0.1t-1+deb8u8_amd64.deb -O libssl1.0.0.deb  \
    && mkdir /etc/rstudio \
    && dpkg -i libssl1.0.0.deb \
    && rm libssl1.0.0.deb \
    && RSTUDIO_LATEST=$(wget --no-check-certificate -qO- https://s3.amazonaws.com/rstudio-server/current.ver) \
    && [ -z "$RSTUDIO_VERSION" ] && RSTUDIO_VERSION=$RSTUDIO_LATEST || true \
    && wget -q http://download2.rstudio.org/rstudio-server-${RSTUDIO_VERSION}-amd64.deb \
    && dpkg -i rstudio-server-${RSTUDIO_VERSION}-amd64.deb \
    && rm rstudio-server-*-amd64.deb \
    ## Symlink pandoc & standard pandoc templates for use system-wide
    && ln -s /usr/lib/rstudio-server/bin/pandoc/pandoc /usr/local/bin \
    && ln -s /usr/lib/rstudio-server/bin/pandoc/pandoc-citeproc /usr/local/bin \
    && git clone https://github.com/jgm/pandoc-templates \
    && mkdir -p /opt/pandoc/templates \
    && cp -r pandoc-templates*/* /opt/pandoc/templates && rm -rf pandoc-templates* \
    && mkdir /root/.pandoc && ln -s /opt/pandoc/templates /root/.pandoc/templates \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/ \
    ## RStudio wants an /etc/R, will populate from $R_HOME/etc
    && mkdir -p /etc/R \
    ## Write config files in $R_HOME/etc
    && echo '\n\
    \n# Configure httr to perform out-of-band authentication if HTTR_LOCALHOST \
    \n# is not set since a redirect to localhost may not work depending upon \
    \n# where this Docker container is running. \
    \nif(is.na(Sys.getenv("HTTR_LOCALHOST", unset=NA))) { \
    \n  options(httr_oob_default = TRUE) \
    \n}' >> ./etc/R/Rprofile.site \
    && echo "PATH=${PATH}" >> ./opt/R/lib/R/etc/Renviron \
    ## Need to configure non-root user for RStudio
    && useradd rstudio \
    && echo "rstudio:rstudio" | chpasswd \
    && mkdir /home/rstudio \
    && chown rstudio:rstudio /home/rstudio \
    && addgroup rstudio staff \
    ## Prevent rstudio from deciding to use /usr/bin/R if a user apt-get installs a package
    && echo '## Server Configuration File\nserver-app-armor-enabled=0\nrsession-which-r=/opt/R/bin/R\n' >> /etc/rstudio/rserver.conf \
    ## use more robust file locking to avoid errors when using shared volumes:
    && echo 'lock-type=advisory' >> /etc/rstudio/file-locks \
    ## configure git not to request password each time 
    && git config --system credential.helper 'cache --timeout=3600' \
    && git config --system push.default simple \
    ## Set up S6 init system
    && wget -P /tmp/ -q https://github.com/just-containers/s6-overlay/releases/download/v1.11.0.1/s6-overlay-amd64.tar.gz \
    && tar xzf /tmp/s6-overlay-amd64.tar.gz -C / \
    && mkdir -p /etc/services.d/rstudio \
    && echo '#!/bin/bash \
           \n exec /usr/lib/rstudio-server/bin/rserver --server-daemonize 0' \
           > /etc/services.d/rstudio/run \
    && echo '#!/bin/bash \
           \n rstudio-server stop' \
           > /etc/services.d/rstudio/finish && \
    chmod 777 /run/rstudio-server && \
    printf '\nPATH=/usr/local/UGE/bin/lx-amd64:/opt/intel/compilers_and_libraries/linux/lib/intel64_lin:/opt/conda/bin:/usr/lib/rstudio-server/bin:${PATH}\nSGE_ROOT=/usr/local/UGE\nSGE_CELL=ihme\nTZ=America/Los_Angeles\nSGE_QMASTER_PORT=6444\nSGE_EXECD_PORT=6445\n' >> /opt/R/lib/R/etc/Renviron && \
    echo "\nSINGULARITY_NAME=health_fin_R"  >> /opt/R/lib/R/etc/Renviron 
COPY userconf.sh /etc/cont-init.d/userconf
COPY add_shiny.sh /etc/cont-init.d/add


#### From Ian D:

# Bring in a piece of C code to enable us to dynamically set the MKL and OMP
# threads which we need to compile against the MKL library into a shared library
# we can call from R.
RUN mkdir /opt/compiled_code_for_R
COPY setthreads.c /opt/compiled_code_for_R
# We are linking against the libR.so in this case since we have one.
# Some tests for this live here: https://stash.ihme.washington.edu/users/imdavis/repos/testing/browse/mclapply_mkl
RUN cd /opt/compiled_code_for_R; \
    gcc -std=gnu99 -DMKL_ILP64 -fopenmp -m64 -I${MKLROOT}/include -I/usr/local/lib/gcc/x86_64-linux-gnu/8.2.0/include -I/opt/R/lib/R/include -DNDEBUG -fpic -g -O2 -fstack-protector-strong -Wformat -Werror=format-security -Wdate-time -D_FORTIFY_SOURCE=2 -g -c setthreads.c -o setthreads.o; \
    g++ -shared -L/opt/R/lib -L/opt/R/lib/R/lib -Wl,-Bsymbolic-functions -Wl,-z,relro -L${MKLROOT}/lib/intel64 -Wl,--no-as-needed -lmkl_intel_ilp64 -lmkl_gnu_thread -lmkl_core -lgomp -lpthread -lm -ldl -o setthreads.so setthreads.o -lR


#### Some essential R packages

## Get Pacman, and all else (with a little TensorFlow test)
RUN R -e 'install.packages(c("rgdal", "BH", "Rcpp", "RcppParallel", "codetools", "futile.logger", "Rcpp11", "opencpu", "benchmarkme", "compiler", "tcltk", "reticulate", "RcppEigen", "RcppArmadillo", "devtools", "pacman" ,"logging", "knitr", "Matrix", "arrayhelpers", "expm", "rockchalk", "formatR"), dependencies = T)' && \
    R -e 'install.packages("data.table", type = "source", repos = "http://Rdatatable.github.io/data.table", dependencies = T); data.table::test.data.table()' && \
    R -e "pacman::p_load(sp, jsr223, survival, foreach, lars, BiocInstaller, iterators, roxygen2, argparse, lintr, DBI, RStata, readstata13, haven, GenomicRanges, ranger, SIS, nanotime, pander, htmlTable, Hmisc, rapport, rapportools, optmatch, funModeling, summarytools, matrixcalc); install.packages('PKI', repos = 'http://rforge.net'); devtools::install_github('mingjerli/rWEO')"
RUN R -e "pacman::p_load(optparse, logitnorm, RJSONIO, packrat, tensorflow, tfestimators, pbzZMQ, rsconnect, ggplot2, shiny, bookdown, rsvg, profvis, assertable, RCurl, LaplacesDemon, MatrixModels, graph, testthat, spark, sparklyr, Lahman, nycflights13, rsparkling, h2o, backShift, mro, wpp2017, WDI, countrycode, reporttools, lazysql, doParallel, sfa, frontier, MASS, arm)" && \
    R -e "library(tensorflow) ; sess = tf\$Session(); hello <- tf\$constant('Hello, TensorFlow'); sess\$run(hello)" && \
    R -e 'source("http://packages.renjin.org/install.R")' && \
    R -e "devtools::install_github('IRkernel/IRkernel'); IRkernel::installspec(name = 'ir351', displayname = 'R 3.5.1 Docker', user = FALSE)"

## Data, presenting and manipulatin stuff (moved from forecasting, since these are really baseline stuff)
RUN R -e "pacman::p_load(RhpcBLASctl, RcppShark, CatEncoders, dat, lazyeval, BigQuic, SparseM, profmem, R.rsp, blockmatrix, R6, RMySQL, RMariaDB, xlsx, gmailr, openxlsx, readxl, writexl, rJava, rio, gsheet, matrixStats, tidyverse, plyr, dplyr, bigmemory, purrr, gcbd, microbenchmark)" && \
    R -e "pacman::p_load(RODBC, RSQLite, RMongo, nycflights13, Lahman, RPostgreSQL, qcc, reshape2, MatrixModels, XLConnect, slackr, formattable, ini, lubridate, tidyr, deSolve, streambugs, xts, httr, biganalytics, RCurl, pryr, covr, RcppProgress, aod, varhandle, raster, sf, fasterize)"
RUN R -e "pacman::p_load(RcppAlgos, RInside, digest, RcppCNPy, zipfR, bindrcpp, lambda.r, ProjectTemplate, purrrlyr, usethis, profr, rvest, sfsmisc, stringi, stringr, pipeR, magrittr, gdata, reprex, prettydoc, ghit, readr, feather, sqldf, quantmod, roll, chron, sqlutils, sqliter)" && \
    R -e "pacman::p_load(tidyquant, logging, parallelDist, RcppXPtrUtils, editR, officeR, zlibbioc, haven, rhdf5, h5, hdf5r, fst, RQuantLib, splitstackshape, stargazer, xtable, texreg, ezknitr, rmarkdown, kableExtra, yesno, rbenchmark, ncdf.tools, ncdump, ncdf4.helpers, ncdf4, mvnmle, bootstrap, simpleboot, decompr)"  && \
    R -e "pacman::p_load(remotes, RInside, RcppBlaze, complexplus, RcppGSL, RcppCCTZ, RcppZiggurat, RcppClassic, proxy, RProtoBuf, RcppTOML, RcppDE, RcppSMC, RApiSerialize, RcppExamples, RcppMsgPack, RcppStreams, RcppClassicExamples, RcppAPT, RcppGetconf, datadr, trelliscope); rio::install_formats()"


### TMB
RUN cd /opt && \
    git clone https://github.com/kaskr/adcomp.git && cd adcomp && \
    # Using custom mk file for SuiteSparse where I pointed SS to build with MKL BLAS
    sed -i "s/make library/rm SuiteSparse_config\/SuiteSparse_config\.mk\; wget https\:\/\/gist.githubusercontent.com\/sadatnfs\/1ed292c365d385a71efa329c890958f5\/raw\/ddb5022c327cfd9f247a4b0180e2b48c941e9367\/SuiteSparse\_config\.mk \-O SuiteSparse\_config\/SuiteSparse\_config\.mk\; make library BLAS=\$\{BLLP\} LAPACK=\$\{BLLP\}\; make install/g" Makefile && \
    sed -i 's/\-\o libcholmod\.so /\-o libcholmod\.so \/opt\/intel\/compilers\_and\_libraries\/linux\/mkl\/lib\/intel64\_lin\/libmkl\_rt\.so \/usr\/lib\/libmklml\_gnu\.so /g' Makefile && \
    make install-metis-full BLAS=${BLLP} LAPACK=${BLLP} BLLP=${BLLP}; make pdf

## RLightGBM
RUN cd /opt && git clone --recursive https://github.com/bwilbertz/RLightGBM.git && cd RLightGBM && \
    R CMD build --no-build-vignettes pkg/RLightGBM && R CMD INSTALL RLightGBM_*.tar.gz


### INLA
RUN cd /opt/R/lib/R/library && \
    ### Get INLA Makefile
    wget https://gist.githubusercontent.com/sadatnfs/8c28a1024fbec239fa29347bea456918/raw/52b00134a946f45af27a28f242a5353c3514df34/Makefile && \
    apt-get update && \
    make lib-install && \
    make download -d && \
    make bin-x11 && \
    mv inla/rinla/R/obsolete/* inla/rinla/R/ && \
    make package && \
    R --vanilla CMD INSTALL /opt/R/lib/R/library/tmp/RINLA/INLA_*.tgz && \
    # cd /tmp && rm -rf *  && rm -rf /var/lib/apt/lists/* && \
    ln -f /opt/R/lib/R/library/INLA/bin/linux/64bit/fmesher.run /opt/R/lib/R/library/INLA/bin/linux/64bit/fmesher.static && \
    ln -f /opt/R/lib/R/library/INLA/bin/linux/32bit/fmesher.run /opt/R/lib/R/library/INLA/bin/linux/32bit/fmesher.static && \
    ln -f /opt/R/lib/R/library/INLA/bin/linux/64bit/inla.run /opt/R/lib/R/library/INLA/bin/linux/64bit/inla.static && \
    ln -f /opt/R/lib/R/library/INLA/bin/linux/32bit/inla.run /opt/R/lib/R/library/INLA/bin/linux/32bit/inla.static && \
    rm -rf /opt/R/lib/R/library/inla && \
    rm -rf /opt/R/lib/R/library/local /opt/R/lib/R/library/tmp /opt/R/lib/R/library/inla
RUN R -e "pacman::p_load(INLABMA, nmaINLA, excursions); devtools::install_github('julianfaraway/brinla')"
