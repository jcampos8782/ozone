require 'spec_helper'

module Ozone
  describe Formatter do
    context 'given offset and observes daylight savings boolean' do
      context 'time is not during daylight savings' do
        it 'converts a utc time to time with time zone and makes no dst adustment' do
          time_without_dst = ::Time.parse("2014-03-09 09:59:00 UTC")
          adjusted_time = Formatter.call(
            time: time_without_dst,
            offset: -480,
            observes_dst: true,
          )
          expect(adjusted_time).to eq("2014-03-09 01:59")
        end

        it 'converts a utc time to time with time zone and makes no dst adjustment' do
          time_without_dst = ::Time.parse("2014-03-09 09:59:00 UTC")
          adjusted_time = Formatter.call(
            time: time_without_dst,
            offset: -480,
            observes_dst: false,
          )
          expect(adjusted_time).to eq("2014-03-09 01:59")
        end
      end

      context 'time is during daylight savings' do
        it 'converts a utc time to time with time zone and makes no dst adustment' do
          time_dst = ::Time.parse("2014-03-09 10:00:00 UTC")
          adjusted_time = Formatter.call(
            time: time_dst,
            offset: -480,
            observes_dst: true,
          )
          expect(adjusted_time).to eq("2014-03-09 03:00")
        end

        it 'converts a utc time to time with time zone and moves clocks back an hour' do
          time_dst = ::Time.parse("2014-03-09 10:00:00 UTC")
          adjusted_time = Formatter.call(
            time: time_dst,
            offset: -480,
            observes_dst: false,
          )
          expect(adjusted_time).to eq("2014-03-09 02:00")
        end
      end
    end
  end

      end

      end
    end

      end

      end
    end
  end
end
