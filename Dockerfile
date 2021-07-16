FROM continuumio/anaconda3
MAINTAINER Nicky Lemeshko <admin@mdsn.tk>
RUN pip install gdown && \
	cd /home && gdown https://drive.google.com/uc?id=1LRJzn6yhHHZSsvITO8aZ3hds0TgJNzSD && \
	apt update && apt install -y p7zip-full ffmpeg libsm6 libxext6 && \
	7z x SimSwap-main.7z && \
	cd SimSwap-main
SHELL ["/bin/bash", "-c"]
RUN	conda create -n simswap python=3.6 && source ~/.bashrc && conda activate simswap && \
        conda install pytorch==1.8.0 torchvision==0.9.0 torchaudio==0.8.0 cpuonly -c pytorch -y && \
	pip install --ignore-installed imageio && \
	pip install insightface==0.2.1 onnxruntime moviepy
RUN sed -i 's/base/simswap/' ~/.bashrc
WORKDIR /home/SimSwap-main