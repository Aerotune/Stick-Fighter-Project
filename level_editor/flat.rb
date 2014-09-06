class Flat
  attr_accessor :bounding_box, :solid, :parallax_factor
  
  def initialize x, y, width=515.0, height=50.0
    @x = x
    @y = y
    @width = width
    @height = height
    
    @bounding_box = BoundingBox.new @x, @y, @width, @height
    
    @c1 = 0xFFc4c288
    @c2 = 0xFFcccc9a
    @c3 = 0xFFafaf61
    @c4 = 0xFFafaf61   
  end
  
  def x= x
    @bounding_box.x = x
    @x = x
  end
  
  def y= y
    @bounding_box.y = y
    @y = y
  end
  
  def width= width
    @bounding_box.width = width
    @width = width
  end
  
  def height= height
    @bounding_box.height = height
    @height = height
  end
  
  def update camera
    screen_factor = camera.screen_factor(1.0)
    @on_screen_left   = camera.screen_x(@x, screen_factor)
    @on_screen_right  = camera.screen_x(@x+@width, screen_factor)
    @on_screen_top    = camera.screen_y(@y, screen_factor)
    @on_screen_bottom = camera.screen_y(@y+@height, screen_factor)
  end
  
  def draw
    $window.draw_quad \
      @on_screen_left,   @on_screen_top,    @c1,
      @on_screen_right,  @on_screen_top,    @c2,
      @on_screen_right,  @on_screen_bottom, @c3,
      @on_screen_left,   @on_screen_bottom, @c4#, ZOrder::LEVEL_FRONT
  end
end