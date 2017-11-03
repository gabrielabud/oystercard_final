require 'oystercard'

describe Oystercard do

  # mock classes
  let(:station) { station = double(:station, name: 'Oxford', zone: 4) }
  let(:journey) { double(:journey, fare: 3)}
  let(:journeyclass) { journeyclass = double(:Journey, new: journey) }

  # test subjects
  let(:blank) { described_class.new(journeyclass: journeyclass) }
  let(:touched_out) { described_class.new(journeyclass: journeyclass, balance: 50) }
  let(:touched_in) { described_class.new(journeyclass: journeyclass, balance: 50, start: station) }
  subject { blank }

  describe '#initialize' do
    it 'check if oystercard has a balance equal to 0' do
      expect(subject.balance).to eq(0)
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

  describe '#journey status' do
    subject { touched_out }

    it 'initial status not in journey' do
      expect(subject.in_journey?).to eq false
    end

    it 'changes status into "in_journey" after touch in' do
      subject.touch_in(station)
      expect(subject.in_journey?).to eq true
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

    it 'remembers entry station on touch in' do
      subject.touch_in(station)
      expect(subject.entry_station).to eq station
    end

    context 'touch in twice charge penalty' do
      it 'charges penalty' do
        expect { subject.touch_in(station) }.to change { subject.balance }.by(-3)
      end
    end
  end

  describe '#touch out' do
    subject  { touched_in }
    it 'changes the balance by the minimum fare' do
      expect { subject.touch_out(station) }.to change { subject.balance }.by(-3)
    end

    it 'makes entry station nil on touch out' do
      subject.touch_out(station)
      expect(subject.entry_station).to eq nil
    end

  end

  describe '#list_of_journeys' do
    subject  { touched_in }
    it 'should have an empty list of journeys by default' do
      expect(subject.list_of_journeys).to eq([])
    end

    it 'should store a journey' do
      subject.touch_out(station)
      expect(subject.list_of_journeys).to eq([journey])
    end
  end
end
