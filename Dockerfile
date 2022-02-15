FROM node:17.4.0-buster as node-builder
RUN cp -r /usr/local/bin /usr/local/cp-bin \
  && rm /usr/local/cp-bin/corepack /usr/local/cp-bin/docker-entrypoint.sh

FROM ruby:3.0.3-buster as base

# install nodejs
RUN mkdir /usr/local/lib/node_modules /opt/yarn-v1.22.17
COPY --from=node-builder /usr/local/lib/node_modules /usr/local/lib/node_modules
COPY --from=node-builder /opt/yarn-v1.22.17 /opt/yarn-v1.22.17
COPY --from=node-builder /usr/local/cp-bin /usr/local/bin

ENV DATABASE_PASSWORD=''

RUN set -ex; \
    curl https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - ; \
    echo "deb http://apt.postgresql.org/pub/repos/apt/ buster-pgdg main 14" > /etc/apt/sources.list.d/pgdg.list; \
    apt-get update -y; \
    apt-get install -y --no-install-recommends \
    postgresql-14 postgresql-client-14; \
    echo 'host    all             all             127.0.0.1/32            trust' > /etc/postgresql/14/main/pg_hba.conf

WORKDIR /myapp

COPY Gemfile Gemfile.lock /myapp/

RUN gem install bundler \
  && bundle config set --local without test \
  && bundle install -j4

EXPOSE 3000

CMD "bash"