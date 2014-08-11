class Stage::Background
  def initialize
    @sun = Gosu::Image.new($window, 'resources/graphics/map_art/sun.png')
    @dust = Gosu::Image.new($window, 'resources/graphics/map_art/dust.png')
    @dust_x_1 = -@dust.width
    @dust_x_2 = 0
    @cloud = Gosu::Image.new($window, 'resources/graphics/map_art/cloud_1.png')
    @cloud_x = -@cloud.width/2
  end
  
  def update
    @cloud_x += 0.5
    @dust_x_1 += 3
    @dust_x_2 += 3
    @dust_x_1 = 0 if @dust_x_1 > $window.width
    @dust_x_2 = 0 if @dust_x_1 > $window.width
  end
  
  def draw
    draw_background 400, 0
    @cloud.draw @cloud_x, 0, 0
    @dust.draw @dust_x_1, 160, 0
    @dust.draw @dust_x_2, 160, 0
  end
  
  
  private
  
  
  def draw_background horizon_line, sun_y
    draw_sky $window.height - sun_y
    draw_sun 300
    draw_ground -horizon_line
  end
  
  def draw_sun sun_y
    x = 300
    y = sun_y
    z = 0
    
    @sun.draw_rot x, y, z, 0, 0.5, 0.5, 0.5, 0.5
  end
  
  def draw_sky offset_y
    draw_horizontal_gradient 0, $window.width, -200, $window.height-offset_y, 0xFFFFFFFF, 0xFFCCFFFF
    draw_horizontal_gradient 0, $window.width, $window.height-offset_y, $window.height+200, 0xFFCCFFFF, 0xFFFFFFCC
  end
  
  def draw_ground offset_y
    ground_horizon_fade_size = 200
    draw_horizontal_gradient 0, $window.width, -offset_y, ground_horizon_fade_size-offset_y, 0x00DDDDB1, 0xFFE0DFC0
    fill                     0, $window.width, ground_horizon_fade_size-offset_y, $window.height+100, 0xFFE0DFC0
  end
  
  def fill left, right, top, bottom, color
    x1 = left
    y1 = top
    c1 = color
    
    x2 = right
    y2 = top
    c2 = color
    
    x3 = right
    y3 = bottom
    c3 = color
    
    x4 = left
    y4 = bottom
    c4 = color
    
    z  = 0
    
    $window.draw_quad x1, y1, c1, x2, y2, c2, x3, y3, c3, x4, y4, c4, z
  end
  
  def draw_horizontal_gradient left, right, top, bottom, top_color, bottom_color
    x1 = left
    y1 = top
    c1 = top_color
    
    x2 = right
    y2 = top
    c2 = top_color
    
    x3 = right
    y3 = bottom
    c3 = bottom_color
    
    x4 = left
    y4 = bottom
    c4 = bottom_color
    
    z  = 0
    
    $window.draw_quad x1, y1, c1, x2, y2, c2, x3, y3, c3, x4, y4, c4, z
  end
end