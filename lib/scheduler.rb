require 'Forwardable'
require_relative "../lib/calendar"
class Scheduler
  extend Forwardable
  def_delegators :@calendar,
                 :hours,
                 :closed?,
                 :special_hours?,
                 :get_special_hours,
                 :closing,
                 :openning,
                 :get_special_openning,
                 :get_special_closing

  attr_reader :calendar, :drop_off, :duration

  def initialize(calendar, drop_off, duration)
    @calendar = calendar
    @drop_off = Time.parse(drop_off)
    @duration = duration
  end

  def drop_off_day
    Date.parse(drop_off.to_s)
  end

  def pickup
    drop_off + duration
  end

  def after_hours?
    return pickup_past_closing? if normal_hours?
    return pickup_past_special_closing? if not_normal_hours?
  end

  def extra_time
    return normal_day_extra_time if normal_hours?
    return special_day_extra_time if not_normal_hours?
  end

  def get_pickup
    return pickup unless after_hours?
    day = find_next_open_day(increment(drop_off))
    Time.parse(day.to_s + " " + start_time(day)) + extra_time
  end

  def increment(day)
    Date.parse(day.to_s) + 1
  end

  private

    def find_next_open_day(day)
      while closed?(day)
        day = increment(day)
      end
      return day
    end

    def time_format(time)
      time.strftime("%H:%M:%S")
    end

    def normal_hours?
      !special_hours?(Date.parse(drop_off.to_s))
    end

    def not_normal_hours?
      special_hours?(Date.parse(drop_off.to_s))
    end

    def pickup_time
      Time.parse(time_format(pickup))
    end

    def drop_off_date
      Date.parse(drop_off.to_s)
    end

    def pickup_past_closing?
      pickup_time > closing
    end

    def pickup_past_special_closing?
      pickup_time > get_special_closing(drop_off_date)
    end

    def normal_day_extra_time
      pickup_time - closing
    end

    def special_day_extra_time
      pickup_time - get_special_closing(drop_off_date)
    end

    def start_time(day)
      time_format(special_hours?(day) ? get_special_openning(day) : openning)
    end
end
