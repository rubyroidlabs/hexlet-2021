# Checker

## Описание

Консольная утилита, которая на вход получает CSV список из URL и проверяет какие из приложений еще живы и 
отвечают на HTTP запросы.

## Запуск 

Для корректной работы программы на вашем компьютере должен быть установлен [Ruby MRI](https://www.ruby-lang.org/en/).
Запуск осуществляется командой:
```
$ ./checker.rb rails.csv
```
Тестирование программы
```
$ rspec
```

## Параметры

- Параметр `--no-subdomains` - игнорирует все доменные имена второго и более уровней и проверяет только домены 
  первого уровня:

```bash
./checker.rb --no-subdomains rails.csv

circlecityvbc.com - 200 (314ms)
ralphonrails.com - 200 (412ms)
expreso44a.co - ERROR (getaddrinfo: nodename nor servname provided, or not known)

Total: 3, Success: 2, Failed: 0, Errored: 1
```

- Параметр `--filter=sales`, ищет определенное слово в содержании страниц и выводит их только в случае 
  нахождения этого слова на странице:

```bash
./checker.rb --filter=payment rails.csv

circlecityvbc.com - 200 (314ms)

Total: 1, Success: 1, Failed: 0, Errored: 0
```

- Параметр `--exclude-solutions`, игнорирует все приложения, которые скорее всего являются различными 
  open source решениями:

```bash
./checker.rb --exclude-solutions rails.csv

circlecityvbc.com - 200 (314ms)
git.mnt.ee - 404 (89ms)
ralphonrails.com - 200 (412ms)
expreso44a.co - ERROR (getaddrinfo: nodename nor servname provided, or not known)

Total: 4, Success: 2, Failed: 1, Errored: 1
```