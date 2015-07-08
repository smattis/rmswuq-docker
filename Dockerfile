FROM phusion/baseimage:0.9.16
MAINTAINER Steve Mattis

# Install dependencies and BET
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    apt-get autoclean && \
    apt-get clean && \
    apt-get -qq update && \
    apt-get -qqy install python-software-properties && \
    add-apt-repository -y ppa:fenics-packages/fenics && \
    apt-get -qq update && \
    apt-get -qqy install xauth fenics ipython xterm libatlas3gf-base python-pip git emacs build-essential openmpi-bin libopenmpi-dev libboost-all-dev gsl-bin libgsl0-dev wget autotools-dev autoconf make libtool && \
    apt-get clean && \
    pip install pyDOE && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


# Set up user so that we do not run as root
RUN useradd -m -s /bin/bash -G sudo,docker_env rmswuq && \
    echo "rmswuq:docker" | chpasswd && \
    echo "rmsuq ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# See https://github.com/phusion/baseimage-docker/issues/186
RUN touch /etc/service/syslog-forwarder/down

# Set backend for matplotlibrc to Agg
RUN  echo "backend : agg" > /etc/matplotlibrc

# This makes sure we launch with ENTRYPOINT /bin/bash into the home directory
ENV HOME /home/rmswuq
RUN mkdir $HOME/src

# Install BET
RUN cd $HOME/src && \
    git clone https://github.com/UT-CHG/BET.git && \
    cd BET && \
    python setup.py install 
RUN chmod -R a+rwx $HOME

# Install QUESO
RUN cd $HOME/src && \
    wget https://github.com/libqueso/queso/archive/v0.53.0.tar.gz && \
    tar xvfz v0.53.0.tar.gz && \
    rm -r -f  v0.53.0.tar.gz && \
    cd queso-0.53.0 && \
    ./bootstrap && \
    export CC="mpicc" && \
    export CXX="mpicxx" && \
    ./configure && \
    make && \
    make install
    #make check

# Add Demos
RUN mkdir $HOME/demos && \
    cd $HOME/demos && \
    cp -R ../src/BET/examples BET-examples && \
    chmod -R a+rwx $HOME/demos 
     
ADD WELCOME /home/rmswuq/WELCOME
ENV LD_LIBRARY_PATH  /usr/local/lib:/usr/lib
RUN cp /home/rmswuq/.bashrc /home/rmswuq/.bashrc.tmp && \
    echo "cd $HOME" >> /home/rmswuq/.bashrc.tmp && \
    echo "cat $HOME/WELCOME" >> /home/rmswuq/.bashrc.tmp

ENTRYPOINT ["/sbin/my_init","--quiet","--","sudo","-u","rmswuq","/bin/sh","-c"]
CMD ["/bin/bash --rcfile /home/rmswuq/.bashrc.tmp"]