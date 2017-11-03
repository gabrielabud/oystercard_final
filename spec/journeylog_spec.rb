require 'journeylog'
describe Journeylog do

    # mock classes
    let(:start) { double(:station, name: 'Oxford', zone: 4) }
    let(:finish) { double(:station, name: 'Euston', zone: 3) }

    let(:journey) { double(:journey, fare: 3)}
    let(:journeyclass) { journeyclass = double(:Journey, new: journey) }
    let(:fares) { [1, 6] }

    # test subjects
    let(:out_journey) { described_class.new(*fares, journeyclass: journeyclass) }
    let(:in_journey) { described_class.new(*fares, journeyclass: journeyclass, start: start) }
    subject { out_journey }

    describe '#initialize' do

      context 'when created' do
        it 'has empty log' do
          expect(subject.log).to eq Array.new
        end

        it 'has correct fare information' do
          expect([subject.minimum, subject.penalty]).to eq fares
        end
      end
    end

    describe '#in_journey?' do

      context 'when in journey' do
        subject { in_journey }

        it 'is true' do
          expect(subject).to be_in_journey
        end
      end

      context 'when not in journey' do
        subject { out_journey }

        it 'is false' do
          expect(subject).to_not be_in_journey
        end
      end
    end

    describe '#start' do
      before(:each) {
        allow(subject).to receive(:complete_journey).and_return(5)
      }

      context 'when starting' do
        subject { out_journey }

        it 'remembers entry station on touch in' do
          subject.start(start)
          expect(subject.entry_station).to eq start
        end
      end

      context 'when starting normal journey' do
        subject { out_journey }

        it 'charges fare of 0' do
          expect(subject.start(start)).to eq 0
        end
      end

      context 'when touching in twice' do
        subject { in_journey }

        it 'charges non-zero fare' do
          expect(subject.start(start)).to eq 5
        end

        it 'passes nil to complete_journey' do
          # if it doesn't happen shows error
          expect(subject).to receive(:complete_journey).with(nil)
          subject.start(start)
        end
      end
    end

    describe '#finish' do
      before(:each) {
        allow(subject).to receive(:complete_journey).and_return(5)
      }

      context 'when finishing' do
        it 'clears entry station' do
          subject.finish(finish)
          expect(subject.entry_station).to be_nil
        end
      end

      context 'when finishing normal journey' do
        subject { in_journey }

        it 'charges fare' do
          expect(subject.finish(finish)).to eq 5
        end
      end

      context 'when touching out twice' do
        subject { out_journey }

        it 'charges fare' do
          expect(subject.finish(finish)).to eq 5
        end
      end
    end

  describe '#complete_journey' do
    subject { in_journey }
    after(:each) { subject.complete_journey(finish) }

    it 'logs journey' do
      subject.complete_journey(finish)
      expect(subject.log.last).to eq journey
    end

    it 'returns fare' do
      expect(subject.complete_journey(finish)).to eq 3
    end

    it 'passes fares to journey object' do
      expect(journey).to receive(:fare).with(*fares)
      subject.complete_journey(finish)
    end

    it 'passes correct arguments to journey instance' do
      expect(journeyclass).to receive(:new).with(start, finish)
    end
  end
end
