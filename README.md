# The Active Admin Store
[![Github Actions](https://github.com/activeadmin/demo.activeadmin.info/workflows/test/badge.svg)](https://github.com/activeadmin/demo.activeadmin.info/actions)

This is a test application to demo Active Admin.

http://demo.activeadmin.info


## Local development setup

Dependencies: Ruby 3.1 and PostgreSQL

* Clone project using Git
* Run `bundle install`
* Configure database:
  - Create the DB user by running command:
    ```
    sudo -u postgres psql -c "CREATE USER demo_aa WITH CREATEDB NOCREATEROLE PASSWORD 'demo_aa'"
    ```
  - Export the environment to set the credentials with
    ```
    export DATABASE_USERNAME=demo_aa DATABASE_PASSWORD=demo_aa
    ```
  - You can use [direnv](https://github.com/direnv/direnv) so that you don't need to export these environment variables every time, or change username/password in `config/database.yml`
* Run command `bin/rails db:setup` to create database with seed data.
* Start server: `bin/rails s`
* Navigate in browser to: http://localhost:3000/admin


### Local development setup with Docker

* Clone project using Git\
* Run `docker build . --tag demo-activeadmin` to create docker image
* Run `docker volume create demo-activeadmin-db` to create db volume
* Run Docker
  - Linux/macOS:  `docker run -v $(pwd):/myapp -v demo-activeadmin-db:/var/lib/postgresql/data -p 3000:3000 -it --rm demo-activeadmin`
  - Windows CMD:  `docker run -v %cd%:/myapp -v demo-activeadmin-db:/var/lib/postgresql/data -p 3000:3000 -it --rm demo-activeadmin`
* Run Postgres `service postgresql start`
* Run command `bin/rails db:setup` to create database with seed data.
* Start server: `bin/rails s -b 0.0.0.0`
* Navigate in browser to: http://localhost:3000/admin