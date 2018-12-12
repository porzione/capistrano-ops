# capistrano-ops

Capistrano plugin to run some tasks on deploy servers: tail Rails logs, check user's systemd services, execute remote shell commands and so on.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'capistrano-ops', github: 'porzione/capistrano-ops'
```

And then execute:

    $ bundle

Or, in future, install it yourself as:

    $ gem install capistrano-ops

## Usage

Add this line to your Capfile:

```ruby
require 'capistrano/ops'
```

set your defaults in config/deploy.rb

```ruby
# default is ['production']
set :ops_log, ['puma.out', 'puma.err']
# default is 'puma.service'
set :ops_svc, 'puma-some-app.service'
# add env vars
set :ops_env_variables, { somevar: 'someval' }
```

Then check output of `bundle exec cap -T`, new command namespaces are `shell:*`, `systemd:*` and `transfer:*`.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/porzione/capistrano-ops

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
