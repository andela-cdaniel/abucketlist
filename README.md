# A-Bucketlist [![Circle CI](https://circleci.com/gh/andela-cdaniel/abucketlist/tree/master.svg?style=svg)](https://circleci.com/gh/andela-cdaniel/abucketlist/tree/master) [![Coverage Status](https://coveralls.io/repos/andela-cdaniel/abucketlist/badge.svg?branch=master&service=github)](https://coveralls.io/github/andela-cdaniel/abucketlist?branch=master)

A simple API for bucket list operations.

## Getting Started

To run this application locally, you will need to either clone this repository or fork it. You can also download the entire repository as a zip package and run locally.

## Dependencies

This application runs on Rails which is a Ruby powered framework built to make developing web applications faster. If you intend to run this application locally, you must make sure you have the following installed:

* [Install Ruby](http://www.ruby-lang.org)
* [Install Rails](http://rubyonrails.org)

* [Install RubyGems](https://rubygems.org/pages/download)
* [Install Bundler](http://bundler.io/)

That should get you all set up for running locally. If you run into any issues installing any of the above, your safest bet is to google it as there is already a solution on-line.

Once you have a copy of this project and it's dependencies installed, you are good to go. run `bundle install` to install all the required external dependencies.

## Database Setup

Run the following command from the terminal:

```shell
$ rake db:create db:migrate
```

Create the database for the test environment as well:

```shell
$ rake db:create db:migrate RAILS_ENV=test
```

## Running the tests

Run the following command from the terminal to get all tests running

```shell
$ rspec spec
```

## Setting up the server

Run the following command to start the server

```shell
$ rails server
```

## API Documentation

The full documentation for the API and all available endpoints is explained [here](https://andela-cdaniel.github.io/slate)

## Contributing

1. Fork it: [Fork a-bucketlist on Github](https://github.com/andela-cdaniel/a-bucketlist/fork)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
