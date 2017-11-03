require './lib/journeylog'

class Oystercard
  attr_reader :balance, :limit, :log

  CREDIT_LIMIT = 120
  MINIMUM_FARE = 1
  PENALTY = 6

  def initialize(balance: 0, start: nil, limit: CREDIT_LIMIT, logclass: Journeylog)
    @balance = balance
    @limit = limit
    @log = logclass.new(MINIMUM_FARE, PENALTY)
  end

  def top_up(amount)
    raise "amount above #{CREDIT_LIMIT}" if overloads?(amount)
    @balance += amount
  end

  def touch_in(station)
    message = 'Balance less than the minimum fare'
    raise message if insufficient_balance?
    deduct(log.start(station))
  end

  def touch_out(station)
    deduct(log.finish(station))
  end

  private

  def deduct(amount)
    message = 'Not enough money for the journey'
    raise message if insufficient_money?(amount)
    @balance -= amount
  end

  def overloads?(amount)
    @balance + amount > CREDIT_LIMIT
  end

  def insufficient_money?(fare)
    @balance - fare < 0
  end

  def insufficient_balance?
    @balance < MINIMUM_FARE
  end
end
