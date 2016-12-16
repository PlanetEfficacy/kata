class Job
  attr_reader :services,
              :jobs

  def initialize(*services)
    @services = services
    @jobs = {
      wax: {
        duration: 900
      },
      edge: {
        duration: 1500
      },
      performance: {
        duration: 4320
      },
      basic: {
        # duration:
      },
      ptex: {
        # duration:
      }
    }
  end

  def duration
    services.reduce(0) do |sum, service|
      sum += jobs[service][:duration]
    end
  end
end
