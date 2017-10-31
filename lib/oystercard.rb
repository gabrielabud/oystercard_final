class Oystercard
# Oystercards objects
  attr_reader :balance, :limit, :in_journey
  CREDIT_LIMIT=120

  def initialize(balance = 0,limit=CREDIT_LIMIT)
    @in_journey=false
    @balance = 0
    @limit=limit
    top_up(balance)
  end

  def top_up(amount)
    raise RuntimeError, "amount above #{CREDIT_LIMIT}" if overloads?(amount)
    @balance += amount
  end

  def deduct(fare)
    raise RuntimeError, "Not enough money for the journey" if insufficient_money?(fare)
    @balance -= fare
  end

  def touch_in
    @in_journey=true
  end

  def touch_out
    @in_journey=false
  end

private

  def overloads?(amount)
    @balance+amount > CREDIT_LIMIT
   end

def insufficient_money?(fare)
    @balance - fare < 0
end


end
