require 'oystercard'

describe Oystercard do

subject(:oystercard) { described_class.new }

  describe 'initialize' do
    it 'Check if oystercard has a balance equal to 0' do
      expect(subject.balance).to eq(0)
    end
  end

end
