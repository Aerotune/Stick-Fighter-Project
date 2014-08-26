class Stage::Level::Box
  attr_reader :width, :height, :solid
  def initialize x, y, options={}
    @x = x
    @y = y
    @z = ZOrder::LEVEL
    
    @vanishing_point_x = $window.width/2.0
    @vanishing_point_y = $window.height/2.0
    depth = 0.03
    @parallax_front_factor = 1.0 / (1.0-depth)
    @parallax_back_factor  = 1.0 / (1.0+depth)
    
    @width = options['width'] || 515.0
    @height = options['height'] || 50.0
    @solid = options['solid']
  end
  
  def update
    
  end
  
  def draw camera
    @front_left    = @vanishing_point_x + (@x - camera.x)           * camera.zoom * @parallax_front_factor
    @front_top     = @vanishing_point_y + (@y - camera.y)           * camera.zoom * @parallax_front_factor
    @front_right   = @vanishing_point_x + (@x + @width  - camera.x) * camera.zoom * @parallax_front_factor
    @front_bottom  = @vanishing_point_y + (@y + @height - camera.y) * camera.zoom * @parallax_front_factor
    
    @back_left     = @vanishing_point_x + (@x - camera.x)           * camera.zoom * @parallax_back_factor
    @back_top      = @vanishing_point_y + (@y - camera.y)           * camera.zoom * @parallax_back_factor
    @back_right    = @vanishing_point_x + (@x + @width  - camera.x) * camera.zoom * @parallax_back_factor
    @back_bottom   = @vanishing_point_y + (@y + @height - camera.y) * camera.zoom * @parallax_back_factor
    
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
      @front_left,   @front_bottom, @c4, ZOrder::LEVEL_FRONT
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