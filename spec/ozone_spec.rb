require 'spec_helper'

module Ozone
  describe Formatter do
    context 'given offset and observes daylight savings boolean' do
      context 'time is not during daylight savings' do
        it 'converts a utc time to time with time zone and makes no dst adjustment' do
          time_without_dst = ::Time.parse('2014-03-09 09:59:00 UTC')
          adjusted_time = Formatter.call(
            time: time_without_dst,
            offset: -480,
            observes_dst: true,
          )
          expect(adjusted_time).to eq('2014-03-09 01:59')
        end

        it 'converts a utc time to time with time zone and makes no dst adjustment' do
          time_without_dst = ::Time.parse('2014-03-09 09:59:00 UTC')
          adjusted_time = Formatter.call(
            time: time_without_dst,
            offset: -480,
            observes_dst: false,
          )
          expect(adjusted_time).to eq('2014-03-09 01:59')
        end
      end

      context 'time is during daylight savings' do
        context 'and zone observes dst' do
          it 'converts a utc time to time with time zone and makes no dst adjustment' do
            time_dst = ::Time.parse('2014-03-09 10:00:00 UTC')
            adjusted_time = Formatter.call(
              time: time_dst,
              offset: -480,
              observes_dst: true,
            )
            expect(adjusted_time).to eq('2014-03-09 03:00')
          end

          it 'converts a utc time to time with time zone and moves clocks back an hour' do
            time_dst = ::Time.parse('2014-03-09 10:00:00 UTC')
            adjusted_time = Formatter.call(
              time: time_dst,
              offset: -480,
              observes_dst: false,
            )
            expect(adjusted_time).to eq('2014-03-09 02:00')
          end
        end

        context 'and zone does not observe dst' do
          it 'converts a utc time to time with time zone and makes no dst adjustment' do
            time_dst = ::Time.parse('2014-03-09 10:00:00 UTC')
            adjusted_time = Formatter.call(
              time: time_dst,
              offset: -360,
              observes_dst: true,
            )
            expect(adjusted_time).to eq('2014-03-09 05:00')
          end

          it 'converts a utc time to time with time zone and moves clocks back an hour' do
            time_dst = ::Time.parse('2014-03-09 10:00:00 UTC')
            adjusted_time = Formatter.call(
              time: time_dst,
              offset: -360,
              observes_dst: false,
            )
            expect(adjusted_time).to eq('2014-03-09 04:00')
          end
        end
      end
    end
  end

  describe Time do
    describe '#strftime' do
      context 'time is not during daylight savings' do
        let(:time_without_dst) { ::Time.parse('2014-03-09 09:59:00 UTC') }

        it 'converts a utc time to time with time zone and makes no dst adjustment' do
          adjusted_time = Time.new(
            time: time_without_dst,
            offset: -480,
            observes_dst: true,
          )
          expect(adjusted_time.strftime).to eq('2014-03-09 01:59')
        end

        it 'converts a utc time to time with time zone and makes no dst adjustment' do
          adjusted_time = Time.new(
            time: time_without_dst,
            offset: -480,
            observes_dst: true,
          )
          expect(adjusted_time.strftime).to eq('2014-03-09 01:59')
        end
      end

      context 'time is during daylight savings' do
        let(:time_with_dst) { ::Time.parse('2014-03-09 10:00:00 UTC') }

        it 'converts a utc time to time with time zone and makes no dst adjustment' do
          adjusted_time = Time.new(
            time: time_with_dst,
            offset: -480,
            observes_dst: true,
          )
          expect(adjusted_time.strftime).to eq('2014-03-09 03:00')
        end

        it 'converts a utc time to time with time zone and moves clocks back an hour' do
          adjusted_time = Time.new(
            time: time_with_dst,
            offset: -480,
            observes_dst: false,
          )
          expect(adjusted_time.strftime).to eq('2014-03-09 02:00')
        end
      end
    end

    describe '#before' do
      context 'time outside daylight savings' do
        let(:time_without_dst) { ::Time.parse('2014-03-09 09:59:00 UTC') }

        it 'returns true o time with time zone and makes no dst adjustment' do
          ozone_time = Time.new(
            time: time_without_dst,
            offset: -480,
            observes_dst: true,
          )

          expect(ozone_time < (1.second.since(time_without_dst))).to be_truthy
          expect(ozone_time > (1.second.since(time_without_dst))).to be_falsey
          expect(ozone_time < (1.second.until(time_without_dst))).to be_falsey
        end

        it 'converts a utc time to time with time zone and makes no dst adjustment' do
          ozone_time = Time.new(
            time: time_without_dst,
            offset: -480,
            observes_dst: false,
          )
          expect(ozone_time < (1.second.since(time_without_dst))).to be_truthy
          expect(ozone_time > (1.second.since(time_without_dst))).to be_falsey
          expect(ozone_time < (1.second.until(time_without_dst))).to be_falsey
        end
      end

      context 'time is during daylight savings' do
        let(:time_with_dst) { ::Time.parse('2014-03-09 10:00:00 UTC') }

        it 'converts a utc time to time with time zone and makes no dst adjustment' do
          ozone_time = Time.new(
            time: time_with_dst,
            offset: -480,
            observes_dst: true,
          )
          expect(ozone_time < (1.second.since(time_with_dst))).to be_truthy
          expect(ozone_time < (1.second.until(time_with_dst))).to be_falsey
        end

        it 'converts a utc time to time with time zone and moves clocks back an hour' do
          ozone_time = Time.new(
            time: time_with_dst,
            offset: -480,
            observes_dst: false,
          )

          expect(ozone_time < (1.second.since(time_with_dst))).to be_truthy
          expect(ozone_time > (1.second.until(time_with_dst))).to be_truthy
        end
      end
    end

    describe '#<=>' do
      context 'time outside daylight savings' do
        let(:time_without_dst) { ::Time.parse('2014-03-09 09:59:00 UTC') }

        it 'compares true o time with time zone and makes no dst adjustment' do
          ozone_time = Time.new(
            time: time_without_dst,
            offset: -480,
            observes_dst: true,
          )
          expect(ozone_time <=> (1.second.since(time_without_dst))).to eq (-1)
          expect(ozone_time <=> (1.second.until(time_without_dst))).to eq 1
          expect(ozone_time <=> time_without_dst).to eq 0
        end

        it 'converts a utc time to time with time zone and makes no dst adjustment' do
          ozone_time = Time.new(
            time: time_without_dst,
            offset: -480,
            observes_dst: false,
          )
          expect(ozone_time <=> (1.second.until(time_without_dst))).to eq 1
          expect(ozone_time <=> (1.second.since(time_without_dst))).to eq (-1)
          expect(ozone_time <=> time_without_dst).to eq 0
        end
      end

      context 'time is during daylight savings' do
        let(:time_with_dst) { ::Time.parse('2014-03-09 10:00:00 UTC') }

        it 'converts a utc time to time with time zone and makes no dst adjustment' do
          ozone_time = Time.new(
            time: time_with_dst,
            offset: -480,
            observes_dst: true,
          )
          expect(ozone_time <=> (1.second.until(time_with_dst))).to eq 1
          expect(ozone_time <=> (1.second.since(time_with_dst))).to eq (-1)
          expect(ozone_time <=> time_with_dst).to eq 0
        end

        it 'converts a utc time to time with time zone and moves clocks back an hour' do
          ozone_time = Time.new(
            time: time_with_dst,
            offset: -480,
            observes_dst: false,
          )

          expect(ozone_time <=> 1.second.until(time_with_dst)).to eq 1
          expect(ozone_time <=> 1.second.since(time_with_dst)).to eq (-1)
          expect(ozone_time <=> time_with_dst).to eq 0
        end
      end
    end
  end
end
