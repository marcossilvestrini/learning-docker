FROM nginx:latest

LABEL description="Web App by Silvestrini"

ARG DOCKER_APP_DIR=/var/www/

ARG PORT_BUILD=80

ENV PORT=${PORT_BUILD}

ENV DOCKER_APP_DIR=${DOCKER_APP_DIR}

EXPOSE ${PORT_BUILD}

WORKDIR ${DOCKER_APP_DIR}

COPY . .
