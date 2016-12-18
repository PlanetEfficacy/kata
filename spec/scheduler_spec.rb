require_relative "../lib/scheduler"

describe Scheduler do

  let(:cal) { Calendar.new("shop") }
  let(:scheduler) { scheduler = Scheduler.new(cal, "Jun 6, 2016  9:10 AM", 4320) }

  describe Scheduler, "#new" do
    it "is instantiated with a calednar, drop off time, and a duration" do
      expect(scheduler.calendar).to eq(cal)
      expect(scheduler.drop_off).to eq(Time.parse("Jun 6, 2016  9:10 AM"))
      expect(scheduler.duration).to eq(4320)
    end
  end

  describe Scheduler, "#drop_off_day" do
    it "returns the drop off time as a date object" do
      expect(scheduler.drop_off_day).to eq(Date.parse("Jun 6, 2016  9:10 AM"))
    end
  end

  describe Scheduler, "#pickup" do
    it "return a pickup by adding the duration to the drop off time" do
      expect(scheduler.pickup).to eq(Time.parse("Jun 6, 2016 10:22 AM"))
    end
  end

  describe Scheduler, "#after_hours?" do
    it "returns true if #pickup is after hours" do
      cal.open("9:00 AM", "10:00 AM")

      expect(scheduler.after_hours?).to eq(true)
    end
  end

  describe Scheduler, "#extra_time" do
    it "returns time in seconds remaining on a job after shop hours" do
      cal.open("9:00 AM", "10:00 AM")

      expect(scheduler.extra_time).to eq(1320)
    end
  end

  describe Scheduler, "#increment(day)" do
    it "returns a date object one day in the future of the input day" do
      date = Time.parse("Sep 3, 2016  9:10 AM")
      expected = Date.parse("Sep 4, 2016")

      expect(scheduler.increment(date)).to eq(expected)
    end
  end

  describe Scheduler, "#get_pickup" do
    it "returns pickup considering extra time" do
      cal.open("9:00 AM", "10:00 AM")
      scheduler = Scheduler.new(cal, "Sep 3, 2016  9:30 AM", 3600)

      expect(scheduler.get_pickup).to eq(Time.parse("Sep 4, 2016  9:30 AM"))
    end

    it "returns pickup considering extra time and closed days" do
      cal.open("9:00 AM", "10:00 AM")
      cal.closed(:mon, :tue, "Sep 4, 2016")
      scheduler = Scheduler.new(cal, "Sep 3, 2016  9:30 AM", 3600)
      expect(scheduler.get_pickup).to eq(Time.parse("Sep 7, 2016  9:30 AM"))
    end

    it "returns pickup considering extra time, closed days, and special hours" do
      cal.open("9:00 AM", "10:00 AM")
      cal.closed(:mon, :tue, "Sep 4, 2016")
      cal.update("Sep 7, 2016", "8:00 AM", "1:00 PM")
      scheduler = Scheduler.new(cal, "Sep 3, 2016  9:30 AM", 3600)

      expect(scheduler.get_pickup).to eq(Time.parse("Sep 7, 2016  8:30 AM"))
    end

    it "returns pickup considering drop off on a day with special hours" do
      cal.open("9:00 AM", "3:00 PM")
      cal.update("Sep 7, 2016", "8:00 AM", "1:00 PM")
      scheduler = Scheduler.new(cal, "Sep 7, 2016  12:30 PM", 3600)

      expect(scheduler.get_pickup).to eq(Time.parse("Sep 8, 2016 9:30 AM"))
    end

    it "returns pickup when the job is longer than store hours" do
      cal.open("9:00 AM", "9:05 AM")
      scheduler = Scheduler.new(cal, "Sep 7, 2016  9:00 AM", 900)

      expect(scheduler.get_pickup).to eq(Time.parse("Sep 9, 2016 9:05 AM"))
    end
  end

  describe Scheduler, "#long_job" do
    it "returns true if a duration is longer than the work day" do
      cal.open("9:00 AM", "9:05 AM")
      scheduler = Scheduler.new(cal, "Sep 7, 2016  9:00 AM", 900)

      expect(scheduler.long_job?).to eq(true)
    end
  end
end
