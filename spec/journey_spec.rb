require 'journey'
describe Journey do

  let(:fares) { [1, 6] }
  let(:normal) { described_class.new('Oxford Circus', 'Aldgate') }
  let(:nostart) { described_class.new(nil, 'Aldgate') }
  let(:noend) { described_class.new('Oxford Circus', nil) }

  subject { normal }

  it 'has an entry station' do
    expect(subject.entry_station).to eq 'Oxford Circus'
  end

  it 'has an exit station' do
    expect(subject.exit_station).to eq 'Aldgate'
  end

  describe('#fare') do
    context 'when both stations have values' do
      it 'calculates minimum' do
        expect(subject.fare(*fares)).to eq 1
      end
    end

    context 'when entry station is nil' do
      subject { nostart }

      it 'calculates minimum' do
        expect(subject.fare(*fares)).to eq 6
      end
    end

    context 'when exit station is nil' do
      subject { noend }

      it 'calculates minimum' do
        expect(subject.fare(*fares)).to eq 6
      end
    end
  end
end
