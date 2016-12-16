require_relative "../lib/package"

describe Package do
  it "has a name, price, and duration" do
    wax = Service.new(:wax, 900)
    edge = Service.new(:edge, 1500)

    package = Package.new(:basic, [wax, edge])

    expect(package.name).to eq(:basic)
    expect(package.duration).to eq(2400)
    expect(package.price).to eq(5333)
  end
end
