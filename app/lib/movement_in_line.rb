require_relative 'quadratic_out_easer'

class MovementInLine
  attr_reader :x, :y
  
  def initialize options={}
    @start_time              = options["start_time"] || raise
    @x = @start_x            = options["start_x"]
    @y = @start_y            = options["start_y"]
    @default_transition_time = options["default_transition_time"]
    @angle                   = options["angle"]
    @factor_x                = Math.cos(@angle)
    @factor_y                = Math.sin(@angle)
    @easer_class             = QuadraticOutEaser
    
    @easer = @easer_class.new @default_transition_time, options["start_velocity"], options["terminal_velocity"]
  end
  
  def update time
    distance = @easer.integral(time - @start_time)
    @x = @start_x + @factor_x * distance
    @y = @start_y + @factor_y * distance
  end
  
  def set_terminal_velocity start_time, new_terminal_velocity, transition_time=@default_transition_time
    time            = start_time - @start_time
    distance        = @easer.integral(time)
    @start_x        = @start_x + @factor_x * distance
    @start_y        = @start_y + @factor_y * distance
    @start_time     = start_time

    @easer          = @easer_class.new transition_time, velocity(time), new_terminal_velocity
  end
  
  def set_angle start_time, angle
    time            = start_time - @start_time
    distance        = @easer.integral(time)
    @start_x        = @start_x + @factor_x * distance
    @start_y        = @start_y + @factor_y * distance
    @start_time     = start_time
    @angle          = angle
    @factor_x       = Math.cos(@angle)
    @factor_y       = Math.sin(@angle)
    
    
    if time < @easer.duration
      transition_time = @easer.duration - time
    else
      # doesn't matter actually, start_velocity is equal to end_velocity
      transition_time = 1.0
    end
    
    @easer = @easer_class.new transition_time, velocity(time), terminal_velocity
  end
  
  def velocity time
    @easer.value(time - @start_time)
  end
  
  alias :velocity_x :velocity
  
  def velocity_y time
    0
  end
  
  def start_velocity
    @easer.start_value
  end
  
  def terminal_velocity
    @easer.end_value
  end
  
end