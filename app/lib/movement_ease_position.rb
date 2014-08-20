require_relative 'quadratic_out_easer'

class MovementEasePosition
  attr_reader :x, :y
  
  def initialize options={}
    @start_time              = options["start_time"] || raise
    @x = @start_x            = options["start_x"]
    @y = @start_y            = options["start_y"]
    @distance                = options["distance"]
    @transition_time         = options["transition_time"]
    @angle                   = options["angle"] || 0
    @factor_x                = Math.cos(@angle)
    @factor_y                = Math.sin(@angle)
    @easer_class             = QuadraticOutEaser
    
    @start_distance = 0
    
    @easer = @easer_class.new @transition_time, @start_distance, @distance
  end
  
  def update time
    distance = @easer.value(time - @start_time)
    @x = @start_x + @factor_x * distance
    @y = @start_y + @factor_y * distance
  end
  
  def velocity time
    0
  end
  
  alias :velocity_x :velocity
  
  def velocity_y time
    0
  end
  
  def start_velocity
    @distance / @transition_time
  end
  
  def terminal_velocity
    0
  end
  
end