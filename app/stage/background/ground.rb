class Stage::Background::Ground
  attr_reader :z
  
  def initialize x, y, vanishing_point_x, vanishing_point_y, parallax_factor
    @x = x
    @y = y
    @z = ZOrder::BACKGROUND_GROUND
    @vanishing_point_x = vanishing_point_x
    @vanishing_point_y = vanishing_point_y
    @parallax_factor   = parallax_factor
    @image = Gosu::Image.new($window, 'resources/graphics/map_art/background/processed/ground_color.png')
  end
  
  def update camera
    camera_y = camera.y - $window.height
    camera_y = 0 if camera_y > 0
    @screen_x = @vanishing_point_x
    @screen_y = @vanishing_point_y + (@y - camera_y) * @parallax_factor * camera.zoom
  end
  
  def draw
    @image.draw @screen_x, @screen_y, @z
  end
end