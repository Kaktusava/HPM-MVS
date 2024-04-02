# Официальный образ NVIDIA CUDA как базовый
# FROM nvidia/cuda:11.7.1-cudnn8-devel-ubuntu22.04
FROM cr.ai.cloud.ru/aicloud-jupyter/jupyter-server:0.0.93
USER root
# awoid public GPG key error
# RUN rm /etc/apt/sources.list.d/cuda.list \
#     && rm /etc/apt/sources.list.d/nvidia-ml.list \
#     && apt-key del 7fa2af80 \
#     && apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/3bf863cc.pub \
#     && apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1804/x86_64/7fa2af80.pub

# Install the required packages for cv

RUN DEBIAN_FRONTEND=noninteractive apt-get clean \
 && DEBIAN_FRONTEND=noninteractive apt-get update -qq \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    ffmpeg libsm6 libxext6 git ninja-build libglib2.0-0 libsm6 libxrender-dev libxext6 \
    gnupg2 \
    software-properties-common \
    make \
    cmake \
    git \
    wget \
    curl \
    libeigen3-dev \
    libgmp-dev \
    libgmpxx4ldbl \
    libmpfr-dev \
    libboost-dev \
    libboost-thread-dev \
    libtbb-dev \
    build-essential \
    libopencv-dev \
    libboost-all-dev \
    && rm -rf /var/lib/apt/lists/*

# Add NVIDIA package repository
# RUN wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-ubuntu2204.pin \
#     && mv cuda-ubuntu2204.pin /etc/apt/preferences.d/cuda-repository-pin-600 \
#     && apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/3bf863cc.pub \
#     && add-apt-repository "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/ /" \
#     && apt-get update


# # Install CUDA 11-8
# RUN wget -q -O /tmp/cuda-12-0_12.0.0-1_amd64.deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-12-0_12.0.0-1_amd64.deb \
#   && dpkg -i /tmp/cuda-12-0_12.0.0-1_amd64.deb 
# RUN apt-get install -y cuda-11-8

# NVIDIA CUDA Toolkit
RUN wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-ubuntu2204.pin && \
    mv cuda-ubuntu2204.pin /etc/apt/preferences.d/cuda-repository-pin-600 && \
    wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-keyring_1.1-1_all.deb && \
    mv cuda-keyring_1.1-1_all.deb /usr/share/keyrings/cuda-keyring_1.1-1_all.deb && \
    echo "deb [signed-by=/usr/share/keyrings/cuda-archive-keyring.gpg] https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/ /" | tee /etc/apt/sources.list.d/cuda.list && \
    apt-get update && \
    apt-get -y install cuda-toolkit-11-8



# # Set environment variables
# ENV PATH=/usr/local/cuda-12.0/bin${PATH:+:${PATH}}
# ENV LD_LIBRARY_PATH=/usr/local/cuda-12.0/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}

# Install CUDA using Conda
USER jovyan

# RUN conda install -y -c conda-forge -c nvidia cuda=11.8 cudatoolkit=11.8

# Set environment variables for CUDA
# ENV PATH /home/user/conda/bin:$PATH
# ENV LD_LIBRARY_PATH /home/user/conda/lib${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}


WORKDIR /HPM-MVS
COPY ./ /HPM-MVS
RUN mkdir build && cd build && cmake ..
RUN cd build && make

WORKDIR /workspace