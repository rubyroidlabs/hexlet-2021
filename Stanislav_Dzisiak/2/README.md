# UrlAnalyzer

## Setup

```sh
git clone ...

gem build

gem install url_analyzer-0.1.0.gem
```

## Usage

```sh
checker spec/fixtures/example.csv --parallel=5 --no-subdomains
http://google.com - 301 (165ms)
http://github.com - 301 (145ms)
http://gitlab.com - 301 (113ms)
http://linux.org - 301 (383ms)
http://digitalocean.com - 301 (138ms)
http://natedobbins.net - 404 (242ms)
http://websitesetup.org - 301 (75ms)
http://wrongdomainname.com - ERROR: Failed to open TCP connection to wrongdomainname.com:80 (getaddrinfo: Name or service not known)
http://anotherwrong.net - ERROR: Failed to open TCP connection to anotherwrong.net:80 (getaddrinfo: Name or service not known)
http://memory.de - 301 (270ms)
http://blabla.nl - 301 (186ms)
http://rubygems.org - 301 (286ms)
http://yahoo.com - 301 (285ms)
http://abelitsia.gr - 200 (254ms)
http://9luxureestates.com - 200 (1382ms)
http://5edmscreen.com - ERROR: Connection reset by peer
http://2youyou2.com - 200 (541ms)
---------------------------------------------
Total: 17, Success: 13, Failed: 1, Errored: 3
```

## Show help

```sh
checker --help
Utility for analyzing urls.
usage: checker <path_to_csv> [options]

options:
    --no-subdomains      check only first level domains
    --exclude-solutions  ignore open source projects
    --filter             find pages containing a word (example: --filter=word)
    --parallel           check urls in N streams (example: --parallel=N)

other options:
    -v, --version        
    -h, --help
```

[![asciicast](https://asciinema.org/a/geMCtpKb4uHnHmX5vU1YYS6bn.svg)](https://asciinema.org/a/geMCtpKb4uHnHmX5vU1YYS6bn)
