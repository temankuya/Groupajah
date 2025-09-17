# Ultroid - UserBot (Custom Build with installer.sh)
FROM python:3.11-slim

# Set timezone
ENV TZ=Asia/Kolkata
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Install dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    git ffmpeg mediainfo neofetch curl sudo \
    && rm -rf /var/lib/apt/lists/*

# Copy installer script
WORKDIR /root
COPY installer.sh installer.sh
RUN chmod +x installer.sh

# Jalankan installer (clone + install deps + pip install)
RUN bash installer.sh --dir=/root/TeamUltroid --branch=main --env-file=.env --no-root

# Copy .env ke container (biar bot langsung jalan)
COPY .env /root/TeamUltroid/.env

# Set workdir ke repo Ultroid
WORKDIR /root/TeamUltroid

# Expose port (kalau bot ada webpanel)
EXPOSE 8080

# Start Ultroid
CMD ["bash", "startup"]
