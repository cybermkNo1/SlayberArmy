FROM python:3.10-slim

ENV DEBIAN_FRONTEND=noninteractive

# Install ffmpeg + dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends ffmpeg git curl wget bash build-essential ca-certificates && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Install Python dependencies
COPY requirements.txt .
RUN pip3 install --upgrade pip wheel && \
    pip3 install --no-cache-dir -r requirements.txt

# Copy bot code
COPY . .

EXPOSE 5000

# Run bot (polling)
CMD ["python3", "-m", "devgagan"]
