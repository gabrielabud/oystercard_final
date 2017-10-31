require 'oystercard'

describe Oystercard do
  subject(:oystercard) { described_class.new }

  describe 'initialize' do
    it 'Check if oystercard has a balance equal to 0' do
      expect(subject.balance).to eq(0)
    end
  end

  describe '#top_up' do
    it { is_expected.to respond_to(:top_up) }
    it 'checking top-up' do
      subject.top_up(5)
      expect(subject.balance).to eq 5
    end
  end

  context 'raising errors' do
    it "raises and error when amount is above limit" do
      maximum_balance = Oystercard::CREDIT_LIMIT
      subject.top_up(maximum_balance)
      expect { subject.top_up 1 }.to raise_error RuntimeError, "amount above #{maximum_balance}"
    end
  end

  describe 'deduct' do
    it "raises an error when insufficient balance" do
      subject.top_up(20)
      expect { subject.deduct 21 }.to raise_error RuntimeError, "Not enough money for the journey"
    end
  end

  describe 'journey status' do
    it 'initial status not in journey' do
      card=Oystercard.new
      expect(card.in_journey).to eq false
    end
  end

  describe 'touch in' do
    it 'change status after touching in' do
      card=Oystercard.new
      expect(card.touch_in).to eq true
    end
  end

  describe 'touch out' do
    it 'change status after touching out' do
      card=Oystercard.new
      card.touch_in
      expect(card.touch_out).to eq false
    end
  end
end
