# start from cuda 12.4 ubuntu container
FROM nvidia/cuda:12.4.0-devel-ubuntu22.04

# set root password to root
RUN echo 'root:root' | chpasswd

# prepare docker installation
RUN apt-get update && \
    apt-get install -y ca-certificates curl && \
    install -m 0755 -d /etc/apt/keyrings && \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc && \
    chmod a+r /etc/apt/keyrings/docker.asc && \
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
      $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
      tee /etc/apt/sources.list.d/docker.list > /dev/null


# install docker
RUN apt-get update && \
    apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin


# prepare nvidia-container-toolkit installation
RUN curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg && \
    curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | \
    sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
    tee /etc/apt/sources.list.d/nvidia-container-toolkit.list


# install nvidia-container-toolkit
RUN apt-get update && \
    apt-get install -y nvidia-container-toolkit


# clone and checkout cvat
RUN apt-get install -y git && apt-get install -y wget && \
    git clone https://github.com/cvat-ai/cvat && cd cvat && \
    git checkout v2.20.0 && \
    git submodule update --recursive --init


COPY run.sh /root/run.sh

ENTRYPOINT ["/usr/sbin/init"]
