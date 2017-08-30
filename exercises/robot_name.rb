class Robot
  attr_reader :name

  ALPHA = ("A".."Z").to_a
  NUMERIC = ("000".."999").to_a

  def initialize
    @name = set_name
  end

  def reset
    @name = set_name
  end

  private

  def set_name
    loop do
      robot_name = ALPHA.sample + ALPHA.sample + NUMERIC.sample
      return robot_name if unique(robot_name)
    end
  end

  def unique(robot_name)
    ObjectSpace.each_object(Robot).none? { |obj| obj.name == robot_name }
  end
end