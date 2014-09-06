require_relative 'bounding_box'

class Box3D
  attr_reader :x, :y
  attr_accessor :bounding_box, :solid, :parallax_factor, :front_parallax_factor, :back_parallax_factor
  
  def initialize x, y, options={}
    @x = x
    @y = y
    @z = options['z'] || 0
    
    @vanishing_point_x = $window.width/2.0
    @vanishing_point_y = $window.height/2.0
    
    @depth  = options['depth'] || 0.49
    @width  = options['width'] || 515.0
    @height = options['height'] || 50.0
    @solid  = !!options['solid']
    
    @bounding_box = BoundingBox.new @x, @y, @width, @height
    
    @front_parallax_factor = options['front_parallax_factor'] || 1.1#1.0 / (1.0-@depth)
    @back_parallax_factor  = options['back_parallax_factor'] || 0.9#1.0 / (1.0+@depth)  
    @parallax_factor = (@front_parallax_factor + @back_parallax_factor) / 2.0
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
    
    front_screen_factor = camera.screen_factor @front_parallax_factor
    back_screen_factor  = camera.screen_factor @back_parallax_factor
    
    @front_left    = camera.screen_x(@x, front_screen_factor)#@vanishing_point_x + (@x - camera.x)           * front_screen_factor
    @front_top     = camera.screen_y(@y, front_screen_factor)#@vanishing_point_y + (@y - camera.y)           * front_screen_factor
    @front_right   = camera.screen_x(@x + @width, front_screen_factor)#@vanishing_point_x + (@x + @width  - camera.x) * front_screen_factor
    @front_bottom  = camera.screen_y(@y + @height, front_screen_factor)#@vanishing_point_y + (@y + @height - camera.y) * front_screen_factor
    @back_left     = camera.screen_x(@x, back_screen_factor)#@vanishing_point_x + (@x - camera.x)           * back_screen_factor
    @back_top      = camera.screen_y(@y, back_screen_factor)#@vanishing_point_y + (@y - camera.y)           * back_screen_factor
    @back_right    = camera.screen_x(@x + @width, back_screen_factor)#@vanishing_point_x + (@x + @width  - camera.x) * back_screen_factor
    @back_bottom   = camera.screen_y(@y + @height, back_screen_factor)#@vanishing_point_y + (@y + @height - camera.y) * back_screen_factor
  end
  
  def draw    
    @c1 = 0xFFc4c288
    @c2 = 0xFFcccc9a
    @c3 = 0xFFafaf61
    @c4 = 0xFFafaf61   
    
    if @back_top < @front_top
      #draw_bottom_side
      draw_sides
      draw_top_side
    else
      #draw_top_side
      draw_sides
      draw_bottom_side
    end    
    
    # Front side
    $window.draw_quad \
      @front_left,   @front_top,    @c1,
      @front_right,  @front_top,    @c2,
      @front_right,  @front_bottom, @c3,
      @front_left,   @front_bottom, @c4#, ZOrder::LEVEL_FRONT
  end
  
  def draw_sides
    if @back_left < @front_left
      #draw_right_side
      draw_left_side
    else
      #draw_left_side
      draw_right_side
    end
  end
  
  def draw_left_side
    $window.draw_quad \
      @back_left,   @back_top,      @c1,
      @front_left,  @front_top,     @c2,
      @front_left,  @front_bottom,  @c3,
      @back_left,   @back_bottom,   @c4, @z
  end
  
  def draw_right_side
    $window.draw_quad \
      @front_right,   @front_top,     @c1,
      @back_right,    @back_top,      @c2,
      @back_right,    @back_bottom,   @c3,
      @front_right,   @front_bottom,  @c4, @z
  end
  
  def draw_bottom_side
    $window.draw_quad \
      @front_left,   @front_bottom, @c1,
      @front_right,  @front_bottom, @c2,
      @back_right,   @back_bottom,  @c3,
      @back_left,    @back_bottom,  @c4, @z
  end
  
  def draw_top_side
    $window.draw_quad \
      @back_left,    @back_top,  @c1,
      @back_right,   @back_top,  @c2,
      @front_right,  @front_top, @c3,
      @front_left,   @front_top, @c4, @z
  end
  
  
  def left
    @x
  end
  
  def right
    left + @width
  end
  
  def top
    @y
  end
  
  def bottom
    top + @height
  end
end