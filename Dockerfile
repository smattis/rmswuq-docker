# Authors:
# Steve Mattis <steve.a.mattis@gmail.com>
FROM fenicsproject/stable-ppa
MAINTAINER Steve Mattis

# Install dependencies and BET
RUN apt-get -qq update && \
    apt-get -qqy install python-pip git emacs && \
    apt-get clean && \
    pip install pyDOE && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


# Set up user so that we do not run as root
RUN useradd -m -s /bin/bash -G sudo,docker_env rmswuq && \
    echo "rmswuq:docker" | chpasswd && \
    echo "rmsuq ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# See https://github.com/phusion/baseimage-docker/issues/186
RUN touch /etc/service/syslog-forwarder/down

# This makes sure we launch with ENTRYPOINT /bin/bash into the home directory
ENV HOME /home/rmswuq
# Install BET
RUN cd $HOME && \
    git clone https://github.com/UT-CHG/BET.git && \
    cd BET && \
    python setup.py install 
RUN chmod -R a+rwx $HOME

     
ADD WELCOME /home/rmswuq/WELCOME
RUN cp /home/rmswuq/.bashrc /home/rmswuq/.bashrc.tmp && \
    echo "cd $HOME" >> /home/rmswuq/.bashrc.tmp && \
    echo "cat $HOME/WELCOME" >> /home/rmswuq/.bashrc.tmp

ENTRYPOINT ["/sbin/my_init","--quiet","--","sudo","-u","rmswuq","/bin/sh","-c"]
CMD ["/bin/bash --rcfile /home/rmswuq/.bashrc.tmp"]