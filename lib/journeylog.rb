require './lib/journey'

class Journeylog
  attr_reader :entry_station, :log, :minimum, :penalty

  def initialize(minimum, penalty, start: nil, journeyclass: Journey)
    @minimum = minimum
    @penalty = penalty
    @log = []
    @journeyclass = journeyclass
    @entry_station = start
  end

  def in_journey?
    !!entry_station
  end

  def start(station)
    charge = in_journey? ? complete_journey(nil) : 0
    @entry_station = station
    charge
  end

  def finish(station)
    charge = complete_journey(station)
    @entry_station = nil
    charge
  end

  def complete_journey(station)
    log << @journeyclass.new(entry_station, station)
    fare
  end

  private

  def fare
    @log.last.fare(@minimum, @penalty)
  end
end
