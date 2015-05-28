require 'spec_helper'

describe Ozone do
  it 'has a version number' do
    expect(Ozone::VERSION).not_to be nil
  end

  context 'given offset and observes daylight savings boolean' do
    context 'time is not during daylight savings' do
      it 'converts a utc time to time with time zone and makes no dst adustment' do
        time_without_dst = Time.parse("2014-12-20 00:30:00 UTC")
        adjusted_time = Ozone.call(
          time: time_without_dst,
          offset: -480,
          observes_dst: true,
        )
        expect(adjusted_time.to_s).to eq("2014-12-19 16:30:00 -0800")
      end

      it 'converts a utc time to time with time zone and makes no dst adjustment' do
        time_without_dst = Time.parse("2014-12-20 00:30:00 UTC")
        adjusted_time = Ozone.call(
          time: time_without_dst,
          offset: -480,
          observes_dst: false,
        )
        expect(adjusted_time.to_s).to eq("2014-12-19 16:30:00 -0800")
      end
    end

    context 'time is during daylight savings' do
      it 'converts a utc time to time with time zone and makes no dst adustment' do
        time_dst = Time.parse("2014-07-20 00:30:00 UTC")
        adjusted_time = Ozone.call(
          time: time_dst,
          offset: -480,
          observes_dst: true,
        )
        expect(adjusted_time.to_s).to eq("2014-07-19 17:30:00 -0700")
      end

      it 'converts a utc time to time with time zone and moves clocks back an hour' do
        time_dst = Time.parse("2014-07-20 00:30:00 UTC")
        adjusted_time = Ozone.call(
          time: time_dst,
          offset: -480,
          observes_dst: false,
        )
        expect(adjusted_time.to_s).to eq("2014-07-19 16:30:00 -0700")
      end
    end
  end
end
