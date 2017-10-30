class Oystercard
# Oystercards objects
  attr_reader :balance

  def initialize(balance = 0)
    @balance = balance
  end

  def top_up(top)
    @balance += top
  end
end
