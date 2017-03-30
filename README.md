# Ranges

Gem for handling ranges of nodes which have a label and an index. It stores ranges in a space-efficient manner.

A range looks like: `a/1, a/2, a/3, a/10, b/2, b/4`.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ranges'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ranges

## Usage

```ruby
require 'ranges'

first = parse('a/1, a/2, a/3, a/4, a/128, a/129, b/65, b/66, c/1, c/10, c/42')
second = parse('a/1, a/2, a/3, a/4, a/5, a/126, a/127, b/100, c/2, c/3, d/1')
actual = first.merge(second)

puts write(actual)
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. 

Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. 

To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/ranges. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

