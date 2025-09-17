FROM python:3.10-slim

# Set timezone
ENV TZ=Asia/Kolkata
ENV DEBIAN_FRONTEND=noninteractive
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Install system dependencies yang dibutuhkan Ultroid
RUN apt-get update && apt-get install -y --no-install-recommends \
    git bash curl wget unzip nano \
    ffmpeg mediainfo p7zip-full neofetch \
    ca-certificates locales \
    libglib2.0-0 libsm6 libxrender1 libxext6 \
    build-essential python3-dev libffi-dev libssl-dev \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Pastikan python3 default adalah 3.10
RUN ln -sf /usr/local/bin/python3 /usr/bin/python3

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
