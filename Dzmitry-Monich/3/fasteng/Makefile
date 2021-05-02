install:
	bundle install

run:
	bin/bot

server:
	ruby lib/server.rb

test:
	bundle exec rspec

tasks:
	bundle exec rake --tasks

db-migrate:
	bundle exec rake db:migrate

db-create:
	bundle exec rake db:new_migration name=$(N)

# cron-setup:
# 	bundle exec whenever

cron-start:
	bundle exec whenever --update-crontab --set environment=development

cron-stop:
	bundle exec whenever --clear-crontab

.PHONY: test
