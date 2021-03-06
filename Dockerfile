FROM node:alpine AS base

RUN mkdir -p /code
WORKDIR /code
CMD "hsd"

RUN apk upgrade --no-cache && \
    apk add --no-cache bash unbound-dev git

COPY package.json \
     #package-lock.json \
     /code/

FROM base AS build
# Install build dependencies
RUN apk add --no-cache g++ gcc make python2

# Install hsd
RUN npm install --production

FROM base
ENV PATH="${PATH}:/code/bin:/code/node_modules/.bin"
COPY --from=build /code/node_modules /code/node_modules/
COPY bin /code/bin/
COPY lib /code/lib/

