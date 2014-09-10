require 'gosu'
require 'ashton'
require_relative 'surface_points_detector'
require_relative 'vector_surface'
require_relative 'hit_mask_grid'

class Window < Gosu::Window
  def needs_cursor?
    true
  end
  
  def initialize
    $window = super 1000, 600, false
    @hit_mask_image = Gosu::Image.new($window, 'hitmask_alpha.png', true)
    @hit_mask_grid = HitMaskGrid.new
    @dot = Gosu::Image.new($window, 'dot.png', true)
    
    @vector_surfaces = []
    
    vector_segment_magnitude = 32.0
    
    surface_points_list = SurfacePointsDetector.surface_points_list @hit_mask_grid
    surface_points_list.each do |surface_points|
      @vector_surfaces << VectorSurface.create_from_surface_points(surface_points, vector_segment_magnitude)
    end
    
    
  end
  
  def draw
    @index ||= 0
    @index += 0.1
    @hit_mask_image.draw 0,0,0
    
    x, y = *@vector_surfaces.first.position_for_distance(mouse_x)
    if x && y
      #y = @hit_mask_grid.find_surface_y(x, y)
      c = 0xFF0000FF
      @dot.draw x, y, 0
      #draw_line x, y, c, x, y-9, c
      #draw_line x+1, y, c, x+1, y-9, c
    end
          
    @vector_surfaces.each do |vector_surface|
      vector_surface.vectors.each_with_index do |vector, index|
        x = vector.x
        y = vector.y
        next unless vector_surface.vectors[index+1]
        x2 = vector.x+Gosu.offset_x(vector.angle, vector_surface.vector_segment_magnitude)
        y2 = vector.y+Gosu.offset_y(vector.angle, vector_surface.vector_segment_magnitude)
        c1 = 0xFFFF0000
        c2 = 0xFF00FF00
        
        draw_line x, y, c1, x2, y2, c2
      end
      
      vector = vector_surface.vectors[@index%vector_surface.vectors.length]
      c = 0xFF0000FF
      draw_line vector.x, vector.y, c, vector.x, vector.y-9, c
      draw_line vector.x+1, vector.y, c, vector.x+1, vector.y-9, c
    end
  end
end

Window.new.show