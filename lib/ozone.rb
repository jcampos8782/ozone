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

    end
  end
end
