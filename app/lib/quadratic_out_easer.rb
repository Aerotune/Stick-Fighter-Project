class QuadraticOutEaser
  attr_reader :duration, :start_value, :end_value, :activation_function
  
  def initialize duration, start_value, end_value
    @duration             = duration.to_f    
    @start_value          = start_value
    @end_value            = end_value
    
    raise "Duration too small for the easer. got #{duration.inspect}" if @duration < 1.0/60.0
    
    @change = end_value - start_value
    @integral_of_duration = @change * (@duration - (@duration**3 / (3*@duration**2))) + @start_value * @duration
  end
  
  def value time    
    return @start_value if time <= 0
    return @start_value + @change if time >= @duration
    return @start_value + @change * (1.0 - (time / @duration - 1.0)**2)
  end
  
  def integral time    
    return 0 if time <= 0
    return (time - @duration) * (@start_value + @change) + @integral_of_duration if time >= @duration
    return @change * ((time**2 / @duration) - (time**3 / (3*@duration**2))) + @start_value * time
  end
end