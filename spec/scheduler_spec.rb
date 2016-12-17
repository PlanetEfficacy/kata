require_relative "../lib/scheduler"

describe Scheduler do
  it "knows if special hours apply" do
    cal = Calendar.new("shop")
    cal.update("Sep 3, 2016", "8:00 AM", "1:00 PM")
    schdeuler = Scheduler.new(cal)
    time = Time.parse("Sep 3, 2016")

    expect(scheduler.special_hours_apply?(time)).to eq(trues)
  end
end
