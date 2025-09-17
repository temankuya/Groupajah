FROM python:3.10-slim

# Set timezone
ENV TZ=Asia/Kolkata
ENV DEBIAN_FRONTEND=noninteractive
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Install system dependencies yang dibutuhkan Ultroid
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
        python3.10 python3-pip python3-venv sudo \
        git bash curl wget unzip nano \
        ffmpeg mediainfo p7zip-full neofetch \
        ca-certificates locales \
        libglib2.0-0 libsm6 libxrender1 libxext6 \
    && apt-get clean && rm -rf /var/lib/apt/lists/*
    

# Buat folder default Ultroid dan set working directory
RUN mkdir -p /root/TeamUltroid
WORKDIR /root/TeamUltroid

# Copy installer.sh dan project files
COPY installer.sh .
COPY . .

# Pastikan installer.sh executable
RUN chmod +x installer.sh

# Jalankan installer
RUN bash installer.sh

# Upgrade pip & install Python dependencies jika ada requirements.txt
RUN pip install --no-cache-dir --upgrade pip setuptools wheel
RUN if [ -f requirements.txt ]; then pip install --no-cache-dir -r requirements.txt; fi

# Jalankan bot
CMD ["bash", "startup"]
