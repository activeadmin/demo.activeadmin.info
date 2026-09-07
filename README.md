# Active Admin Demo

This is a sample application to demo Active Admin.

https://activeadmin-demo.onrender.com

## Development Setup

- Clone this repository
- Install Ruby with [rbenv](https://github.com/rbenv/rbenv) or [mise](https://mise.jdx.dev/) (see `.ruby-version` for the required version)
- Install Node with [nodenv](https://github.com/nodenv/nodenv) or [mise](https://mise.jdx.dev/) (see `.node-version` for the required version)
- `bundle install`
- `npm install`
- `bin/rails db:seed`
- `bin/dev`

Open http://localhost:5000 and login using `admin@example.com` and `password`.

### Tests

Run `bin/rails test:all`

## Non-ActiveRecord Example

Open **API Posts** in the admin navigation to browse a read-only resource without
an ActiveRecord model. This example follows
[activeadmin/activeadmin#9039](https://github.com/activeadmin/activeadmin/pull/9039).

- `app/models/api_post.rb` simulates an API with seven in-memory records. It filters
  by title (case-sensitive substring) and status before returning a page and its
  total count. No external service, credentials, migration, or seed data is needed.
- `app/admin/api_posts.rb` overrides `find_collection` and uses
  `Kaminari.paginate_array` to adapt the response for ActiveAdmin's pagination.
  The search object keeps the filter inputs populated; **Clear Filters** resets them.
- Sorting, downloads, comments, and batch actions are disabled. The active-filter
  chips are also disabled because they require a Ransack search object.

The ActiveAdmin gem is temporarily pinned to PR #9039's commit
`e372fc404d788824c0974894418313849f577a1c`, which includes the required non-ActiveRecord
fixes. Replace this pin with a released version containing those fixes when available.
