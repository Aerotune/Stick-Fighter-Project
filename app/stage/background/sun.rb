class Stage::Background::Sun < Stage::Background::ParallaxImage
  attr_reader :haze, :screen_x, :screen_y, :z
  
  def initialize x, y, vanishing_point_x, vanishing_point_y, parallax_factor
    @x = x
    @y = y
    @z = ZOrder::SUN
    @vanishing_point_x = vanishing_point_x
    @vanishing_point_y = vanishing_point_y
    @parallax_factor   = parallax_factor
    @scale = 1.0
    @angle = 0.0
    @image = Gosu::Image.new($window, 'resources/graphics/map_art/background/processed/sun.png', true)
    @center_x = 0.5
    @center_y = 0.5
    @buffer = Ashton::Texture.new @image.width, @image.height
    @haze = 0.7
  end
  
  def update camera
    vanishing_point_y = @vanishing_point_y - Math.sin(Time.now.to_f/40.0) * 105.0
    @screen_x = @vanishing_point_x + (@x - camera.x) * @parallax_factor * camera.zoom
    @screen_y = vanishing_point_y + (@y - camera.y) * @parallax_factor  * camera.zoom
    
    #@screen_x = $window.mouse_x
    #@screen_y = $window.mouse_y
  end
end