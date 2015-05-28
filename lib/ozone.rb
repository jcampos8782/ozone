require "ozone/version"

require 'active_support/time'

module Ozone
  module_function

  def call(time:, offset:, observes_dst: true)
    timezone = ActiveSupport::TimeZone[offset/60]
    time_with_zone = time.in_time_zone(timezone)
    time_with_zone.dst? && !observes_dst ?
      1.hour.until(time_with_zone) :
      time_with_zone
  end
end
