require 'pry'
class Calendar
  attr_accessor :hours

  def initialize
    @hours = Hash.new
  end

  def open(open, close)
    hours[:open] = Time.parse(open)
    hours[:close] = Time.parse(close)
  end

  def update(day, open, close)
    hours[day] = { open: Time.parse(open), close: Time.parse(close) }
  end

  def closed(*days)
    hours[:closed] = days
  end
end
