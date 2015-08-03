require "ozone/version"

require 'active_support/time'

module Ozone
  module Formatter
    module_function

    def call(time:, offset:, observes_dst: true, format: '%Y-%m-%d %H:%M')
      timezone = ActiveSupport::TimeZone[offset/60]
      time_with_zone = time.in_time_zone(timezone)
      if time_with_zone.dst? && !observes_dst
        # If we're during daylight savings time, but
        # we are not observing daylight savings,
        # there is a one-hour window where there is not
        # an equivalent time between standard and daylight
        # savings times. In order to deal with this,
        # we subtract two hours from the offset and then
        # take 2 hours from the given time. This frees
        # us to string format the time without ruby
        # making adjustments internally.
        offset -= 120
        timezone = ActiveSupport::TimeZone[offset/60]
        2.hours.since(time.in_time_zone(timezone)).strftime(format)
      else
        time_with_zone.strftime(format)
      end
    end
  end

  class Time
    def initialize(time:, offset:, observes_dst: true)
      @offset = offset
      @timezone = ActiveSupport::TimeZone[offset/60]
      @observes_dst = observes_dst
      @time = time
    end

    def <=> (time_with_zone)
      if after?(time_with_zone)
        1
      elsif before?(time_with_zone)
        -1
      else
        0
      end
    end

    def before?(time_with_zone)
      adjusted_time < time_with_zone
    end

    def after?(time_with_zone)
      adjusted_time > time_with_zone
    end

    def strftime(format: '%Y-%m-%d %H:%M')
      Formatter.call(time: @time, offset: @offset, observes_dst: @observes_dst, format: format)
    end

    alias_method :<, :before?
    alias_method :>, :after?
    alias_method :to_s, :strftime

    private

    def adjusted_time
      time_with_zone = @time.in_time_zone(@timezone)
      time_with_zone.dst? && !@observes_dst ?
        1.hour.until(time_with_zone) :
        time_with_zone
    end
  end
end
