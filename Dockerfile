FROM python:3.12-slim-trixie

WORKDIR /usr/src/app

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1

COPY requirements.txt .

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        gcc \
        g++ \
        libffi-dev \
        libjpeg-dev \
        libssl-dev \
        zlib1g-dev \
        libblas-dev \
        liblapack-dev \
        make \
        cmake \
        automake \
        ninja-build \
        subversion \
        rustc \
    && pip install --upgrade pip \
    && pip install -r requirements.txt \
    && apt-get purge -y \
        gcc \
        g++ \
        rustc \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/*

COPY run.py .
COPY TwitchChannelPointsMiner ./TwitchChannelPointsMiner

ENTRYPOINT ["python", "run.py"]
