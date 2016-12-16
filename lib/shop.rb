class Shop
  attr_reader :name, :services, :packages
  def initialize(name)
    @name = name
    @services = []
    @packages = []
  end

  def add_service(service)
    services.push(service)
  end

  def add_package(package)
    packages.push(package)
  end
end
