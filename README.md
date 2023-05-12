# README

## Tech Stack
* [Ruby](https://www.ruby-lang.org/en/documentation/)
> Language
> version: ruby 3.0.6p216

* [Ruby on Rails](https://rubyonrails.org/)
> Framework
> version: 7.0.4.3

* [Postgres](https://www.postgresql.org/docs/)
> Database
> version: latest

* [Rspec](https://github.com/rspec/rspec-rails)
> Testing framework

* [Rswag](https://github.com/rswag/rswag)
> API documentation

* [Bcrypt](https://github.com/bcrypt-ruby/bcrypt-ruby) and [JWT](https://github.com/bcrypt-ruby/bcrypt-ruby)
> Authentication

* [Pundit](https://github.com/varvet/pundit)
> Authorization

* [Kaminari](https://github.com/kaminari/kaminari)
> Pagination

* [Docker](https://docs.docker.com/)
> Container

## How to run the application?
```
docker compose build
docker compose up
```

## How to setup database?
> Go inside the container and run db migrate
```
docker exec -it sleep-routine-api bash
rake db:create
rake db:migrate
```

## How to run the test suite
```
rspec spec
```

## How to generate documentation?
```
RAILS_ENV=test rails rswag
```
