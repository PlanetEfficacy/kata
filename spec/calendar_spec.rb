require_relative "../lib/calendar"

describe Calendar, "#open" do
  it "sets the normal business hours of the shop" do
    calendar = Calendar.new
    calendar.open("9:00 AM", "3:00 PM")

    openning = Time.parse("9:00 AM")
    closing = Time.parse("3:00 PM")

    expect(calendar.opens_at).to eq(openning)
    expect(calendar.closes_at).to eq(closing)
  end
end

describe Calendar, "#update" do
  it "changes the opening and closing time for a given day" do
    pending
  end
end

describe Calendar, "#closed" do
  it "sets which days the shop is not open" do
    pending
  end
end

describe Calendar, "#pickup_time" do
  it "returns the time the job is available to be picked up" do
    pending
  end
end
