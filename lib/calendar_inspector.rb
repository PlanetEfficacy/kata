require 'Forwardable'
require_relative "../lib/calendar"
class DateInspector
  extend Forwardable
  def_delegators :@cal,
                 :closed_days,
                 :closed_days_of_the_week,
                 :special_days,
                 :hours

  attr_reader :cal, :date
  def initialize(calendar, date)
    @cal = calendar
    @date = date
  end

  def closed?
    closed_specific_day? || closed_week_day?
  end

  def open?
    !closed?
  end

  def special_hours?
    special_days.map { |day| Date.parse(day) }.include?(date)
  end

  def get_special_hours
    hours[special_days.find { |day| Date.parse(day) == date }]
  end

  def get_special_openning
    get_special_hours[:open]
  end

  def get_special_closing
    get_special_hours[:close]
  end

  private

    def closed_specific_day?
      closed_days && closed_days.map { |day| Date.parse(day) }.include?(date)
    end

    def closed_week_day?
      closed_days_of_the_week && closed_days_of_the_week.include?(symbol_date)
    end

    def symbol_date
      date.strftime("%a").downcase.to_sym
    end

end
