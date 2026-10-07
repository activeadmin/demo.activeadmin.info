# Active Admin Demo

This is a sample application to demo Active Admin.

https://activeadmin-demo.onrender.com

Conferences demonstrate a custom **Clone as Draft** member action with an ERB
form. It copies the conference and sessions in a transaction, optionally retains
speaker assignments, and shifts session dates while preserving venue-local times.
The source records, venue, rooms, and speakers remain available for reuse.

## Development Setup

- Clone this repository
- Install Ruby with [rbenv](https://github.com/rbenv/rbenv) or [mise](https://mise.jdx.dev/) (see `.ruby-version` for the required version)
- Install Node with [nodenv](https://github.com/nodenv/nodenv) or [mise](https://mise.jdx.dev/) (see `.node-version` for the required version)
- `bundle install`
- `npm install`
- `bin/rails db:reset`
- `bin/dev`

Open http://localhost:5000 and sign in with `admin@example.com` and `password`.

### Tests

Run `bin/rails test:all`
