require 'gosu'
require 'ashton'
require_relative 'surface_vector_field'
require_relative 'hit_mask_grid'

class Window < Gosu::Window
  def needs_cursor?
    true
  end
  
  def initialize
    $window = super 1000, 600, false
    @hit_mask_image = Gosu::Image.new($window, 'hitmask_alpha.png', true)
    #@hit_mask_texture = Ashton::Texture.new @hit_mask_image
    @hit_mask_grid = HitMaskGrid.new
    @surface_start_pixel_color     = Gosu::Color.rgba(255, 0, 0, 255)
    @surface_direction_pixel_color = Gosu::Color.rgba(0, 255, 0, 255)
    @surface_start_pixels = []

    @hit_mask_grid.width.times do |x|
      @hit_mask_grid.height.times do |y|
        if @hit_mask_grid[x, y] == @surface_start_pixel_color
          @surface_start_pixels << x
          @surface_start_pixels << y
        end
      end
    end
        
    
    
    surface_segment_length = 20
    
    @texture_range_x = (0...@hit_mask_grid.width)
    @texture_range_y = (0...@hit_mask_grid.height)
    
    
    @surfaces = []
    @surface_start_pixels.each_slice(2) do |x, y|
      surface = []
      next_x, next_y = *find_next_surface_pixel(x, y, surface)
      while next_x && next_y
        point = [next_x, next_y]
        break if surface.include? point
        surface << point
        next_x, next_y = *find_next_surface_pixel(next_x, next_y, surface)
      end
      @surfaces << surface
    end
    
    @simple_surfaces = []
    
    vec_distance = 32.0
    next_point_jump = vec_distance/Math.sqrt(vec_distance*vec_distance*2)
    
    @surfaces.each do |surface|
      simple_surface = []
      start_point_index = 0
      next_point_index = start_point_index + next_point_jump
      
      start_point = surface[start_point_index]
      next_point = surface[next_point_index]
      
      loop do
        simple_surface << start_point.dup
      
        while next_point && Gosu.distance(*start_point, *next_point) < vec_distance-0.5
          next_point_index += 1
          next_point = surface[next_point_index] 
        end
        
        if next_point
          angle = Gosu.angle(*start_point, *next_point)
          start_point[0] += Gosu.offset_x(angle, vec_distance)
          start_point[1] += Gosu.offset_y(angle, vec_distance)
      
          next_point_index += next_point_jump
        else
          next_point = surface.last
          angle = Gosu.angle(*start_point, *next_point)
          simple_surface << [start_point[0]+Gosu.offset_x(angle, vec_distance), start_point[1]+Gosu.offset_y(angle, vec_distance)]
          break
        end
      end
      
      @simple_surfaces << simple_surface
    end
    p @simple_surfaces
    #p surfaces
  end
  
  def find_next_surface_pixel x, y, surface
    next_x = nil
    next_y = nil
    prev_x = nil
    prev_y = nil
    
    start_searching_for_surface = false
    
    @search_pattern.each_slice(2) do |dx, dy|
      tx = x+dx
      ty = y+dy
      if @texture_range_x === tx && @texture_range_y === ty
        if start_searching_for_surface
          if !@hit_mask_grid.transparent?(tx, ty) && !surface.include?([tx, ty])
            next_x = prev_x
            next_y = prev_y
            break
          else
            prev_x = tx
            prev_y = ty
          end
        else
          if @hit_mask_grid.transparent?(tx, ty)
            start_searching_for_surface = true
            prev_x = tx
            prev_y = ty
          end
        end
      end
    end
        
    return next_x, next_y
  end
  
  def draw
    @index ||= 0
    @index += 0.1
    @hit_mask_image.draw 0,0,0
    #@surfaces.each do |surface|
    @simple_surfaces.each do |surface|
      surface.each_with_index do |point, index|
        x = point[0]
        y = point[1]
        next unless surface[index+1]
        x2 = surface[index+1][0]
        y2 = surface[index+1][1]
        c1 = 0xFFFF0000
        c2 = 0xFF00FF00
        
        draw_line x, y, c1, x2, y2, c2
      end
      
      point = surface[@index%surface.length]
      c = 0xFF0000FF
      draw_line point[0], point[1], c, point[0], point[1]-9, c
      draw_line point[0]+1, point[1], c, point[0]+1, point[1]-9, c
    end
  end
end

Window.new.show