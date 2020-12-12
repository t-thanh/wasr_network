#getting base image tensorflow/tensorflow:1.8.0-gpu
FROM tensorflow/tensorflow:1.8.0-gpu

MAINTAINER t-thanh <tien.thanh@eu4m.eu>

RUN apt-get update && apt-get install -y terminator sudo git wget imagemagick
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
WORKDIR /home/docker
#install miniconda
RUN wget https://repo.anaconda.com/miniconda/Miniconda2-latest-Linux-x86_64.sh 
RUN bash ~/Miniconda2-latest-Linux-x86_64.sh -b -p ~/miniconda2 
ENV PATH=/home/docker/miniconda2/bin:${PATH}
RUN conda update -y conda
## Install wasr-network requirements
CMD ["bash"] pip install tensorflow-gpu==1.8 && conda install opencv numpy scipy matplotlib && pip install image
## Clone the repo
RUN cd ~ && git clone https://github.com/t-thanh/wasr_network
# Download the pre-trained weight
RUN cd /home/docker/wasr_network/example_weights/no_imu && wget https://www.dropbox.com/s/wiy3e4p5o6gjl1m/arm8imu3_noimu.ckpt-80000.data-00000-of-00001
# RUN sample code
CMD ["bash"] cd /home/docker/wasr_network && python wasr_inference_noimu_general.py --model-weights /home/docker/sources/wasr_network/example_weights/no_imu/arm8imu3_noimu.ckpt-80000 --img-path /home/docker/wasr_network/test.jpg
# Display result
CMD ["bash"] display /home/docker/wasr_network/test.jpg & display /home/docker/wasr_network/output/output_mask.png
