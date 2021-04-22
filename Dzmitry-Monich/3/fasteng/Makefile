install:
	bundle install

run:
	bin/bot

test:
	bundle exec rspec

tasks:
	bundle exec rake --tasks

db-migrate:
	bundle exec rake db:migrate

db-create:
	bundle exec rake db:new_migration name=$(N)

.PHONY: test
