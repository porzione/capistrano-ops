# capistrano-ops

Capistrano plugin to run some tasks on deploy servers: tail Rails logs, check user systemd services, execute remote shell commands and so on.

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

## Development

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `capistrano-ops.gemspec`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/porzione/capistrano-ops

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
