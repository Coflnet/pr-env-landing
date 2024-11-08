FROM registry.suse.com/bci/nodejs:20 as base

RUN npm i -g pnpm

FROM base as builder
WORKDIR /app

COPY ./package.json ./pnpm-lock.yaml ./

RUN rm -rf node_modules && pnpm install --frozen-lockfile

COPY . .

ENV HOST 0.0.0.0

CMD [ "pnpm", "run", "dev" ]


