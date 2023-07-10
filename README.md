# PGSpecHelper


[![Gem Version](https://badge.fury.io/rb/pg_spec_helper.svg)](https://badge.fury.io/rb/pg_spec_helper)
[![Specs](https://github.com/craigulliott/pg_spec_helper/actions/workflows/specs.yml/badge.svg)](https://github.com/craigulliott/pg_spec_helper/actions/workflows/specs.yml)
[![Types](https://github.com/craigulliott/pg_spec_helper/actions/workflows/types.yml/badge.svg)](https://github.com/craigulliott/pg_spec_helper/actions/workflows/types.yml)
[![Coding Style](https://github.com/craigulliott/pg_spec_helper/actions/workflows/linter.yml/badge.svg)](https://github.com/craigulliott/pg_spec_helper/actions/workflows/linter.yml)


### What this gem is

A helper class for setting up and easily tearing down PostgreSQL database **structure** within a testing environment.

If you are building something which depends on specific database structure, and that structure changes depending on specific tests within your test suite, then this gem is for you.

For example, [platformer](https://www.github.com/craigulliott/platformer) and [dynamic_migrations](https://www.github.com/craigulliott/dynamic_migrations) are two packages which make use of this gem.


### What this gem is not

This gem is concerned with the **structure** of your database, not the data/records within your database. If you are looking for a gem which can add data/records to your database within your test suite, then check out [factory_bot](https://github.com/thoughtbot/factory_bot). If you are looking for a tool to reset the state of your database (clear records) after your test suite has completed, then check out [database_cleaner](https://github.com/DatabaseCleaner/database_cleaner).


## Key Features

* Easily create basic tables, columns, constraints, indexes and primary/foreign keys for your specs
* Provides convenient methods for testing the presence of various database objects
* Resets your database after each spec, but only if the spec made changes
* Ignores `information_schema` and any schemas or tables with names beginning with `pg_`
* Configurable to ignore other schemas (such as `postgis`)
* Automatically resets and recreates the `public` schema
* Can track and refresh materialized views
* Easily access the `PG::Connection` object via `pg_spec_helper.connection` to execute your own SQL

## Installation

Add the gem to your Gemfile:

```ruby
  gem "pg_spec_helper"
```

Or to your `*.gemspec`

```ruby
  spec.add_development_dependency "pg_spec_helper"
```

And run bundle install

    $ bundle install

Create your new platform:

    $ pg_spec_helper create my_platform_name

Note, this gem depends on the postgres gem `pg`, which depends on the `libpq` package. On Apple Silicon you can run the following commands before installation to prepare your system.

```
# required for pg gem on apple silicon
brew install libpq
export PATH="/opt/homebrew/opt/libpq/bin:$PATH"
```

## Getting Started

#### Setting up rspec

Install PG Spec Helper into your `spec/spec_helper.rb`

```ruby
require "pg_spec_helper"

RSpec.configure do |config|

  # make pg_spec_helper conveniently accessable within your test suite
  config.add_setting :pg_spec_helper
  config.pg_spec_helper = PGSpecHelper.new(database: :my_database, host: :localhost, port: 5432, username: 'username', password: '**********')

  # optionally add additional schemas which should be ignored
  config.pg_spec_helper.ignore_schema :postgis
  config.pg_spec_helper.ignore_schema :some_other_schema

  # If your package uses materialized views which need to be
  # refreshed after structural changes have occured to your database,
  # then you can track them and refresh them automatically
  #
  # here, the materialized view `my_materialized_view` will be refreshed
  # automatically after any calls to create_schema, or create_table
  config.pg_spec_helper.track_materialized_view :public, :my_materialized_view, [
    :create_schema,
    :create_table
  ]

  # assert that your test suite is empty before running the test suite
  config.before(:suite) do
    # optionally provide DYNAMIC_MIGRATIONS_CLEAR_DB_ON_STARTUP=true to
    # force reset your database structure
    if ENV["DYNAMIC_MIGRATIONS_CLEAR_DB_ON_STARTUP"]
      config.pg_spec_helper.reset! true
    else
      # raise an error unless your database structure is empty
      config.pg_spec_helper.assert_database_empty!
    end
  end

  # reset your database structure after each test (this deletes all
  # schemas and tables and then recreates the `public` schema)
  config.after(:each) do
    config.pg_spec_helper.reset!
  end
end

```

The configuration above will assert that your database is completely empty before the test suite runs. If your database is not empty, then an error will be raised.

If rspec crashed or exited prematurely on the last execution of your test suite, then you can tell pg_spec_helper to forcefully clear your database.

    $ DYNAMIC_MIGRATIONS_CLEAR_DB_ON_STARTUP=true bundle exec rspec

#### An example test which requires some specific structure

```ruby
RSpec.describe PGSpecHelper do
  let(:pg_spec_helper) { RSpec.configuration.pg_spec_helper }

  describe 'where the table my_schema.my_table exists and has a single column which is also the primary key' do
    before(:each) do
      pg_spec_helper.create_schema :my_schema
      pg_spec_helper.create_table :my_schema, :my_table
      pg_spec_helper.create_column :my_schema, :my_table, :my_column, :integer
      pg_spec_helper.create_primary_key :my_schema, :my_schema, :my_table, [:my_column]
    end

    it "test something which required that table to exist" do
      expect{}.to_not raise_error
    end
  end
end
```


See https://github.com/craigulliott/pg_spec_helper/tree/main/lib/pg_spec_helper for all the methods which are available on this class.


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

We use [Conventional Commit Messages](https://gist.github.com/qoomon/5dfcdf8eec66a051ecd85625518cfd13).

Code should be linted and formatted according to [Ruby Standard](https://github.com/standardrb/standard).

Publishing is automated via github actions and Googles [Release Please](https://github.com/google-github-actions/release-please-action) github action

We prefer using squash-merges when merging pull requests because it helps keep a linear git history and allows more fine grained control of commit messages which get sent to release-please and ultimately show up in the changelog.

Type checking is enabled for this project. You can find the corresponding `rbs` files in the sig folder.

Install types for the packages used in development (such as `rspec`) by running

    $ rbs collection install

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/craigulliott/pg_spec_helper. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/craigulliott/pg_spec_helper/blob/master/CODE_OF_CONDUCT.md).

## License

This software is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the PGSpecHelper project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/craigulliott/pg_spec_helper/blob/master/CODE_OF_CONDUCT.md).
