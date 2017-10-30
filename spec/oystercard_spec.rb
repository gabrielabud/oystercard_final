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
end
