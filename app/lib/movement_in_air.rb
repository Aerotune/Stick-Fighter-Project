require_relative 'quadratic_out_easer'

class MovementInAir 
  attr_reader :x, :y
   
  def initialize options={}
    @start_time_x            = options["start_time"]
    @start_time_y            = options["start_time"]
    @x = @start_x            = options["start_x"]
    @y = @start_y            = options["start_y"]
    @easer_class             = QuadraticOutEaser
    
    @transition_time_x = 0.9
    @transition_time_y = 2.5
    
    @easer_x = @easer_class.new @transition_time_x, 0, 100
    @easer_y = @easer_class.new @transition_time_y, -900, 900
  end
  
  def update time
    @x = @start_x + @easer_x.integral(time - @start_time_x)
    @y = @start_y + @easer_y.integral(time - @start_time_y)
  end
  
  def set_terminal_velocity_x start_time, terminal_velocity, transition_time=@transition_time_x
    time = start_time - @start_time_x
    start_velocity = @easer_x.value(time)
    
    @start_time_x = start_time
    @start_x = @start_x + @easer_x.integral(time)
    @easer_x = @easer_class.new transition_time, start_velocity, terminal_velocity
  end
  
  def terminal_velocity_x
    @easer_x.end_value
  end
end