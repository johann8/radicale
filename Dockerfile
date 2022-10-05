FROM python:3-alpine as builder

WORKDIR /app

# Version of Radicale
ARG RADICALE_VERSION=master

# Optional dependencies (e.g. bcrypt)
ARG DEPENDENCIES=bcrypt

RUN apk add --no-cache alpine-sdk libffi-dev \
    && python -m venv /app/venv \
    && /app/venv/bin/pip install --no-cache-dir "Radicale[${DEPENDENCIES}] @ https://github.com/Kozea/Radicale/archive/${VERSION}.tar.gz"
    #RUN pip install --user radicale[bcrypt]==$RADICALE_VERSION

FROM python:3-alpine

RUN apk add --no-cache apache2-utils

COPY --from=builder /root/.local /root/.local
ENV PATH=/root/.local:$PATH

WORKDIR /app

COPY ./config /etc/radicale/config
COPY ./entrypoint.sh .

ENV USER_FILE=/data/users

VOLUME [ "/data" ]

EXPOSE 5232

CMD [ "/app/entrypoint.sh" ]
