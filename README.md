# ozone
Convert time based on offset, with or without dst
=======
# Ozone

Given a ruby time, an offset (in minutes), and a boolean whether to observe daylight savings, Ozone provides two things:

1) Convert a ruby time to a string representation, adjusted by offset, and either abiding by or ignoring daylight savings.
2) Compare with a ruby time to see whether before or after, either abiding by or ignoring daylight savings.

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

An instance of Ozone::Time can be compared with a ruby time.

When observes_dst is true, Ozone::Time has the same value as ruby Time when making comparisons.

```ruby
dst_time = Time.parse("2014-03-09 10:00:00 UTC")
ozone_time = Ozone::Time.new(
  time: dst_time,
  offset: -480,
  observes_dst: true,
)

> ozone_time.before?(1.second.since(dst_time))
=> true
> ozone_time.before?(1.second.until(dst_time))
=> false
```

However, when observes_dst is false:

```ruby
ozone_time = Time.new(
  time: dst_time,
  offset: -480,
  observes_dst: false,
)

> ozone_time.before?(1.second.since(dst_time)
=> true
> ozone_time.before?(1.second.until(dst_time)
=> true
```

This is because during daylight savings, times will be adjusted backwards 1 hour if daylight savings
is not being observed.

Ozone::Formatter has one method -- call -- which takes a time, offset (from utc, in minutes), whether to use daylight savings, and a [time format](http://ruby-doc.org/core-2.2.0/Time.html#method-i-strftime). Default format is YYYY-MM-DD HH:MM.

```ruby
> Ozone::Formatter.call(time: t, offset: -480, observes_dst: true)
=> "2014/07/17 17:30"

> Ozone::Formatter.call(time: t, offset: -480, observes_dst: false)
=> "2014/07/17 16:30"
```

This functionality can also be accessed via the Ozone::Time#strftime method.

### NOTE: Since all operations are executing in UTC time, the time zone in the format string will *always* be UTC

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/[my-github-username]/ozone/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
