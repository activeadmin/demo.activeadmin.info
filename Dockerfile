FROM node:17.6.0-bullseye as node-builder
RUN rm /usr/local/bin/corepack /usr/local/bin/docker-entrypoint.sh

FROM ruby:3.1.1-bullseye as base

# install nodejs
COPY --from=node-builder /usr/local/lib/node_modules /usr/local/lib/node_modules
COPY --from=node-builder /opt/yarn-v1.22.17 /opt/yarn-v1.22.17
COPY --from=node-builder /usr/local/bin /usr/local/bin

ENV DATABASE_PASSWORD=''

RUN set -ex; \
    curl https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - ; \
    echo "deb https://apt.postgresql.org/pub/repos/apt/ bullseye-pgdg main 14" > /etc/apt/sources.list.d/pgdg.list; \
    apt-get update -y; \
    apt-get install -y --no-install-recommends \
    postgresql-14 postgresql-client-14; \
    echo 'host    all             all             127.0.0.1/32            trust' > /etc/postgresql/14/main/pg_hba.conf

WORKDIR /myapp

COPY Gemfile Gemfile.lock /myapp/

RUN bundle config set without test \
    && bundle install

EXPOSE 3000

CMD "bash"