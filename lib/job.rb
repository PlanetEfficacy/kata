class Job
  attr_reader :services,
              :jobs

  def initialize(*services)
    # @services = services
    # @rate = 80.00
    # @service = {  wax:          900,
    #               edge:         1500,
    #               base:         720,
    #               ptex:         1200,
    #               basic:        service[:wax] + :edge,
    #               deluxe:       :wax + :edge + :base,
    #               performance:  :wax + :edge + :base + :ptex  }
  end

  def duration
    services.reduce(0) { |sum, service| sum += jobs[service] }
  end

  def price
    (duration / 45.00).round(2)
  end
end
