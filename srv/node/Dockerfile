FROM ubuntu:16.04

RUN apt-get clean && apt-get update
RUN apt-get -y install curl && \
    apt-get -y install wget && \
    apt-get -y install apt-utils && \
    apt-get autoremove -y

FROM node:carbon

ENV NPM_CONFIG_LOGLEVEL warn

ADD frontend/package.json /tmp/frontend/
ADD api/package.json /tmp/api/

COPY frontend/package.json /srv/www/frontend/
COPY api/package.json /srv/www/api

WORKDIR /srv/www

COPY . ./

RUN npm config set maxsockets 5 && npm config set progress false
RUN cd /srv/www/frontend && npm install & npm run build
RUN cd /srv/www/api && npm install && npm run build

RUN npm install -g pm2

CMD ["pm2", "start", "process.yml", "--no-daemon"]

EXPOSE 5000
EXPOSE 8080