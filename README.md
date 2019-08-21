# README

# How to run
## Localhost
1) ```cp env/localhost.env env/vars.env``` 

## Production

### Deploying new version
1) change to correct dorm folder
2) ```git pull```
3) ```docker-compose restart```


## Stress tests
For strest testing we use [Locust](https://docs.locust.io/en/latest/what-is-locust.html). All needed files are located in `stress-tests/*`




# Show all available tasks
```rake -T```

# Before release
in config/environments/production.rb:
config.action_mailer.default_url_options = { host: 'url', port: 80 }


This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
