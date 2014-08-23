class Stage::Background::ParallaxImage
  attr_reader :z
  
  def initialize image, x, y, z, vanishing_point_x, vanishing_point_y, parallax_factor, options={}
    @image = image
    @x = x
    @y = y
    @z = z
    @angle = 0
    @center_x = 0.5
    @center_y = 1.0
    @scale = 1.0
    @vanishing_point_x = vanishing_point_x
    @vanishing_point_y = vanishing_point_y
    @parallax_factor   = parallax_factor
    self.haze = options['haze'].to_f
    @options = options
  end
  
  def haze
    @haze
  end
  
  def haze= value
    value = 0.0 if value < 0.0
    value = 1.0 if value > 1.0
    @haze = value
  end
  
  def update camera
    @screen_x = @vanishing_point_x + (@x - camera.x) * @parallax_factor * camera.zoom
    @screen_y = @vanishing_point_y + (@y - camera.y) * @parallax_factor * camera.zoom
    @scale = camera.zoom#**0.85 # adds a little bit of comic style perspective
    
    if @options['velocity_x']
      @x += @options['velocity_x'].to_f
    end
  end
  
  def draw
    @image.draw_rot @screen_x, @screen_y, @z, @angle, @center_x, @center_y, @scale, @scale
  end
end