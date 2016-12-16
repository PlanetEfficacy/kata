class Job
  attr_reader :services,
              :jobs

  def initialize(*services)
    @services = services
    @jobs = {
      wax: {
        duration: 900,
        price: 20.00
      },
      edge: {
        duration: 1500,
        price: 33.33
      },
      performance: {
        duration: 4320,
        price: 96.00
      },
      basic: {
        # duration:
        # price:
      },
      ptex: {
        # duration:
        # price:
      }
    }
  end

  def duration
    services.reduce(0) { |sum, service| sum += jobs[service][:duration] }
  end

  def price
    services.reduce(0) { |sum, service| sum += jobs[service][:price] }
  end
end
