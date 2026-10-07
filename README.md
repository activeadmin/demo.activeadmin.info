# Active Admin Demo

This is a sample application to demo Active Admin.

https://activeadmin-demo.onrender.com

Conferences demonstrate a custom **Clone as Draft** member action with an ERB
form. It copies the conference and sessions in a transaction, optionally retains
speaker assignments, and shifts session dates while preserving venue-local times.
The source records, venue, rooms, and speakers remain available for reuse.

The **Publish Readiness** report uses an ERB member-action view and the same
service as the publication validation. It checks active sessions for speakers,
valid times, dates within the conference's venue-local date range, and rooms at
the conference venue. Cancelled sessions are excluded. Incomplete drafts remain
editable; publishing is checked through forms, individual actions, and batch
actions. A failed batch rolls back every selected conference's publication change.

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
