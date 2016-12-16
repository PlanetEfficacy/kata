class Job
  attr_reader :services,
              :jobs

  def initialize(*services)
    # @services = services
    # @rate = 80.00

  end

  def duration
    services.reduce(0) { |sum, service| sum += jobs[service] }
  end

  def price
    (duration / 45.00).round(2)
  end
end
