require 'journey'

describe Journey do

  let(:fares) { [1, 9] }
  let(:station1) { double(:Station, name: "Oxford Circus", zone: 1)}
  let(:station2) { double(:Station, name: "Aldgate", zone: 6)}
  let(:normal) { described_class.new(station1, station2) }
  let(:nostart) { described_class.new(nil, station2) }
  let(:noend) { described_class.new(station1, nil) }

  subject { normal }

  it 'has an entry station' do
    expect(subject.entry_station).to eq station1
  end

  it 'has an exit station' do
    expect(subject.exit_station).to eq station2
  end

  describe('#fare') do

    it 'returns the journey fare' do
      allow(subject).to receive(:expected_fare).and_return(2)
      expect(subject.fare(*fares)).to eq 2
    end

    context 'when both stations have values' do
      it 'calculates minimum' do
        expect(subject.fare(*fares)).to eq 6
      end
    end

    context 'when entry station is nill/double touch out' do
      subject { nostart }
      it 'penalty' do
        expect(subject.fare(*fares)).to eq 9
      end
    end

    context 'when exit station is nil/double touch in ' do
      subject { noend }
      it 'penalty' do
        expect(subject.fare(*fares)).to eq 9
      end
    end
  end
end
