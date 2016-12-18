require 'Forwardable'
require_relative "../lib/calendar"
class CalendarHunter
  # extend Forwardable
  attr_reader :cal, :date
  def initialize(calendar, date)
    @cal = calendar
    @date = date
  end
end
