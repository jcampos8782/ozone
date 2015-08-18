require 'spec_helper'
require 'time_builder'
require 'rspec/core/shared_example_group'

module Ozone
  describe TimeBuilder do
    let(:builder) { ::Ozone::TimeBuilder.new }

    context '#build' do
      let(:from_string) { '2015-11-15 09:00' }
      let(:with_offset) { -480 } # Pacific offset - Known to observe DST
      let(:with_dst) { true }

      RSpec.shared_examples 'valid format' do
        it 'raises no error' do
          expect do
            builder.from_string(from_string).with_offset(with_offset).with_dst(with_dst).build
          end.to_not raise_error
        end
      end

      RSpec.shared_examples 'invalid format' do
        it 'raises an error' do
          expect do
            builder.from_string(from_string).with_offset(with_offset).with_dst(with_dst).build
          end.to raise_error StandardError
        end
      end

      RSpec.shared_examples 'an inverse to Ozone::Time' do
        it 'time == TimeBuilder.from_time(Ozone::Time.new(time).to_s).build' do
          ozone = ::Ozone::Time.new(time: ::Time.parse(from_string).utc, offset: with_offset, observes_dst: with_dst)
          time = builder.from_string(ozone.to_s).with_offset(with_offset).with_dst(with_dst).build
          expect(time).to eq ::Time.parse(from_string).utc
        end

        it 'time_str == Ozone::Time.new(TimeBuilder.from_time(time_str)).to_s' do
          time = builder.from_string(from_string).with_offset(with_offset).with_dst(with_dst).build
          ozone = ::Ozone::Time.new(time: time, offset: with_offset, observes_dst: with_dst)
          expect(ozone.to_s).to eq from_string
        end
      end

      context 'with invalid input' do
        context 'from_string(nil)' do
          let(:from_string) { nil }
          it_behaves_like 'invalid format'
        end

        context 'from_string(123)' do
          let(:from_string) { 123 }
          it_behaves_like 'invalid format'
        end

        context 'from_string("9:00AM 1/2/2015")' do
          let(:from_string) { '9:00AM 1/2/2015' }
          it_behaves_like 'invalid format'
        end

        context 'with_offset(nil)' do
          let(:with_offset) { nil }
          it_behaves_like 'invalid format'
        end

        context 'with_offset("wat")' do
          let(:with_offset) { 'wat' }
          it_behaves_like 'invalid format'
        end

        context 'with_dst(nil)' do
          let(:with_dst) { nil }
          it_behaves_like 'invalid format'
        end
      end

      context 'during a time which does not exist' do
        let(:from_string) { '2015/03/08 02:00' }
        it 'raises an error' do
          expect do
            builder.from_string(from_string).with_offset(with_offset).with_dst(with_dst).build
          end.to raise_error StandardError
        end
      end

      context 'with valid input' do
        before :each do
          @time = builder.from_string(from_string).with_offset(with_offset).with_dst(with_dst).build
        end

        context 'from_string("2015/11/15 09:00")' do
          let(:from_string) { '2015/11/15 09:00' }
          it_behaves_like 'valid format'
        end

        context 'from_string("2015-11-15 09:00")' do
          let(:from_string) { '2015-11-15 09:00' }
          it_behaves_like 'valid format'
        end

        context 'from_string("2015/11/15T09:00")' do
          let(:from_string) { '2015/11/15T09:00' }
          it_behaves_like 'valid format'
        end

        context 'from_string("2015-11-15T09:00")' do
          let(:from_string) { '2015-11-15T09:00' }
          it_behaves_like 'valid format'
        end

        context 'during DST' do
          let(:from_string) { '2015-04-01 00:00' }

          context 'with_dst(true)' do
            let(:with_dst) { true }
            it_behaves_like 'an inverse to Ozone::Time'

            it 'correctly sets UTC time' do
              expect(@time).to eq ::Time.parse('2015/04/01T07:00+0000').utc
            end
          end

          context 'with_dst(false)' do
            let(:with_dst) { false }
            it_behaves_like 'an inverse to Ozone::Time'

            it 'correctly sets UTC time' do
              expect(@time).to eq ::Time.parse('2015/04/01T08:00+0000').utc
            end
          end
        end

        context 'not during DST' do
          let(:from_string) { '2015-11-15 00:00' }
          context 'with_dst(true)' do
            let(:with_dst) { true }
            it_behaves_like 'an inverse to Ozone::Time'

            it 'correctly sets UTC time' do
              expect(@time).to eq ::Time.parse('2015/11/15T08:00+0000').utc
            end
          end

          context 'with_dst(false)' do
            let(:with_dst) { false }
            it_behaves_like 'an inverse to Ozone::Time'

            it 'correctly sets UTC time' do
              expect(@time).to eq ::Time.parse('2015/11/15T08:00+0000').utc
            end
          end
        end
      end
    end
  end
end
