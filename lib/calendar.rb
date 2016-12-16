class Calendar
  attr_accessor :hours

  def initialize
    @hours = Hash.new
  end

  def open(open, close)
    hours[:open] = Time.parse(open)
    hours[:close] = Time.parse(close)
  end
end
