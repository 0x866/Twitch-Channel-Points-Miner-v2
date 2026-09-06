FROM python:3.12-slim-trixie

WORKDIR /usr/src/app

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1

COPY requirements.txt .

RUN python -m pip install --upgrade pip \
    && python -m pip install -r requirements.txt

COPY run.py .
COPY TwitchChannelPointsMiner ./TwitchChannelPointsMiner

ENTRYPOINT ["python", "run.py"]
