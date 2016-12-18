require_relative "../lib/calendar_inspector"

describe DateInspector do
  let(:cal) { Calendar.new("shop") }
  let(:date) { Date.parse("Dec 17, 2016") }
  let(:inspector) { DateInspector.new(cal, date) }

  describe DateInspector, "#new" do
    it "is initialized with a calendar and a date" do
      expect(inspector.cal).to eq(cal)
      expect(inspector.date).to eq(date)
    end
  end

  describe DateInspector, "#closed?" do
    it "returns true if closed on a given day" do
      cal.closed(:sun, "Dec 17, 2016")
      inspector_2 = DateInspector.new(cal, Date.parse("Dec 18, 2016"))
      inspector_3 = DateInspector.new(cal, Date.parse("Dec 19, 2016"))

      expect(inspector.closed?).to eq(true)
      expect(inspector_2.closed?).to eq(true)
      expect(inspector_3.closed?).to eq(false)
    end
  end

  describe DateInspector, "#open?" do
    it "returns true if open on a given day" do
      cal.closed(:sun, "Dec 17, 2016")
      inspector_2 = DateInspector.new(cal, Date.parse("Dec 18, 2016"))
      inspector_3 = DateInspector.new(cal, Date.parse("Dec 19, 2016"))

      expect(inspector.open?).to eq(false)
      expect(inspector_2.open?).to eq(false)
      expect(inspector_3.open?).to eq(true)
    end
  end

  describe DateInspector, "#special_hours?" do
    it "returns true if special hours apply" do
      cal.update("Sep 7, 2016", "8:00 AM", "1:00 PM")
      expect(inspector.special_hours?).to eq(false)

      cal.update("Dec 17, 2016", "8:00 AM", "1:00 PM")
      expect(inspector.special_hours?).to eq(true)
    end
  end

  describe DateInspector, "#get_special_hours" do
    it "returns a hash of open and closed hours" do
      cal.update("Dec 17, 2016", "8:00 AM", "1:00 PM")
      hours = { open: Time.parse("8:00 AM"), close: Time.parse("1:00 PM")}

      expect(inspector.get_special_hours).to eq(hours)
    end
  end

  describe DateInspector, "#get_special_openning" do
    it "returns the opnning of a given special day" do
      cal.update("Dec 17, 2016", "8:00 AM", "1:00 PM")

      expect(inspector.get_special_openning).to eq(Time.parse("8:00 AM"))
    end
  end

  describe DateInspector, "#get_special_openning" do
    it "returns the opnning of a given special day" do
      cal.update("Dec 17, 2016", "8:00 AM", "1:00 PM")

      expect(inspector.get_special_closing).to eq(Time.parse("1:00 PM"))
    end
  end
end
