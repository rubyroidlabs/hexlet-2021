run:
	bin/checker test.csv

nosub:
	bin/checker --no-subdomains test.csv

filter:
	bin/checker --filter=uczestników test.csv

parallel:
	bin/checker --parallel=5 test.csv

solutions:
	bin/checker --exclude-solutions test.csv

parallel-all:
	bin/checker --parallel=10 --no-subdomains --exclude-solutions rails.csv

all:
	make run && printf '\n' && make parallel && printf '\n' && make nosub && printf '\n' && make filter && printf '\n' && make solutions