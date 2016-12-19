require 'pry'
require 'Forwardable'
require_relative "../lib/calendar"
class DateInspector
  extend Forwardable
  def_delegators :@cal,
                 :closed_days,
                 :closed_days_of_the_week,
                 :special_days,
                 :hours,
                 :closing,
                 :openning

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
    special_days.any? do |day|
      if day.class != Symbol
        Date.parse(day) == Date.parse(string_date)
      else
        day == day_of_week_symbol
      end
    end
  end

  def get_special_hours
    day = special_days.find do |day|
      if day.class != Symbol
        Date.parse(day) == Date.parse(string_date)
      else
        day == day_of_week_symbol
      end
    end
    hours[day]
  end

  def get_special_openning
    set_date(get_special_hours[:open])
  end

  def get_special_closing
    set_date(get_special_hours[:close])
  end

  def get_closing
    special_hours? ? get_special_closing : set_date(closing)
  end

  def get_openning
    special_hours? ? get_special_openning : set_date(openning)
  end

  private

    def closed_specific_day?
      closed_days && closed_days.map { |day| Date.parse(day) }.include?(Date.parse(@date.to_s))
    end

    def closed_week_day?
      closed_days_of_the_week && closed_days_of_the_week.include?(symbol_date)
    end

    def symbol_date
      date.strftime("%a").downcase.to_sym
    end

    def set_date(time)
      Time.parse(string_date + " " + time.strftime("%H:%M:%S"))
    end

    def string_date
      date.strftime("%b %d, %Y")
    end

    def day_of_week_symbol
      date.strftime("%a").downcase.to_sym
    end

end
