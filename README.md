# ozone
Convert time based on offset, with or without dst
=======
# Ozone

Given an offset (in minutes) and a boolean whether to observe daylight savings, convert a ruby time to a string representation, adjusted by offset, and either abiding by or ignoring daylight savings.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ozone'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ozone

## Usage

Ozone has just one method -- call -- which takes a time, offset (from utc, in minutes), whether to use daylight savings, and a [time format](http://ruby-doc.org/core-2.2.0/Time.html#method-i-strftime). Default format is YYYY-MM-DD HH:MM.

```ruby
> Ozone.call(time: t, offset: -480, observes_dst: true)
=> "2014/07/17 17:30"

> Ozone.call(time: t, offset: -480, observes_dst: false)
=> "2014/07/17 16:30"
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/[my-github-username]/ozone/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
