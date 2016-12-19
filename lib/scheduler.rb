require 'pry'
require_relative "../lib/calendar"
require_relative "../lib/date_inspector"

class Scheduler
  attr_reader :cal,
              :drop_off,
              :date,
              :duration,
              :inspector

  def initialize(calendar, drop_off, duration)
    @cal = calendar
    @drop_off = Time.parse(drop_off)
    @date = Date.parse(drop_off)
    @duration = duration
  end

  def run
    get_pickup(drop_off, duration)
  end

  private

    def get_pickup(date, duration)
      open? ? find_pickup(date, duration) : next_day(date, duration)
    end

    def open?
      DateInspector.new(cal, @date).open?
    end

    def find_pickup(date, duration)
      special_hours? ? handle_special(date, duration) : handle_normal(date, duration)
    end

    def special_hours?
      DateInspector.new(cal, @date).special_hours?
    end

    def handle_normal(date, duration)
      if time_left?(date, duration)
        calculate_pickup(date, duration)
      else
        keep_searching(date)
      end
    end

    def handle_special(date, duration)
      special_time_left?(date, duration) ? calculate_pickup(date, duration) : keep_searching(date)
    end

    def next_day(date, duration)
      increment_date(date)
      get_pickup(@date, duration)
    end

    def special_time_left?(date, duration)
      (date + duration) <= DateInspector.new(cal, @date).get_special_closing
    end

    def time_left?(date, duration)
      (date + duration) <= DateInspector.new(cal, @date).get_closing
    end

    def calculate_pickup(date, duration)
      date + duration
    end

    def keep_searching(date)
      remaining_duration(date)
      increment_date(date)
      get_pickup(@date, @duration)
    end

    def remaining_duration(date)
      @duration = duration - (DateInspector.new(cal, @date).get_closing - date)
    end

    def increment_date(date)
      @date = get_openning(date + 60 * 60 * 24)
    end

    def get_openning(date)
      DateInspector.new(cal, date).get_openning
    end
end
