FROM python:3.10-slim

# Set timezone
ENV TZ=Asia/Kolkata
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Install dependencies (git, bash, curl, ffmpeg, dll)
RUN apt-get update && apt-get install -y --no-install-recommends \
    git bash curl ffmpeg \
    && rm -rf /var/lib/apt/lists/*

# Copy installer.sh
COPY installer.sh .

# Run installer
RUN bash installer.sh

# Changing workdir
WORKDIR /root/TeamUltroid

# Start the bot
CMD ["bash", "startup"]
