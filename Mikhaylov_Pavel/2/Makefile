run:
	bin/checker test.csv

wo_sub:
	bin/checker --no-subdomains test.csv

wo_os:
	bin/checker --exclude-solutions test.csv

filter:
	bin/checker test.csv --filter=$(word)

full:
	bin/checker test.csv --exclude-solutions --no-subdomains --filter=$(word)
