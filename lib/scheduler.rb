require_relative "../lib/calendar"
class Scheduler
  extend Forwardable
  def_delegators :@calendar,
                #  :closed_days_of_the_week,
                 :hours,
                 :closed?,
                 :special_hours?,
                 :get_special_hours,
                 :closing,
                #  :get_special_openning,
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
    return pickup_time - closing if normal_hours?
    return special_day_extra_time if not_normal_hours?
  end

  def get_pickup
    if after_hours?
      day = increment(drop_off)
      while closed?(day)
        day = increment(day)
      end
      if special_hours?(day)
        Time.parse(day.to_s + " " + get_special_hours(day)[:open].strftime("%H:%M:%S")) + extra_time
      else
        Time.parse(day.to_s + " " + hours[:open].strftime("%H:%M:%S")) + extra_time
      end
    else
      pickup
    end
  end

  def increment(day)
    Date.parse(day.to_s) + 1
  end

  private

    def normal_hours?
      !special_hours?(Date.parse(drop_off.to_s))
    end

    def not_normal_hours?
      special_hours?(Date.parse(drop_off.to_s))
    end

    def pickup_time
      Time.parse(pickup.strftime("%H:%M:%S"))
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

    def special_day_extra_time
      pickup_time - get_special_closing(drop_off_date)
    end
end
