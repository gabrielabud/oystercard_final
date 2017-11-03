require 'oystercard'

describe Oystercard do

  # mock classes
  let(:station) { station = double(:station, name: 'Oxford', zone: 4) }
  let(:log) { double(:log, start: 0, finish: 5)}
  let(:logclass) { double(:Log, new: log) }

  # test subjects
  let(:blank) { described_class.new(logclass: logclass) }
  let(:touched_out) { described_class.new(logclass: logclass, balance: 50) }
  let(:touched_in) { described_class.new(logclass: logclass, balance: 50) }
  subject { blank }

  describe '#initialize' do
    it 'has a balance equal to 0' do
      expect(subject.balance).to eq(0)
    end

    it 'has log instance' do
      expect(subject.log).to eq log
    end
  end

  describe '#top_up' do
    it 'checking top-up' do
      subject.top_up(5)
      expect(subject.balance).to eq 5
    end

    it 'raises and error when amount is above limit' do
      maximum_balance = Oystercard::CREDIT_LIMIT
      subject.top_up(maximum_balance)
      expect { subject.top_up(1) }.to raise_error RuntimeError
    end
  end

  describe '#touch in' do
    subject { touched_in }

    context 'when card is empty' do
      subject { blank }

      it 'raises an error at touch in if minimum balance is less than 1' do
        expect { subject.touch_in(station) }.to raise_error RuntimeError
      end
    end

    context 'when touching in' do
      it 'charges fare' do
        expect { subject.touch_in(station) }.to change { subject.balance }.by(0)
      end

      it 'passes station to log' do
        expect(log).to receive(:start).with(station)
        subject.touch_in(station)
      end
    end
  end

  describe '#touch out' do
    subject  { touched_in }
    it 'charges fare' do
      expect { subject.touch_out(station) }.to change { subject.balance }.by(-5)
    end

    it 'passes station to finish' do
      expect(log).to receive(:finish).with(station)
      subject.touch_out(station)
    end
  end
end
