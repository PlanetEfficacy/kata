class Shop
  extend Forwardable
  def_delegators :@calendar, :open, :hours, :update, :closed, :pickup_time

  attr_reader :name, :services, :packages, :jobs, :calendar

  def initialize(name)
    @name = name
    @services = []
    @packages = []
    @jobs = []
    @calendar = Calendar.new(self)
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
