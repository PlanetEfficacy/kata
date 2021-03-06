require_relative "../lib/shop"
describe Shop do
  let(:shop) { shop = Shop.new("Steezy's") }
  let(:wax) { Service.new(:wax, 900) }
  let(:edge) { Service.new(:edge, 1500) }
  let(:base) { Service.new(:base, 1500) }

  describe Shop, "#name" do
    it "returns the shop name" do
      expect(shop.name).to eq("Steezy's")
    end
  end

  describe Shop, "#services" do
    it "returns the services offered by the shop" do
      shop.add_service(wax)
      shop.add_service(edge)

      expect(shop.services.count).to eq(2)
      expect(shop.services.first).to eq(wax)
      expect(shop.services.last).to eq(edge)
    end
  end

  describe Shop, "#packages" do
    it "returns the packages offered by the shop" do
      shop.add_package Package.new(:basic, [wax, edge])
      shop.add_package Package.new(:deluxe, [wax, edge, base])

      expect(shop.packages.count).to eq(2)
      expect(shop.packages.first.name).to eq(:basic)
      expect(shop.packages.last.name).to eq(:deluxe)
    end
  end

  describe Shop, "#add_job" do
    it "creates a job" do
      shop.add_job(:wax)

      expect(shop.jobs.count).to eq(1)
      expect(shop.jobs.first.class).to eq(Job)
    end
  end

  describe Shop, "#calendar" do
    it "returns the shops calendar" do
      expect(shop.calendar).to be_instance_of(Calendar)
    end
  end
end
