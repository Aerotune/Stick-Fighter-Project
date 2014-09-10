class VectorSurface
  
  class Vector
    attr_reader :x, :y, :angle, :max_magnitude
    
    def initialize x, y, angle, max_magnitude=nil
      @x = x
      @y = y
      @angle = angle
      @max_magnitude = max_magnitude
    end
  end
  
  attr_reader :vectors, :vector_segment_magnitude
  
  def initialize vectors, vector_segment_magnitude
    @vectors = vectors
    @vector_segment_magnitude = vector_segment_magnitude
  end
  
  def position_for_distance distance
    return nil, nil if distance < 0
    vector_magnitude = distance % @vector_segment_magnitude
    vector_index = distance / @vector_segment_magnitude
    #vector_index = 0 if vector_index < 0
    #vector_index = @vectors.length - 1 if vector_index >= @vectors.length
    vector = @vectors[vector_index]
    return nil, nil unless vector
    x = vector.x+Gosu.offset_x(vector.angle, vector_magnitude)
    y = vector.y+Gosu.offset_y(vector.angle, vector_magnitude)
    return x, y
  end
  
  def total_length
    
  end
  
  def self.create_from_surface_points surface_points, vector_segment_magnitude
    next_point_jump = vector_segment_magnitude/Math.sqrt(vector_segment_magnitude*vector_segment_magnitude*2)
    
    vectors = []
    start_point_index = 0
    next_point_index = start_point_index + next_point_jump
    
    start_point = surface_points.points[start_point_index]
    next_point = surface_points.points[next_point_index]
    
    loop do    
      while next_point && Gosu.distance(*start_point, *next_point) < vector_segment_magnitude-0.5
        next_point_index += 1
        next_point = surface_points.points[next_point_index] 
      end
      
      if next_point
        angle = Gosu.angle(*start_point, *next_point)
        vectors << Vector.new(*start_point, angle)
        
        start_point = start_point.dup
        start_point[0] += Gosu.offset_x(angle, vector_segment_magnitude)
        start_point[1] += Gosu.offset_y(angle, vector_segment_magnitude)
                
        next_point_index += next_point_jump
      else
        next_point = surface_points.points.last
        angle = Gosu.angle(*start_point, *next_point)
        vectors << Vector.new(*start_point, angle)
            
        break
      end
    end
            
    new(vectors, vector_segment_magnitude)
  end
end