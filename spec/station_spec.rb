require 'station'

describe Station do

  subject(:station) { described_class.new("Temple", 4) }

  it 'has a name' do
    expect(subject.name).to eq("Temple")
  end

  it 'has a zone' do
    expect(subject.zone).to eq(4)
  end

end
