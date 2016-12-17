require_relative "../lib/calendar"

describe Calendar do
  let(:calendar) { Calendar.new }

  describe Calendar, "#open" do
    it "sets the normal business hours of the shop" do
      calendar.open("9:00 AM", "3:00 PM")

      openning = Time.parse("9:00 AM")
      closing = Time.parse("3:00 PM")

      expect(calendar.hours[:open]).to eq(openning)
      expect(calendar.hours[:close]).to eq(closing)
    end
  end

  describe Calendar, "#update" do
    it "changes the opening and closing time for a given symbolic day" do
      calendar.update(:fri, "10:00 AM", "5:00 PM")
      expected = { open: Time.parse("10:00 AM"), close: Time.parse("5:00 PM") }

      expect(calendar.hours[:fri]).to eq(expected)
    end

    it "changes the opening and closing time for a given string day" do
      calendar.update("Sep 3, 2016", "8:00 AM", "1:00 PM")
      expected = { open: Time.parse("8:00 AM"), close: Time.parse("1:00 PM") }

      expect(calendar.hours["Sep 3, 2016"]).to eq(expected)
    end
  end

  describe Calendar, "#closed" do
    it "sets which days the shop is not open" do
      calendar.closed(:sun, :tue, "Sep 5, 2016")
      expect(calendar.hours[:closed]).to eq([:sun, :tue, "Sep 5, 2016"])
    end
  end

  describe Calendar, "#pickup_time" do
    xit "returns the time the job is available to be picked up" do
      job = Job.new(:performance)
      calendar.pickup_time(job, dropoff_time: "Jun 6, 2016  9:10 AM") # => Mon Jun 06 10:22:00 2016
      calendar.pickup_time(job, dropoff_time: "Jun 6, 2016  2:10 PM") # => Wed Jun 08 09:22:00 2016
      calendar.pickup_time(job, dropoff_time: "Sep 3, 2016 12:10 PM") # => Wed Sep 07 09:22:00 2016
    end
  end
end
