FROM python:3.10.4-slim-buster

ENV DEBIAN_FRONTEND=noninteractive

# Fix Buster repo location (officially moved to archive.debian.org)
RUN sed -i 's|http://deb.debian.org|http://archive.debian.org|g' /etc/apt/sources.list && \
    sed -i 's|security.debian.org|archive.debian.org|g' /etc/apt/sources.list && \
    echo 'Acquire::Check-Valid-Until "false";' > /etc/apt/apt.conf.d/99no-check-valid && \
    apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
        git \
        curl \
        wget \
        ffmpeg \
        bash \
        neofetch \
        software-properties-common \
        build-essential \
        ca-certificates && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy and install Python dependencies
COPY requirements.txt .
RUN pip3 install --upgrade pip wheel && \
    pip3 install --no-cache-dir -r requirements.txt

# Copy bot code
COPY . .

EXPOSE 5000

# Run bot only (worker dyno friendly)
CMD ["python3", "-m", "devgagan"]
