module Moveable
  attr_accessor :speed, :heading, :fuel_capacity, :fuel_efficiency

  def range
    fuel_capacity * fuel_efficiency
  end
end

class WheeledVehicle
  include Moveable
  

  def initialize(tire_array, km_traveled_per_liter, liters_of_fuel_capacity)
    @tires = tire_array
    self.fuel_efficiency = km_traveled_per_liter
    self.fuel_capacity = liters_of_fuel_capacity
  end

  def tire_pressure(tire_index)
    @tires[tire_index]
  end

  def inflate_tire(tire_index, pressure)
    @tires[tire_index] = pressure
  end

  
end

class Auto < WheeledVehicle
  
  def initialize(tire_array, km_traveled_per_liter, liters_of_fuel_capacity)
    # 4 tires are various tire pressures
    super(tire_array, km_traveled_per_liter, liters_of_fuel_capacity)
  end
end

class Motorcycle < WheeledVehicle
  
  def initialize(tire_array, km_traveled_per_liter, liters_of_fuel_capacity)
    # 2 tires are various tire pressures
    super(tire_array, km_traveled_per_liter, liters_of_fuel_capacity)
  end
end


class Boat
  include Moveable
  
  attr_accessor :propeller_count, :hull_count
  
  def initialize(num_propellers, num_hulls, km_traveled_per_liter, liters_of_fuel_capacity)
    self.fuel_efficiency = km_traveled_per_liter
    self.fuel_capacity = liters_of_fuel_capacity
    self.hull_count = num_hulls
    self.propeller_count = num_propellers
  end
  
   def range
    super + 10
  end
end

class MotorBoat < Boat
  def initialize(km_traveled_per_liter, liters_of_fuel_capacity)
    super(1, 1, km_traveled_per_liter, liters_of_fuel_capacity)
  end
  
  
end

class Catamaran < Boat

end

chevy = Auto.new([25,25,25,25], 30, 30 )
p chevy.range
cycle = Motorcycle.new([26,26], 31, 31)
p cycle.range

ocean = Catamaran.new(1,2,60, 60.0)
p ocean.range
