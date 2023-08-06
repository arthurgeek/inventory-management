# Inventory Management

## Dependencies

- Ruby (tested with version 3.2.2)
- Node.js (tested with version 20)

## Setup

### App setup

The command below will install all needed dependencies for the backend application and setup the database.

```sh
bin/rails setup
```

After that, you'll need to setup the frontend dependencies. Just run:

```sh
yarn
```

And, lastly, you need to seed some data to the database. Run:

```sh
bin/rails db:seed
```

### Configure the Location name

Finally, before starting the server, change the file under `config/application.rb` and look for `config.x.location.name`. In there, you'll set the name of your location.

### Start the server

And, finally, start the server:

```sh
bin/dev
```

## Developing the application

### Run unit tests

This uses tests from both minitest and rspec. To run them:

Minitest:

```sh
bin/rails test
```

RSpec:

```sh
bin/bundle exec rspec
```

### Run E2E tests

This app uses Cypress for E2E tests.

There are 2 ways to execute Cypress's tests.

#### Headless

This will run the tests in a headless browser and show the results in the terminal.

```sh
RAILS_ENV='cypress' rake cypress:run
```

#### Iterative

This will open the Cypress application, which will use a real browser to run your tests in an interactive, easy to inspect test runner, with real browser visualization.

```sh
RAILS_ENV='cypress' rake cypress:open
```
