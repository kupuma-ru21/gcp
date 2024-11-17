# Ref: https://www.googlecloudcommunity.com/gc/Community-Blogs/No-servers-no-problem-A-guide-to-deploying-your-React/ba-p/690760
# Ref: https://pnpm.io/docker
# Before running "gcloud builds submit -t ...", you have to login using "gcloud auth login" and "gcloud config set project ..."

FROM node:20-slim AS base

ARG VITE_APP_TITLE

ENV VITE_APP_TITLE=${VITE_APP_TITLE}

RUN corepack enable
COPY . /app
WORKDIR /app

FROM base AS prod-deps
RUN echo "HERE"
RUN echo "VITE_APP_TITLE=$VITE_APP_TITLE"
RUN pnpm install --prod

FROM base AS build
RUN pnpm install
RUN pnpm run build

FROM base
COPY --from=prod-deps /app/node_modules /app/node_modules
COPY --from=build /app/build /app/build
EXPOSE 3000
CMD [ "pnpm", "start" ]
