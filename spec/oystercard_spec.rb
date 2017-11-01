require 'oystercard'

describe Oystercard do
  subject(:card) { described_class.new }
  let(:station) { double (:station)}

  describe 'initialize' do
    it 'Check if oystercard has a balance equal to 0' do
      expect(card.balance).to eq(0)
    end
  end

  describe '#top_up' do
    it { is_expected.to respond_to(:top_up) }
    it 'checking top-up' do
      card.top_up(5)
      expect(card.balance).to eq 5
    end
  end

  context 'raising errors' do
    it 'raises and error when amount is above limit' do
      maximum_balance = Oystercard::CREDIT_LIMIT
      card.top_up(maximum_balance)
      expect { card.top_up 1 }.to raise_error RuntimeError
    end
  end

  describe 'journey status' do
    it 'initial status not in journey' do
      expect(card.in_journey?).to eq false
    end

    it 'in journey after touch in ' do
      card.top_up(Oystercard::MINIMUM_BALANCE)
      card.touch_in(station)
      expect(card.in_journey?).to eq true
    end

  end

  describe 'touch in' do

    it 'raises an error at touch in if minimum balance is less than 1' do
      expect { card.touch_in(station)}.to raise_error RuntimeError
    end

    it 'remembers entry station on touch in' do
      card.top_up(Oystercard::MINIMUM_BALANCE)
      card.touch_in(station)
      expect(card.entry_station).to eq station
    end
  end

  describe 'touch out' do
    it 'changes the balance by the minimum fare' do
      card.top_up(20)
      expect { card.touch_out }.to change { card.balance }.by(-Oystercard::MINIMUM_FARE)
    end

    it 'makes entry station nil on touch out' do
      card.top_up(Oystercard::MINIMUM_BALANCE)
      card.touch_in(station)
      card.touch_out
      expect(card.entry_station).to eq nil
    end
  end
end
