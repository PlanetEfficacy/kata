class Job
  attr_reader :shop, :job_items

  def initialize(shop, *job_item)
    @shop = shop
    @job_items = job_item.flatten.map { |item| find_service_or_package(item) }
  end

  def duration
    job_items.reduce(0) { |sum, item| sum += item.duration }
  end

  def price
    (duration / 45.00).round(2)
  end

  private

    def find_service_or_package(item)
      @item = item
      find_service || find_package
    end

    def find_service
      shop.services.find { |service| service.name == @item }
    end

    def find_package
      shop.packages.find { |package| package.name == @item }
    end
end
