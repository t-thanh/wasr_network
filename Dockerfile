#getting base image tensorflow/tensorflow:1.8.0-gpu
FROM tensorflow/tensorflow:1.8.0-gpu

MAINTAINER t-thanh <tien.thanh@eu4m.eu>

RUN apt-get update && apt-get install -y terminator && apt-get install sudo
RUN adduser --disabled-password --gecos '' docker
RUN adduser docker sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
RUN export uid=1000 gid=1000
RUN mkdir -p /home/docker
RUN echo "docker:x:${uid}:${gid}:docker,,,:/home/docker:/bin/bash" >> /etc/passwd
RUN echo "docker:x:${uid}:" >> /etc/group
#RUN echo "docker ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
RUN chmod 0440 /etc/sudoers
RUN chown ${uid}:${gid} -R /home/docker

USER docker
#USER docker
WORKDIR /home/docker
#install miniconda
RUN apt-get -y install wget
RUN wget -- quite https://repo.anaconda.com/miniconda/Miniconda2-latest-Linux-x86_64.sh -O ~/miniconda.sh && sh ~/miniconda.sh -b -p ~/miniconda2 && source ~/.bashrc 
## Install wasr-network requirements
RUN pip install tensorflow-gpu==1.8 && conda install opencv numpy scipy matplotlib && pip install image
