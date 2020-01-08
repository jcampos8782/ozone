# ozone
Time-to-String and String-to-Time operations which operate using time zone offsets (in minutes) and a boolean which indicates whether or not DST is observed.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ozone'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ozone

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/[my-github-username]/ozone/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request


# Ozone::Time

Given a ruby time (UTC), an offset (in minutes), and a boolean whether to observe daylight savings, Ozone::Time provides two things:

1) Convert a ruby time to a string representation, adjusted by offset, and either abiding by or ignoring daylight savings.
2) Compare with a ruby time to see whether before or after, either abiding by or ignoring daylight savings.


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

# Ozone::TimeBuilder

Given a datetime string, an offset (in minutes), and a boolean whether to observe daylight savings, Ozone::TimeBuilder builds a ruby time object (UTC). The TimeBuilder serves as an inverse to Ozone::Time which given a ruby time, can generate a string representation of that time.

## Usage

`TimeBuilder` accepts four String formats as input to the `from_string` method:
 - YYYY/MM/DD HH:MM
 - YYYY/MM/DDTHH:MM
 - YYYY-MM-DD HH:MM
 - YYY-MM-DDTHH:MM
 
```ruby
> builder = Ozone::TimeBuilder.new
#<Ozone::TimeBuilder:0x007fff4c6e9f30 @observes_dst=nil, @offset=nil, @time_str=nil>
> time = builder.from_string("2015-11-15 09:00").with_offset(-480).with_dst(false).build
=> 2015-11-15 08:00:00 UTC
```

# Ozone::Formatter

Takes a time, offset (from utc, in minutes), whether to use daylight savings, and a [time format](http://ruby-doc.org/core-2.2.0/Time.html#method-i-strftime). Default format is YYYY-MM-DD HH:MM.

## Usage
Since all operations are executing in UTC time, the time zone in the format string will *always* be UTC. 
This functionality can also be accessed via the Ozone::Time#strftime method.

```ruby
> Ozone::Formatter.call(time: t, offset: -480, observes_dst: true)
=> "2014/07/17 17:30"

> Ozone::Formatter.call(time: t, offset: -480, observes_dst: false)
=> "2014/07/17 16:30"
```


