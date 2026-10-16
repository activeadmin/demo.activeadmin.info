# Event-domain model generators

Run these commands from the application root to create the models for the
ActiveAdmin event-domain demo.  The state-like fields are strings so their
models can later declare Rails enums (for example, `enum :status, ...`).

`TalkSpeaker` is the explicit join model between `Talk` and `Speaker`; it
also records each speaker's role and presentation order.

```sh
bin/rails generate model Venue name:string address_line_1:string address_line_2:string city:string region:string postal_code:string country_code:string timezone:string latitude:decimal{10,6} longitude:decimal{10,6} accessibility_notes:text

bin/rails generate model Event venue:references name:string slug:string description:text starts_on:date ends_on:date status:string capacity:integer published:boolean

bin/rails generate model Room venue:references name:string floor:string capacity:integer setup_type:string accessible:boolean

bin/rails generate model Talk event:references room:references title:string abstract:text starts_at:datetime ends_at:datetime track:string format:string capacity:integer livestream_url:string

bin/rails generate model Speaker name:string email:string company:string job_title:string bio:text website:string social_links:jsonb

bin/rails generate model TalkSpeaker talk:references speaker:references role:string display_order:integer introduced_by:string

bin/rails generate model Attendee name:string email:string company:string job_title:string phone:string bio:text marketing_opt_in:boolean

bin/rails generate model TicketType event:references name:string price:decimal{10,2} quantity_available:integer sales_open_at:datetime sales_close_at:datetime visible:boolean

bin/rails generate model Registration event:references attendee:references ticket_type:references status:string ticket_code:string amount_paid:decimal{10,2} checked_in_at:datetime dietary_requirements:text

bin/rails generate model Sponsor event:references name:string tier:string website:string contact_name:string contact_email:string committed_amount:decimal{10,2} active:boolean

bin/rails generate model Proposal event:references attendee:references title:string abstract:text format:string status:string reviewer_notes:text score:integer

bin/rails generate model Review proposal:references admin_user:references score:integer recommendation:string comments:text submitted_at:datetime

bin/rails generate model FeatureFlag key:string name:string enabled:boolean rollout_strategy:string rollout_percentage:integer targeting_rules:jsonb expires_at:datetime

bin/rails generate model AuditLog record:references{polymorphic} admin_user:references action:string changeset:jsonb occurred_at:datetime
```

## Notes

- Add `null: false`, foreign keys, database indexes, and default values in the
  generated migrations according to the desired demo behavior. In particular,
  make `Event#venue`, `Talk#event`, `TalkSpeaker`'s two references, and the
  registration references required if the sample data depends on them.
- `jsonb` requires PostgreSQL. Use `json` instead if the application will use
  another database adapter.
- Image and document fields—such as venue floor plans, event branding, and
  speaker headshots—are best added later with Active Storage attachments rather
  than columns generated here.
- Run `bin/rails db:migrate` after reviewing the generated migrations.
