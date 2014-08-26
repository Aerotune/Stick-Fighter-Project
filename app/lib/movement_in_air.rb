require_relative 'quadratic_out_easer'

class MovementInAir 
  attr_reader :x, :y
   
  def initialize options={}
    @start_time_x            = options["start_time"]
    @start_time_y            = options["start_time"]
    @x = @start_x            = options["start_x"]
    @y = @start_y            = options["start_y"]
    
    @easer_class             = QuadraticOutEaser
    
    start_velocity_x    = options['start_velocity_x']
    start_velocity_x    = options['start_velocity_y']
    terminal_velocity_x = options['terminal_velocity_x']
    terminal_velocity_x = options['terminal_velocity_y']
    
    max_delta_x = 1440.0
    max_delta_y = 5800.0
    
    @transition_time_x = ((start_velocity_x-terminal_velocity_x) / 1440.0 * 0.15).abs + 1/60.0
    @transition_time_y = ((start_velocity_x-terminal_velocity_x) / 4700.0 * 2.83).abs + 1/60.0
    
    @easer_x = @easer_class.new @transition_time_x, options['start_velocity_x'], options['terminal_velocity_x']
    @easer_y = @easer_class.new @transition_time_y, options['start_velocity_y'], options['terminal_velocity_y']
  end
  
  def update time
    @x = @start_x + @easer_x.integral(time - @start_time_x)
    @y = @start_y + @easer_y.integral(time - @start_time_y)
  end
  
  def set_terminal_velocity_x start_time, terminal_velocity_x, transition_time=@transition_time_x
    time = start_time - @start_time_x
    start_velocity = @easer_x.value(time)
    
    @start_time_x = start_time
    @start_x = @start_x + @easer_x.integral(time)
    @easer_x = @easer_class.new transition_time, start_velocity, terminal_velocity_x
  end
  
  def set_transition_time_y start_time, transition_time_y
    time = start_time - @start_time_y
    start_velocity = @easer_y.value(time)
    
    @start_time_y = start_time
    @start_y = @start_y + @easer_y.integral(time)
    @easer_y = @easer_class.new transition_time_y, start_velocity, @easer_y.end_value
  end
  
  def transition_time_y
    @easer_y.duration
  end
  
  def terminal_velocity_x
    @easer_x.end_value
  end
  
  def terminal_velocity_y
    @easer_y.end_value
  end
  
  def velocity_x time
    @easer_x.value(time - @start_time_x)
  end
  
  def velocity_y time
    @easer_y.value(time - @start_time_y)
  end
end