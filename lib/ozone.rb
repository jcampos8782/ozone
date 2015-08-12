require 'ozone/version'

require 'active_support/time'

module Ozone
  module Formatter
    module_function

    def call(time:, offset:, observes_dst: true, format: '%Y-%m-%d %H:%M')
      ::Ozone::Time.new(time: time, offset: offset, observes_dst: observes_dst).strftime(format: format)
    end
  end

  class Time
    def initialize(time:, offset:, observes_dst: true)
      @offset = offset
      @observes_dst = observes_dst
      @time = time
    end

    def <=>(time_with_zone)
      adjusted_time <=> to_ozone_time(time_with_zone).adjusted_time
    end

    def before?(time_with_zone)
      adjusted_time < to_ozone_time(time_with_zone).adjusted_time
    end

    def after?(time_with_zone)
      adjusted_time > to_ozone_time(time_with_zone).adjusted_time
    end

    def strftime(format: '%Y-%m-%d %H:%M')
      adjusted_time.strftime(format)
    end

    alias_method :<, :before?
    alias_method :>, :after?
    alias_method :to_s, :strftime

    protected

    def adjusted_time
      offset = @offset

      # Apply the DST offset if the practice observes DST and if DST is currently in effect in a timezone known to
      # observe DST.
      offset += 60 if @observes_dst && @time.in_time_zone(PST).dst?

      if offset > 0
        offset.minutes.until(@time)
      elsif offset < 0
        offset.minutes.since(@time)
      else
        @time
      end
    end

    private

    PST = ActiveSupport::TimeZone['Pacific Time (US & Canada)']

    def to_ozone_time(time)
      Ozone::Time.new(time: time.utc, offset: @offset, observes_dst: @observes_dst)
    end
  end
end
