require_relative "../lib/calendar"

describe Calendar do
  let(:calendar) { Calendar.new("shop") }
  let(:shop) { Shop.new("Steezy's") }

  describe Calendar, "#open" do
    it "sets the normal business hours of the shop" do
      calendar.open("9:00 AM", "3:00 PM")

      openning = Time.parse("9:00 AM")
      closing = Time.parse("3:00 PM")

      expect(calendar.openning).to eq(openning)
      expect(calendar.closing).to eq(closing)
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

  describe Calendar, "#closed_days_of_the_week" do
    it "returns an array of closed symbol days" do
      calendar.closed(:sun, :tue, "Sep 5, 2016")
      expect(calendar.closed_days_of_the_week).to eq([:sun, :tue])
    end
  end

  describe Calendar, "#closed_days" do
    it "returns an array of closed string days" do
      calendar.closed(:sun, "Dec 17, 2016", "Sep 5, 2016")
      expect(calendar.closed_days).to eq(["Dec 17, 2016", "Sep 5, 2016"])
    end
  end

  describe Calendar, "#special_days" do
    it "returns an array of days with special hours" do
      calendar.open("9:00 AM", "3:00 PM")
      calendar.closed(:sun, :tue, "Sep 5, 2016")
      calendar.update("Sep 7, 2016", "8:00 AM", "1:00 PM")
      calendar.update("Jan 8, 2016", "8:00 AM", "1:00 PM")
      calendar.update(:mon, "10:00 AM", "2:00 PM")

      expect(calendar.special_days).to eq(["Sep 7, 2016", "Jan 8, 2016", :mon])
    end
  end

  describe Calendar, "#pickup_time" do
    it "returns the time the job is available to be picked up" do
      dropoff_1 = "Jun 6, 2016  9:10 AM"
      dropoff_2 = "Jun 6, 2016  2:10 PM"
      dropoff_3 = "Sep 3, 2016 12:10 PM"

      expected_pickup_1 = "Mon Jun 06 10:22:00 2016"
      expected_pickup_2 = "Wed Jun 08 09:22:00 2016"
      expected_pickup_3 = "Wed Sep 07 09:22:00 2016"

      services = [ Service.new(:wax, 900), Service.new(:edge, 1500),
                   Service.new(:base, 720), Service.new(:ptex, 1200) ]

      services.each { |service| shop.add_service(service) }

      shop.add_package(Package.new(:performance, services))

      shop.add_job(:performance)

      cal = shop.calendar
      cal.open("9:00 AM", "3:00 PM")
      cal.update(:fri, "10:00 AM", "5:00 PM")
      cal.update("Sep 3, 2016", "8:00 AM", "1:00 PM")
      cal.closed(:sun, :tue, "Sep 5, 2016")

      job = shop.jobs.first

      pickup_1 = cal.pickup_time(job, dropoff_time: dropoff_1)
      pickup_2 = cal.pickup_time(job, dropoff_time: dropoff_2)
      pickup_3 = cal.pickup_time(job, dropoff_time: dropoff_3)

      expect(pickup_1).to eq(expected_pickup_1)
      expect(pickup_2).to eq(expected_pickup_2)
      expect(pickup_3).to eq(expected_pickup_3)
    end
  end
end
