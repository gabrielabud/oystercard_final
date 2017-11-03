require './lib/oystercard'
require './lib/station'
require './lib/journey'

@oc = Oystercard.new
@oc.top_up(20)

def start
  Station.new(:Aldgate, 1)
end

def finish
  Station.new(:Paddington, 4)
end

def oc
  @oc
end
