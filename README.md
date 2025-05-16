# ipalert

ipalert is a small container that'll test your IP address using https://ipinfo.io/ip.
If it notices it has changed since its last run, it'll email you to alert of the modification.

## Getting Started

Prepare the secrets and edit the files accordingly

```sh
$ mkdir -p data
$ cp .env.example .env
```

Once the files have been edited, you can run the container

```sh
$ docker compose --remove-orphans --build ipalert
```

## Setting up a cron job

You could set up a cron job that would run the container hourly like so

```
0 * * * * cd ~/services/ipalert && docker-compose run --rm ipalert
```
