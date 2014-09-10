require_relative 'surface_points'

class SurfacePointsDetector
  @search_pattern = [
     1,  0,
     1,  1,
     0,  1,
    -1,  1,
    -1,  0,
    -1, -1,
     0, -1,
     1, -1,
     2, -1,
     2,  0,
     2,  1,
     2,  2,
     1,  2,
     0,  2,
    -1,  2,
    -2,  2,
    -2,  1,
    -2,  0,
    -2, -1,
    -2, -2
  ]
  
  @surface_start_pixel_color = Gosu::Color.rgba(255, 0, 0, 255)
  
  class << self
    def surface_points_list hit_mask_grid
      surface_points_list = []
      find_start_pixels         hit_mask_grid, surface_points_list
      calculate_surface_points  hit_mask_grid, surface_points_list
      surface_points_list
    end
    
    def find_start_pixels hit_mask_grid, surface_points_list
      hit_mask_grid.width.times do |x|
        hit_mask_grid.height.times do |y|
          if hit_mask_grid[x, y] == @surface_start_pixel_color
            surface_points = SurfacePoints.new
            surface_points.start_point = [x, y]
            surface_points_list << surface_points
          end
        end
      end
    end
    
    def calculate_surface_points hit_mask_grid, surface_points_list
      surface_points_list.each do |surface_points|
        next_x, next_y = *find_next_surface_pixel(hit_mask_grid, surface_points, *surface_points.start_point)
        while next_x && next_y
          point = [next_x, next_y]
          break if surface_points.points.include? point             
          surface_points.points << point
          next_x, next_y = *find_next_surface_pixel(hit_mask_grid, surface_points, next_x, next_y)
        end
      end
    end
    
    def find_next_surface_pixel hit_mask_grid, surface_points, start_x, start_y
      next_x = nil
      next_y = nil
      prev_x = nil
      prev_y = nil
    
      start_searching_for_surface = false
    
      @search_pattern.each_slice(2) do |dx, dy|
        tx = start_x+dx
        ty = start_y+dy
        if hit_mask_grid.range_x === tx && hit_mask_grid.range_y === ty
          if start_searching_for_surface
            if !hit_mask_grid.transparent?(tx, ty) && !surface_points.points.include?([tx, ty])
              next_x = prev_x
              next_y = prev_y
              break
            else
              prev_x = tx
              prev_y = ty
            end
          else
            if hit_mask_grid.transparent?(tx, ty)
              start_searching_for_surface = true
              prev_x = tx
              prev_y = ty
            end
          end
        end
      end
        
      return next_x, next_y
    end
    
  end
end