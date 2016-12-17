require_relative "../lib/job"
describe Job do

  let(:services) { [Service.new(:wax, 900), Service.new(:edge, 1500),
                    Service.new(:base, 720), Service.new(:ptex, 1200) ]}

  let(:packages) { [Package.new(:basic, [services[0], services[1]]),
                    Package.new(:deluxe, [services[0], services[1], services[2]]),
                    Package.new(:performance, services)]}

  let(:jobs) { [:wax, [:edge, :wax], :performance, [:basic, :ptex]] }

  let(:shop) { setup_shop }

  def setup_shop
    shop = Shop.new("Steezy's")
    add_services(shop)
    add_packages(shop)
    add_jobs(shop)
    return shop
  end

  def add_services(shop)
    services.each { |service| shop.add_service(service)}
  end

  def add_packages(shop)
    packages.each { |package| shop.add_package(package)}
  end

  def add_jobs(shop)
    jobs.each { |job_items| shop.add_job(job_items) }
  end

  describe Job, "#duration" do
    it "returns the total number of seconds the job will take to complete" do
      durations = shop.jobs.map { |job| job.duration }

      expect(durations).to eq([900, 2400, 4320, 3600])
    end
  end

  describe Job, "#price" do
    it "returns the total price of the job" do
      prices = shop.jobs.map { |job| job.price }

      expect(prices).to eq([20.00, 53.33, 96.00, 80.00])
    end
  end
end
