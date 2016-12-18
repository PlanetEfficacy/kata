require_relative "../lib/package"

describe Package do
  let(:wax) { Service.new(:wax, 900) }
  let(:edge) { Service.new(:edge, 1500) }
  let(:package) { Package.new(:basic, [wax, edge]) }

  describe Package, "#name" do
    it "gets the name of the package" do
      expect(package.name).to eq(:basic)
    end
  end

  describe Package, "#price" do
    it "gets the price of the package" do
      expect(package.price).to eq(5333)
    end
  end

  describe Package, "#duration" do
    it "gets the duration of the package" do
      expect(package.duration).to eq(2400)
    end
  end
end
