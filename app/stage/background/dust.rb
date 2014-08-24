require_relative 'parallax_image'
class Stage::Background::Dust < Stage::Background::ParallaxImage
  
  def update camera
    super camera
    width = @image.width * @scale
    @screen_x1 = @vanishing_point_x + ((@x - camera.x) * @parallax_factor * camera.zoom) %  width
    @screen_x2 = @vanishing_point_x + ((@x - camera.x) * @parallax_factor * camera.zoom) % -width
  end
  
  def draw
    @image.draw_rot @screen_x1, @screen_y, @z, @angle, @center_x, @center_y, @scale, @scale    
    @image.draw_rot @screen_x2, @screen_y, @z, @angle, @center_x, @center_y, @scale, @scale    
  end
end