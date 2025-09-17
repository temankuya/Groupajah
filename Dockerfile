FROM python:3.10-slim

ENV TZ=Asia/Kolkata
ENV DEBIAN_FRONTEND=noninteractive

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Install system dependencies tanpa Python
RUN apt-get update && apt-get install -y --no-install-recommends \
    git bash curl wget unzip nano \
    ffmpeg mediainfo p7zip-full neofetch \
    ca-certificates locales \
    libglib2.0-0 libsm6 libxrender1 libxext6 libx11-6 libxcb1 \
    build-essential libffi-dev libssl-dev python3-dev \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Buat folder Ultroid & set WORKDIR
RUN mkdir -p /root/TeamUltroid
WORKDIR /root/TeamUltroid

# Copy installer.sh dan project files
COPY installer.sh .
COPY . .

RUN chmod +x installer.sh
RUN bash installer.sh

# Upgrade pip & install requirements
RUN pip install --no-cache-dir --upgrade pip setuptools wheel
RUN if [ -f requirements.txt ]; then pip install --no-cache-dir -r requirements.txt; fi

CMD ["bash", "startup"]
