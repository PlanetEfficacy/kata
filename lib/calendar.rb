class Calendar
  SECONDS_PER_DAY = 60 * 60 * 24
  attr_accessor :hours

  def initialize(shop)
    @shop = shop
    @hours = Hash.new
  end

  def open(open, close)
    hours[:open] = Time.parse(open)
    hours[:close] = Time.parse(close)
  end

  def openning
    hours[:open]
  end

  def closing
    hours[:close]
  end

  def update(day, open, close)
    hours[day] = { open: Time.parse(open), close: Time.parse(close) }
  end

  def closed(*days)
    hours[:closed] = days
  end

  def closed_days_of_the_week
    hours[:closed].reject { |day| day.class == String } if hours[:closed]
  end

  def closed_days
    hours[:closed].reject { |day| day.class == Symbol } if hours[:closed]
  end

  # def closed?(date)
  #   closed_on?(date) || closed_on?(day_of_week_symbol(date))
  # end
  #
  # def open?(date)
  #   !closed?(date)
  # end

  def special_days
    throw_away = [:open, :close, :closed]
    hours.keys.reject { |key| throw_away.include?(key) }
  end

  # def special_hours?(date)
  #   special_days.map { |day| Date.parse(day) }.include?(date)
  # end
  #
  # def get_special_hours(date)
  #   hours[special_days.find { |day| Date.parse(day) == date }]
  # end
  #
  # def get_special_openning(date)
  #   get_special_hours(date)[:open]
  # end
  #
  # def get_special_closing(date)
  #   get_special_hours(date)[:close]
  # end

  def pickup_time(job, time)
    pickup = Scheduler.new(self, time[:dropoff_time], job.duration).run
    stringify_pickup(pickup)
  end

  def work_day(date)
    return hours[day_of_week_symbol(date)] if hours[day_of_week_symbol(date)]
    return hours[find_work_day(date)] if hours[find_work_day(date)]
    return { open: openning, close: closing }
  end

  private
    def closed_on?(date)
      if date.class == Date
        closed_days && closed_days.map { |day| Date.parse(day) }.include?(date)
      else
        closed_days_of_the_week && closed_days_of_the_week.include?(date)
      end
    end

    def string_date(date)
      date.strftime("%b %d, %Y")
    end

    def day_of_week_symbol(date)
      date.strftime("%a").downcase.to_sym
    end

    def stringify_pickup(pickup)
      pickup.strftime("%a %b %d %I:%M:%S %Y")
    end

    def find_work_day(date)
      hours.keys.find { |day| day.class == String && Date.parse(day) == date }
    end
end
