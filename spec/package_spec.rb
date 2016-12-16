require_relative "../lib/package"

describe Package do
  it "has a name, price, and duration" do
    service = Service.new(:wax, 900)

    expect(service.name).to eq(:wax)
    expect(service.duration).to eq(900)
    expect(service.price).to eq(2000)
  end
end
