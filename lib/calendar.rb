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

  def special_days
    throw_away = [:open, :close, :closed]
    hours.keys.reject { |key| throw_away.include?(key) }
  end

  def pickup_time(job, time)
    pickup = Scheduler.new(self, time[:dropoff_time], job.duration).run
    stringify_pickup(pickup)
  end

  private
    def stringify_pickup(pickup)
      pickup.strftime("%a %b %d %I:%M:%S %Y")
    end
end
