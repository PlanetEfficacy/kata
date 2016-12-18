require_relative "../lib/calendar_hunter"

describe CalendarHunter do
  let(:cal) { Calendar.new("shop") }
  let(:date) { Date.parse("Sep 2, 2016") }
  let(:hunter) { CalendarHunter.new(cal, date) }

  describe CalendarHunter, "#new" do
    it "is initialized with a calendar and a date" do
      expect(hunter.cal).to eq(cal)
      expect(hunter.date).to eq(date)
    end
  end
end
