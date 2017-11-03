require './lib/oystercard'
require './lib/station'
require './lib/journey'

@oc = Oystercard.new
@oc.top_up(20)

def oc
  @oc
end
