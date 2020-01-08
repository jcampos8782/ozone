require 'ozone/version'
require 'active_support/time'

module Ozone
  class TimeBuilder
    # Valid formats:
    # YYYY/MM/DD 00:00,YYYY/MM/DDT00:00, YYYY-MM-DD 00:00, YYYY-MM-DDT00:00
    DATETIME_FORMAT = %r[(\d{4}[/-]\d{2}[/-]\d{2})[ T](\d{2}:\d{2})]

    def from_string(time_str)
      @time_str = time_str
      self
    end

    def with_offset(offset)
      @offset = offset
      self
    end

    def with_dst(observes_dst)
      @observes_dst = observes_dst
      self
    end

    def build
      fail StandardError, 'from_string() must be supplied a non-nil datetime string' unless @time_str.is_a?(String)
      fail StandardError, 'from_string() argument should match YYYY/MM/DD HH:MM' unless DATETIME_FORMAT.match(@time_str)
      fail StandardError, 'with_offset() must be supplied a number' unless @offset.is_a?(Numeric)
      fail StandardError, 'with_dst() must be supplied a boolean' if @observes_dst.nil?
      calculate_utc_time
    end

    private

    PST = ActiveSupport::TimeZone['Pacific Time (US & Canada)']

    def calculate_utc_time
      date = DATETIME_FORMAT.match(@time_str)[1]
      time = DATETIME_FORMAT.match(@time_str)[2]

      # Build UTC time and add/subtract minutes to avoid timezone assumptions and automatic conversions
      # Apply offsets manually based on @offset and whether or not DST is in effect in a zone known to observe
      # DST during the specified date/time
      utc = ::Time.parse("#{date}T#{time}+0000").utc

      if during_dst(date, time) && @observes_dst
        utc -= 60.minutes
      end

      if @offset > 0
        utc + @offset.minutes
      else
        utc - @offset.minutes
      end
    end

    def during_dst(date, time)
      pst_time = format '%sT%s-0800', date, time
      during_dst_pst = ::Time.parse(pst_time).in_time_zone(PST).dst?

      pdt_time = format '%%sT%s-0700', date, time
      during_dst_pdt = ::Time.parse(pdt_time).in_time_zone(PST).dst?

      # If during_dst_pdt is false and during_dst_pst is true, the time does not exist (hour skipped).
      if !during_dst_pdt && during_dst_pst
        fail StandardError 'The time specified occurs during a daylight savings time change and does not exist.'
      end

      # Both are true:
      #   The time is during DST (during_dst_pdt is true)
      # Both are false:
      #   The time is not during DST (during_dst_pdt is false)
      # during_dst_pdt is true, during_dst_pst if false:
      #   The time exists twice as it occurs during a shift back to standard time. In that case, assuming the earlier
      #   point in time (the one during DST) is acceptable.
      # Therefore, it is safe to return only the value of during_dst_pdt
      during_dst_pdt
    end
  end
end
