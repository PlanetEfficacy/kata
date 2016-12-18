require_relative "../lib/calendar"
class Scheduler
  extend Forwardable
  def_delegators :@calendar,
                 :closed_days_of_the_week,
                 :hours,
                 :closed?,
                 :special_hours?

  attr_reader :calendar, :drop_off, :duration

  def initialize(calendar, drop_off, duration)
    @calendar = calendar
    @drop_off = Time.parse(drop_off)
    @duration = duration
  end

  def drop_off_day
    Date.parse(drop_off.to_s)
  end

  def get_special_days
    hours.reject { |day| day.class == Symbol }
  end

  def special_hours_apply?
    get_special_days.keys.any? { |day| Date.parse(day) == Date.parse(drop_off.to_s) }
  end

  def pickup
    drop_off + duration
  end

  def after_hours?
    Time.parse(pickup.strftime("%H:%M:%S")) > hours[:close]
  end

  def extra_time
    Time.parse(pickup.strftime("%H:%M:%S")) - hours[:close]
  end

  def get_pickup
    if after_hours?
      day = increment(drop_off)
      while closed?(day)
        day = increment(day)
      end
      if special_hours?(day)
        # binding.pry
      else
        Time.parse(day.to_s + " " + hours[:open].strftime("%H:%M:%S")) + extra_time
      end
    end
  end

  def increment(day)
    Date.parse(day.to_s) + 1
    # day = Date.parse(day.to_s)
    # Time.parse((day + 1).to_s + " " + drop_off_day.to_s + " " + hours[:open].strftime("%H:%M:%S"))
  end

  # def closed_tomorrow?(date)
  #   closed_days_of_the_week.any? { |day| day.to_s.capitalize == date.strftime("%a") }
  # end

  private

  # def closed_that_week_day?
  #   cal.hours[:closed].any? { |day| day.to_s.capitalize === pickup.strftime("%a")}
  # end
  #
  # def closed_that_date?
  #   cal.hours[:closed].any? do |day|
  #     day.class != Symbol && Date.parse(day) === Date.parse(pickup.to_s)
  #   end
  # end
end
