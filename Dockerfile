FROM continuumio/anaconda3
MAINTAINER Nicky Lemeshko <admin@mdsn.tk>
RUN  apt install git && cd /home && git clone https://github.com/neuralchen/SimSwap && cd SimSwap && git pull && \
	apt update && apt install -y megatools p7zip-full ffmpeg libsm6 libxext6 unzip && mkdir /home/SimSwap/arcface_model && \
        cd /home/SimSwap && megadl https://mega.nz/file/jhQmUbBY#cgiml1PxpK7IO9lVkN8kRr25uh6ZzWUHhKxG9woAl5Y && \
        cd /home/SimSwap/arcface_model && megadl https://mega.nz/file/79ICzJxA#EpRqQAfwh5wNuARg-0FfrZ3gyW_51s5b-euumu5BdNM && \
        unzip /home/SimSwap/checkpoints.zip -d /home/SimSwap/checkpoints && wget --no-check-certificate "https://sh23tw.dm.files.1drv.com/y4mmGiIkNVigkSwOKDcV3nwMJulRGhbtHdkheehR5TArc52UjudUYNXAEvKCii2O5LAmzGCGK6IfleocxuDeoKxDZkNzDRSt4ZUlEt8GlSOpCXAFEkBwaZimtWGDRbpIGpb_pz9Nq5jATBQpezBS6G_UtspWTkgrXHHxhviV2nWy8APPx134zOZrUIbkSF6xnsqzs3uZ_SEX_m9Rey0ykpx9w" -O antelope.zip && \
	unzip ./antelope.zip -d /home/SimSwap/insightface_func/models/ 
SHELL ["/bin/bash", "-c"]
RUN	conda create -n simswap python=3.6 && source ~/.bashrc && conda activate simswap && \
        conda install pytorch==1.8.0 torchvision==0.9.0 torchaudio==0.8.0 cpuonly -c pytorch -y && \
	pip install --ignore-installed imageio && \
	pip install insightface==0.2.1 onnxruntime moviepy
RUN sed -i 's/base/simswap/' ~/.bashrc
RUN sed -i "s/if len(self.opt.gpu_ids)/if torch.cuda.is_available() and len(self.opt.gpu_ids)/g" /home/SimSwap/options/base_options.py && sed -i "s/device = torch.device('cuda:0')/torch.device('cuda:0' if torch.cuda.is_available() else 'cpu')/g" /home/SimSwap/models/fs_model.py && sed -i "s/torch.load(netArc_checkpoint)/torch.load(netArc_checkpoint) if torch.cuda.is_available() else torch.load(netArc_checkpoint, map_location=torch.device('cpu'))/g" /home/SimSwap/models/fs_model.py && \
find /home/SimSwap -type f -exec sed -i "s/net.load_state_dict(torch.load(save_pth))/net.load_state_dict(torch.load(save_pth)) if torch.cuda.is_available() else net.load_state_dict(torch.load(save_pth, map_location=torch.device('cpu')))/g" {} \; && find /home/SimSwap -type f -exec sed -i "s/.cuda()/.to(torch.device('cuda:0' if torch.cuda.is_available() else 'cpu'))/g" {} \; && find /home/SimSwap -type f -exec sed -i "s/.to('cuda')/.to(torch.device('cuda:0' if torch.cuda.is_available() else 'cpu'))/g" {} \; && sed -i "s/torch.device(\"cuda:0\")/torch.device('cuda:0' if torch.cuda.is_available() else 'cpu')/g" /home/SimSwap/models/fs_model.py
WORKDIR /home/SimSwap
