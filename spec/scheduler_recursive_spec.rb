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
      cal.open("9:00 AM", "5:00 PM")
      cal.update("Jun 6, 2016", "11:00 AM", "3:00 PM")
      scheduler = SchedulerRecursive.new(cal, "Jun 6, 2016  2:00 PM", 3600)
      expect(scheduler.run).to eq(Time.parse("Jun 6, 2016 3:00 PM"))
    end

    it "normal day drop off, duration after closing following day is special" do
      cal.open("9:00 AM", "10:00 AM")
      cal.update("Jun 7, 2016", "11:00 AM", "3:00 PM")
      expect(scheduler.run).to eq(Time.parse("Jun 7, 2016 11:22 AM"))
    end

    it "special day, duration after closing" do
      cal.open("9:00 AM", "5:00 PM")
      cal.update("Jun 6, 2016", "11:00 AM", "3:00 PM")
      scheduler = SchedulerRecursive.new(cal, "Jun 6, 2016  2:30 PM", 3600)
      expect(scheduler.run).to eq(Time.parse("Jun 7, 2016 9:30 AM"))
    end

    it "special day, duration after closing, followed closed and special days" do
      cal.open("9:00 AM", "5:00 PM")
      cal.update("Jun 6, 2016", "11:00 AM", "3:00 PM")
      cal.closed(:tue, "Jun 8, 2016", :fri)
      cal.update("Jun 9, 2016", "2:00 PM", "2:15 PM")
      cal.update(:sat, "2:00 PM", "2:05 PM")
      scheduler = SchedulerRecursive.new(cal, "Jun 6, 2016  2:30 PM", 3600)

      expect(scheduler.run).to eq(Time.parse("Jun 12, 2016 9:10 AM"))
    end

    it "special day, job duration longer than hours" do
      cal.open("9:00 AM", "5:00 PM")
      cal.update("Jun 6, 2016", "11:00 AM", "3:00 PM")
      scheduler = SchedulerRecursive.new(cal, "Jun 6, 2016  2:30 PM", 36000)

      expect(scheduler.run).to eq(Time.parse("Jun 8, 2016 10:30 AM"))
    end

    it "many special and closed days" do
      cal.open("9:00 AM", "5:00 PM")
      cal.closed(:tue, :wed, :thu, :fri, :sat, :sun, "Jun 13, 2016", "Jun 20, 2016")
      cal.update("Jun 27, 2016", "2:00 AM", "2:01 AM")
      cal.update("Jul 4, 2016", "2:00 AM", "2:09 AM")
      scheduler = SchedulerRecursive.new(cal, "Jun 6, 2016  5:00 PM", 3600)
      scheduler = SchedulerRecursive.new(cal, "Jun 6, 2016  5:00 PM", 3600)
      expect(scheduler.run).to eq(Time.parse("Jul 11, 2016 9:50 AM"))
    end
  end
end
