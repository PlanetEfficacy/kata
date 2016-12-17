class Shop
  attr_reader :name, :services, :packages, :jobs
  def initialize(name)
    @name = name
    @services = []
    @packages = []
    @jobs = []
  end

  def add_service(service)
    services.push(service)
  end

  def add_package(package)
    packages.push(package)
  end

  def add_job(*job_items)
    jobs << Job.new(self, job_items)
  end
end
