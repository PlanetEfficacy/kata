require 'pry'
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

  def update(day, open, close)
    hours[day] = { open: Time.parse(open), close: Time.parse(close) }
  end

  def closed(*days)
    hours[:closed] = days
  end

  def closed_days_of_the_week
    hours[:closed].reject { |day| day.class == String }
  end

  def closed_days
    hours[:closed].reject { |day| day.class == Symbol }
  end

  def closed?(date)
    closed_on?(string_date(date)) || closed_on?(day_of_week_symbol(date))
  end

  private
    def closed_on?(date)
      if date.class == String
        closed_days.include?(date)
      else
        closed_days_of_the_week.include?(date)
      end
    end

    def string_date(date)
      date.strftime("%b %d, %Y")
    end

    def day_of_week_symbol(date)
      date.strftime("%a").downcase.to_sym
    end

  # def pickup_time(job, time)
  #   @time = time
  #   @job = job
  #   @pickup = drop_off + job.duration
  #   binding.pry
  #   if special_hours_apply?
  #     binding.pry
  #   end
  #
  #   if after_close?
  #     extra_time = Time.parse(pickup.strftime("%H:%M:%S")) - hours[:close]
  #     @pickup = increment_day(drop_off_day) + extra_time
  #   end
  #
  #   while closed_that_day?
  #     @pickup = increment_day(Date.parse(@pickup.to_s)) + ( extra_time || 0 )
  #     binding.pry
  #   end
  #   stringify_pickup
  # end


    #
    # attr_reader :job, :time, :pickup
    #
    # def drop_off
    #   Time.parse(time[:dropoff_time])
    # end
    #
    # def drop_off_day
    #   Date.parse(drop_off.to_s)
    # end
    #
    # def increment_day(day)
    #   Time.parse((day + 1).to_s + " " + drop_off_day.to_s + " " + hours[:open].strftime("%H:%M:%S"))
    # end
    #
    # def stringify_pickup
    #   @pickup.strftime("%a %b %d %I:%M:%S %Y")
    # end
    #
    # def after_close?
    #   Time.parse(pickup.strftime("%H:%M:%S")) > hours[:close]
    # end
    #
    # def closed_that_week_day?
    #   hours[:closed].any? { |day| day.to_s.capitalize === @pickup.strftime("%a")}
    # end
    #
    # def closed_that_date?
    #   hours[:closed].any? do |day|
    #     day.class != Symbol && Date.parse(day) === Date.parse(@pickup.to_s)
    #   end
    # end
    #
    # def closed_that_special_day?
    #   hours[:closed].any? { |day| Date.parse(day) === @pickup.strftime("%a")}
    # end
    #
    # def closed_that_day?
    #   closed_that_week_day? || closed_that_date?
    # end
    #
    # # def closed?
    # #   closed_that_day? || ( special_hours_apply? && closed_that_special_day? )
    # # end
    #
    # def special_days
    #   hours.keys.reject { |key| key.class == Symbol }
    # end
    #
    # def special_hours_apply?
    #   special_days.any? { |day| Date.parse(day) == Date.parse(@pickup.to_s) }
    # end
    #
    # def get_special_hours
    #   special_days.find { |day| Date.parse(day) == Date.parse(@pickup.to_s) }
    # end
end
