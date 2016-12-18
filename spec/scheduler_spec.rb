require_relative "../lib/scheduler"

describe Scheduler do

  it "has a calednar, drop off time, and a duration" do
    cal = Calendar.new("shop")
    scheduler = Scheduler.new(cal, "Jun 6, 2016  9:10 AM", 4320)

    expect(scheduler.calendar).to eq(cal)
    expect(scheduler.drop_off).to eq(Time.parse("Jun 6, 2016  9:10 AM"))
    expect(scheduler.duration).to eq(4320)
  end

  it "gets special days" do
    cal = Calendar.new("shop")
    cal.update("Sep 3, 2016", "8:00 AM", "1:00 PM")
    cal.update("Sep 4, 2016", "8:00 AM", "1:00 PM")
    cal.update(:fri, "10:00 AM", "5:00 PM")
    scheduler = Scheduler.new(cal, "Sep 3, 2016  9:10 AM", 4320)

    expect(scheduler.get_special_days.keys).to eq(["Sep 3, 2016", "Sep 4, 2016"])
  end

  it "knows the drop off day" do
    cal = Calendar.new("shop")
    scheduler = Scheduler.new(cal, "Sep 3, 2016  9:10 AM", 4320)

    expect(scheduler.drop_off_day).to eq(Date.parse("Sep 3, 2016  9:10 AM"))
  end

  it "knows if special hours apply" do
    cal = Calendar.new("shop")
    cal.update("Sep 3, 2016", "8:00 AM", "1:00 PM")
    scheduler = Scheduler.new(cal, "Sep 3, 2016  9:10 AM", 4320)

    expect(scheduler.special_hours_apply?).to eq(true)
  end

  it "can set a simple pickup" do
    cal = Calendar.new("shop")
    scheduler = Scheduler.new(cal, "Sep 3, 2016  9:10 AM", 4320)
    expected_pickup = Time.parse("Sep 3, 2016 10:22 AM")
    pickup = scheduler.pickup

    expect(pickup).to eq(expected_pickup)
  end

  it "knows if a pickup is after hours" do
    cal = Calendar.new("shop")
    cal.open("9:00 AM", "10:00 AM")
    scheduler = Scheduler.new(cal, "Sep 3, 2016  9:10 AM", 4320)

    expect(scheduler.after_hours?).to eq(true)
  end

  it "knows how much extra time after close to schedule" do
    cal = Calendar.new("shop")
    cal.open("9:00 AM", "10:00 AM")
    scheduler = Scheduler.new(cal, "Sep 3, 2016  9:10 AM", 4320)

    expect(scheduler.extra_time).to eq(1320)
  end

  it "knows if it has special hours tomorrow" do

  end

# maybe I don't need
  it "knows if it is closed tomorrow" do
    cal = Calendar.new("shop")
    cal.closed(:sun, "Sep 5, 2016")

    drop_off_1 = "Dec 18, 2016  2:00 PM"
    drop_off_2 = "Sep 4, 2016  9:10 AM"
    scheduler_1 = Scheduler.new(cal, drop_off_1, 4320)
    scheduler_2 = Scheduler.new(cal, drop_off_2, 4320)

    expect(scheduler_1.closed_tomorrow?).to eq(true)
    expect(scheduler_2.closed_tomorrow?).to eq(true)
  end



end
