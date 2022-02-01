## Dependencies

* Ruby 3.1.0

## Apps info
 * Rails app runs in port 3000 (using this default config)

## Local Development
## Docker install

1. Install dependencies
```
https://www.docker.com/products/docker-desktop
```

2. Clone repository
3. cd into repository folder

4. Create env files for rails and react (replace variables with credentials and server variables)
```
cp .env.example .env
```

5. Run
```
docker-compose up
```

6. Rails debug
```
docker exec -it $( docker ps | grep ruby-okr-api | awk "{print \$1}" | head -n 1 ) rails c
```

## Full install

1. Install dependencies
```
brew install node
\curl -sSL https://get.rvm.io | bash
rvm install "ruby-3.1.0"
rvm use 3.1.0
brew install postgresql
```

2. Clone repository
3. cd into repository folder

4. Run in command line next:

```
gem install bundler && bundle config jobs 7
```

5. Create env files for rails and react (replace variables with credentials and server variables)
```
cp .env.example .env
```

6. Replace file with credentials of local postgres db(in development section)
```
database.yml
```

7. Run in command line next:
```
bundle install
```

8. Setup db:
```
rails db:create
rails db:migrate
```

9. run backend (on aterminal window)
```
rails server --binding 0.0.0.0 --port 4567
```

10. run sidekiq (on aterminal window)
```
bundle exec sidekiq
``` 
## Request example

Before run:
```
brew install jq
```

then:

token=$(curl -d '{"username":"marco", "password":"password"}'  -H "Content-Type: application/json" -X POST http://localhost:3000/authenticate | jq --raw-output '.auth_token')


curl --location --request GET 'http://localhost:3000/goals?page=1' \
--header "Authorization: $token" \
--header "Content-Type: application/json"