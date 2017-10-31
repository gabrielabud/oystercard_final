class Oystercard
# Oystercards objects
  attr_reader :balance, :limit
  CREDIT_LIMIT=120
  def initialize(balance = 0,limit=CREDIT_LIMIT)
    @balance = 0
    @limit=limit
    top_up(balance)
  end

  def top_up(amount)
    raise RuntimeError, "amount above #{CREDIT_LIMIT}" if overloads?(amount)
    @balance += amount
  end

private

  def overloads?(amount)
    @balance+amount > CREDIT_LIMIT
   end

end
