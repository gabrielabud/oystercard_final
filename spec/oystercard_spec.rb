require 'oystercard'

describe Oystercard do
  subject(:card) { described_class.new }

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
      expect(card.in_journey).to eq false
    end
  end

  describe 'touch in' do
    it 'change status after touching in' do
      card.top_up(Oystercard::MINIMUM_BALANCE)
      expect(card.touch_in).to eq true
    end
    it 'raises an error at touch in if minimum balance is less than 1' do
      expect { card.touch_in }.to raise_error RuntimeError
    end
  end

  describe 'touch out' do
    it 'changes status after touching out' do
      card.top_up(Oystercard::MINIMUM_BALANCE)
      card.touch_in
      expect(card.touch_out).to eq false
    end
    it 'changes the balance by the minimum fare' do
      card.top_up(20)
      expect { card.touch_out }.to change { card.balance }.by(-Oystercard::MINIMUM_FARE)
    end
  end
end
