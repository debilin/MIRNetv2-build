FROM docker.io/pytorch/pytorch:1.11.0-cuda11.3-cudnn8-runtime
LABEL Description="This image is used to build MIRNetv2 for Linux" Vendor="n/a" Version="0.3"

ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get -qq update && apt-get install -y \
    git \
    libglib2.0-0 \
    libgl1

RUN git clone https://github.com/swz30/MIRNetv2.git /MIRNetv2
WORKDIR /MIRNetv2

# Install requirements before copying project files

RUN pip install matplotlib scikit-learn scikit-image opencv-python yacs joblib natsort h5py tqdm
RUN pip install einops gdown addict future lmdb numpy pyyaml requests scipy tb-nightly yapf lpips

RUN python setup.py develop --no_cuda_ext

# Clean up to reduce image size
RUN apt-get clean && \
    rm -rf \
        /var/lib/apt/lists/* \
        /tmp/* \
        /var/tmp/*

# Set an entrypoint to the main enhance.py script
COPY entrypoint.sh /usr/bin
ENTRYPOINT ["entrypoint.sh"]
