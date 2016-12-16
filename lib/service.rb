class Service
  attr_reader :name, :duration, :price
  def initialize(name, duration)
    @name = name
    @duration = duration
    @price = duration * 8000 / 60 / 60
  end
end
