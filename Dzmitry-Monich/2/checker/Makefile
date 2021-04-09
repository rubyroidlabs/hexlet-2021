install:
	bundle install

run:
	bin/checker data/rails.csv

run-f:
	bin/checker --no-subdomains --exclude-solutions data/rails.csv

run-all:
	bin/checker --no-subdomains --exclude-solutions --filter=available data/rails.csv

test:
	bundle exec rspec

.PHONY: test
