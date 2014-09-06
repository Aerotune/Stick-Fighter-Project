class BoundingBox
  attr_accessor :x, :y, :width, :height, :color
  
  def initialize x, y, width, height
    @x = x
    @y = y
    @width = width
    @height = height
    @color = Gosu::Color.rgba(255, 0, 0, 100)
  end
  
  def left
    @x
  end
  
  def right
    @x + @width
  end
  
  def top
    @y
  end
  
  def bottom
    @y + @height
  end
  
  def screen_left camera, screen_factor
    camera.screen_x(left, screen_factor)
  end
  
  def screen_right camera, screen_factor
    camera.screen_x(right, screen_factor)
  end
  
  def screen_top camera, screen_factor
    camera.screen_y(top, screen_factor)
  end
  
  def screen_bottom camera, screen_factor
    camera.screen_y(bottom, screen_factor)
  end
  
  def hit_bounding_box? bounding_box
    (self.left <= bounding_box.right) && (bounding_box.left <= self.right) &&
    (self.top <= bounding_box.bottom) && (bounding_box.top <= self.bottom)
  end
  
  def hit_point? x, y
    (x >= self.left) && (x <= self.right) &&
    (y >= self.top)  && (y <= self.bottom)
  end
  
  def hit_screen_point? x, y, camera, screen_factor
    (x >= camera.screen_x(left, screen_factor)) && (x <= camera.screen_x(right, screen_factor)) &&
    (y >= camera.screen_y(top, screen_factor))  && (y <= camera.screen_y(bottom, screen_factor))
  end
  
  def draw camera, parallax_factor
    screen_factor = camera.screen_factor parallax_factor
    hit_box_screen_left   = screen_left   camera, screen_factor
    hit_box_screen_top    = screen_top    camera, screen_factor
    hit_box_screen_right  = screen_right  camera, screen_factor
    hit_box_screen_bottom = screen_bottom camera, screen_factor

    z = 1
    c = @color
    $window.draw_quad \
      hit_box_screen_left,
      hit_box_screen_top,
      c,
      hit_box_screen_right,
      hit_box_screen_top,
      c,
      hit_box_screen_right,
      hit_box_screen_bottom,
      c,
      hit_box_screen_left,
      hit_box_screen_bottom,
      c, z
  end
end