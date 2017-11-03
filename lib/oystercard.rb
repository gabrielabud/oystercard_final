class Oystercard
  attr_reader :balance, :limit, :entry_station, :list_of_journeys
  CREDIT_LIMIT = 120
  MINIMUM_BALANCE = 1
  MINIMUM_FARE = 1
  PENALTY = 6

  def initialize(balance: 0, start: nil, limit: CREDIT_LIMIT, journeyclass: Journey)
    @balance = balance
    @limit = limit
    @list_of_journeys = []
    @journeyclass = journeyclass
    @entry_station = start
  end

  def top_up(amount)
    raise "amount above #{CREDIT_LIMIT}" if overloads?(amount)
    @balance += amount
  end

  def touch_in(station)
    message = 'Balance less than the minimum fare'
    raise message  if insufficient_balance?
    if in_journey?
      add_to_list(nil)
      deduct(fare)
    end
    @entry_station = station
  end

  def touch_out(station)
    add_to_list(station)
    deduct(fare)
    @entry_station = nil
  end

  def in_journey?
    !!@entry_station
  end

  private

  def deduct(amount)
    message = 'Not enough money for the journey'
    raise message if insufficient_money?(amount)
    @balance -= amount
  end

  def fare
    @list_of_journeys.last.fare(MINIMUM_FARE, PENALTY)
  end

  def overloads?(amount)
    @balance + amount > CREDIT_LIMIT
  end

  def insufficient_money?(fare)
    @balance - fare < 0
  end

  def insufficient_balance?
    @balance < MINIMUM_BALANCE
  end

  def add_to_list(exit_station)
    @list_of_journeys << @journeyclass.new(entry_station, exit_station)
  end
end
