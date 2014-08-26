class Stage::Level::Platform
  def initialize meta_data, x, y
    @meta_data = meta_data
    @x = x
    @y = y
    @z = ZOrder::LEVEL
    
    @vanishing_point_x = $window.width/2.0
    @vanishing_point_y = $window.height/2.0
    @parallax_factor = 1.0
  end
  
  def update
    
  end
  
  def draw camera
    screen_x = @vanishing_point_x + (@x - camera.x) * @parallax_factor * camera.zoom
    screen_y = @vanishing_point_y + (@y - camera.y) * @parallax_factor * camera.zoom
    factor = camera.zoom
    @meta_data['image'].draw screen_x, screen_y, @z, factor, factor
  end
  
  def left
    @meta_data['bounding_box']['x'] + @x
  end
  
  def right
    left + @meta_data['bounding_box']['width']
  end
  
  def top
    @meta_data['bounding_box']['y'] + @y
  end
  
  def bottom
    top + @meta_data['bounding_box']['height']
  end
end