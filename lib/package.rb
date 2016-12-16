require 'service'
class Package
  attr_reader :name, :duration, :price
  def initialize(name, services)
    @name = name
    @duration = services.reduce(0) { |sum, service| sum += service.duration }
    @price = services.reduce(0) { |sum, service| sum += service.price }
  end
end
