require_relative "../lib/service"

describe Service do
  let(:service) { Service.new(:wax, 900) }

  describe Service, "#name" do
    it "gets the name of the service" do
      expect(service.name).to eq(:wax)
    end
  end

  describe Service, "#price" do
    it "gets the price of the service" do
      expect(service.price).to eq(2000)
    end
  end

  describe Service, "#duration" do
    it "gets the duration of the service" do
      expect(service.duration).to eq(900)
    end
  end
end
