# The Active Admin Demo
[![Github Actions](https://github.com/activeadmin/demo.activeadmin.info/workflows/test/badge.svg)](https://github.com/activeadmin/demo.activeadmin.info/actions)

This is a sample store application to demo Active Admin.

https://demo.activeadmin.info

The demo site was hosted on Heroku using free dynos. We have not transitioned yet to a new service so this demo is only available through local setup.

## Local Development Setup

- Clone this repository
- `brew install libpq && brew link --force libpq` so the `pg` gem will install
- [Install Docker Desktop](https://www.docker.com/products/docker-desktop/)
- Install Ruby 3 with [rbenv](https://github.com/rbenv/rbenv)
- Install Node 18 with [nodenv](https://github.com/nodenv/nodenv)
- Run `bundle install`

### Database Setup

- `docker compose up`
- `bin/rails db:reset`

### Start Development

- `docker compose up`
- `bin/dev`
- Open http://localhost:5000
