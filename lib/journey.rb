class Journey
  attr_reader :entry_station, :exit_station

  def initialize (entry_station, exit_station)
    @entry_station = entry_station
    @exit_station = exit_station
  end

  def fare(minimum, penalty)
    entry_station && exit_station ? expected_fare(minimum) : penalty
  end

  def expected_fare(minimum)
    minimum + zone_charge
  end

  private

  def zone_charge
    (exit_station.zone - entry_station.zone).abs
  end
end
