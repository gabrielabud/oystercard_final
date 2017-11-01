class Oystercard

  attr_reader :balance, :limit, :entry_station
  CREDIT_LIMIT = 120
  MINIMUM_BALANCE = 1
  MINIMUM_FARE = 1

  def initialize(balance = 0, limit = CREDIT_LIMIT)
    @balance = 0
    @limit = limit
    top_up(balance)
  end

  def top_up(amount)
    raise RuntimeError, "amount above #{CREDIT_LIMIT}" if overloads?(amount)
    @balance += amount
  end

  def touch_in(station)
    message = 'Balance less than the minimum fare'
    raise RuntimeError, message  if insufficient_balance?
    @entry_station = station
  end

  def touch_out
    deduct(MINIMUM_FARE)
    @entry_station = nil
  end

  def in_journey?
     !!@entry_station
  end
private

  def deduct(fare)
    message = 'Not enough money for the journey'
    raise RuntimeError, message  if insufficient_money?(fare)
    @balance -= fare
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

end
