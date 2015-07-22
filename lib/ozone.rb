require "ozone/version"

require 'active_support/time'

module Ozone
  module Formatter
    module_function

    def call(time:, offset:, observes_dst: true, format: '%Y-%m-%d %H:%M')
      timezone = ActiveSupport::TimeZone[offset/60]
      time_with_zone = time.in_time_zone(timezone)
      if time_with_zone.dst? && !observes_dst
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

    def before?(time_with_zone)
      adjusted_time < time_with_zone
    end

    def after?(time_with_zone)
      !before?(time_with_zone)
    end

    def strftime(format: '%Y-%m-%d %H:%M')
      Formatter.call(time: @time, offset: @offset, observes_dst: @observes_dst, format: format)
    end

    private

    def adjusted_time
      time_with_zone = @time.in_time_zone(@timezone)
      time_with_zone.dst? && !@observes_dst ?
        1.hour.until(time_with_zone) :
        time_with_zone
    end
  end
end
