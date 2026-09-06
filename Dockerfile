FROM python:3.12-slim-trixie

ARG BUILDX_QEMU_ENV

WORKDIR /usr/src/app

COPY requirements.txt ./
COPY run.py ./

ENV CRYPTOGRAPHY_DONT_BUILD_RUST=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

RUN python -m pip install --upgrade pip

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        gcc \
        g++ \
        libffi-dev \
        rustc \
        zlib1g-dev \
        libjpeg-dev \
        libssl-dev \
        libblas-dev \
        liblapack-dev \
        make \
        cmake \
        automake \
        ninja-build \
        subversion \
        python3-dev \
    && if [ "${BUILDX_QEMU_ENV}" = "true" ] && [ "$(getconf LONG_BIT)" = "32" ]; then \
        python -m pip install -U cryptography==3.3.2; \
    fi \
    && python -m pip install --no-cache-dir -r requirements.txt \
    && apt-get remove -y gcc g++ rustc \
    && apt-get autoremove -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /usr/share/doc/*

ADD TwitchChannelPointsMiner ./TwitchChannelPointsMiner

ENTRYPOINT ["python", "run.py"]
