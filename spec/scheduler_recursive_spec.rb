require_relative "../lib/scheduler_recursive"

describe SchedulerRecursive do
  let(:cal) { Calendar.new("shop") }
  let(:scheduler) { scheduler = SchedulerRecursive.new(cal, "Jun 6, 2016  9:10 AM", 4320) }

  describe SchedulerRecursive, "#new" do
    it "is instantiated with a calendar, drop off time, and a duration" do
      expect(scheduler.cal).to eq(cal)
      expect(scheduler.drop_off).to eq(Time.parse("Jun 6, 2016  9:10 AM"))
      expect(scheduler.date).to eq(Date.parse("Jun 6, 2016  9:10 AM"))
      expect(scheduler.duration).to eq(4320)
      expect(scheduler.inspector).to be_instance_of(DateInspector)
    end
  end

  describe SchedulerRecursive, "#run returns a pickup time object for:" do
    it "normal day, duration before closing" do
      cal.open("9:00 AM", "3:00 PM")
      expect(scheduler.run).to eq(Time.parse("Jun 6, 2016 10:22 AM"))
    end

    it "normal day, duration after closing" do
      cal.open("9:00 AM", "10:00 AM")
      expect(scheduler.run).to eq(Time.parse("Jun 7, 2016 9:22 AM"))
    end

    it "normal day, druation after closing, and following 2 days are closed" do
      cal.open("9:00 AM", "10:00 AM")
      cal.closed(:tue, "Jun 8, 2016")
      expect(scheduler.run).to eq(Time.parse("Jun 9, 2016 9:22 AM"))
    end

    it "normal day, duration longer than multiple business days" do
      cal.open("9:00 AM", "10:00 AM")
      scheduler = SchedulerRecursive.new(cal, "Jun 6, 2016  9:10 AM", 36000)
      expect(scheduler.run).to eq(Time.parse("Jun 16, 2016 9:10 AM"))
    end

    it "special day, duration before closing" do
      cal.open("9:00 AM", "10:00 AM")
      cal.update("June 7, 2016", "11:00 AM", "3:00 PM")
      expect(scheduler.run).to eq(Time.parse("Jun 7, 2016 11:22 AM"))
    end
  end
end
