class Job
  attr_reader :shop

  def initialize(*job_item)
    # @shop = Shop.new("Steezy's")
    # services.each { |service| @shop.add_service(service) }
    # packages.each { |package| @shop.add_package(package) }
    # @job_items = job_item.map { |item| find_service_or_package(item) }
  end

  def duration
    services.reduce(0) { |sum, service| sum += jobs[service] }
  end

  def price
    (duration / 45.00).round(2)
  end

  # private
  #
  #
  #   def find_service_or_package(item)
  #     find_service(item) || find_package(item)
  #   end
  #
  #   def find_service(item)
  #     shop.services.find { |service| service.name == item }
  #   end
  #
  #   def find_package(item)
  #     shop.packages.find { |package| package.name == item }
  #   end
end
