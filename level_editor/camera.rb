require_relative 'bounding_box'

class Camera
  attr_accessor :x, :y, :zoom, :angle, :vanishing_point_x, :vanishing_point_y, :bounding_box
  
  def initialize x, y, zoom=1.0
    @x = x
    @y = y
    @zoom = zoom
    @angle = 0
    @vanishing_point_x = $window.width  / 2.0
    @vanishing_point_y = $window.height / 2.0
    @min_zoom = 0.1
    @max_zoom = 2.0
    @parallax_factor_max = 1.49
    @parallax_factor_min = 0.0
    @bounding_box = BoundingBox.new @x, @y, $window.width, $window.height
  end
  
  def update
    width =  $window.width  / @zoom
    height = $window.height / @zoom
    @bounding_box.x = @x - width/2.0
    @bounding_box.y = @y - height/2.0
    @bounding_box.width  = width
    @bounding_box.height = height
  end
  
  def zoom= zoom
    if zoom < @min_zoom
      @zoom = @min_zoom
    elsif zoom > @max_zoom
      @zoom = @max_zoom
    else
      @zoom = zoom
    end
  end
  
  def screen_factor parallax_factor
    @zoom / ((1.0-parallax_factor)*@zoom+1.0)
  end
  
  def screen_x x, screen_factor
    @vanishing_point_x + (x - @x) * screen_factor
  end
  
  def screen_y y, screen_factor
    @vanishing_point_y + (y - @y) * screen_factor
  end
  
  def x_for_screen_x screen_x, screen_factor
    ((screen_x - @vanishing_point_x) / screen_factor) + @x
  end
  
  def y_for_screen_y screen_y, screen_factor
    ((screen_y - @vanishing_point_y) / screen_factor) + @y
  end
end

