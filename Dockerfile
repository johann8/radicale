FROM python:3-alpine as builder

WORKDIR /app

# Version of Radicale
ARG RADICALE_VERSION=master

# Optional dependencies (e.g. bcrypt)
ARG DEPENDENCIES=bcrypt

RUN apk add --no-cache --virtual gcc libffi-dev musl-dev \
    && python -m venv /app/venv \
    && /app/venv/bin/pip install --no-cache-dir "Radicale[${DEPENDENCIES}] @ https://github.com/Kozea/Radicale/archive/${RADICALE_VERSION}.tar.gz"

FROM python:3-alpine

RUN apk add --no-cache apache2-utils \
    && adduser radicale --home /data --system --uid 1000 --disabled-password

COPY --chown=1000 --from=builder /app/venv /app

WORKDIR /app

COPY --chown=1000 ./config /etc/radicale/config
COPY --chown=1000 ./entrypoint.sh . 

RUN chmod +x /app/entrypoint.sh \
    && chmod 755 /app/entrypoint.sh   

ENV USER_FILE=/data/users

VOLUME [ "/data" ]

EXPOSE 5232

USER 1000

# Run Radicale
CMD [ "/app/entrypoint.sh" ]
