class LenseFlare
  @@base_color          = Gosu::Color.rgba 255, 255, 255, 255
  @@rainbow_flare_color = Gosu::Color.rgba 255, 255, 255, 60
  
  class << self
    def draw x, y, z, center_x, center_y, strength, color=Gosu::Color.rgba(0, 0, 255, 255), scale=1.0, angle=0.0, options={}
      scale = 0 if scale < 0
      strength = 0 if strength < 0
      
      dx = center_x - x
      dy = center_y - y
      
      flare_angle = Gosu.angle(x, y, center_x, center_y)
      edge_angle  = Gosu.angle(dx, dy, 0, 0)
      center_dist = Math.sqrt(dx**2 + dy**2)
      edge_x = -(dx / center_dist * center_x * 1.0) + center_x
      edge_y = -(dy / center_dist * center_y * 1.0) + center_y
      
      
      prev_alpha = color.alpha
      color = color.dup
      hflare_color = color.dup
      alpha = strength
      alpha = 1 if alpha > 1
      color                  .alpha = alpha**0.9    * 210
      hflare_color           .alpha = alpha**1.0    * 255
      @@base_color           .alpha = alpha         * 255
      @@rainbow_flare_color  .alpha = alpha**0.4    * 100
      fade = (center_dist)/@@range
      fade = 1 if fade > 1
      fade = 0 if fade < 0
      fade = Math.sin(fade**0.75 * Math::PI)**1.5
      
      @@rainbow_flare_color  .alpha *= fade
      
      draw_horizontal_flare x, y, options[:center_flare_z] || z, angle, scale, strength*0.6, hflare_color
      scale = scale**0.9
      draw_star_flare       x, y, options[:center_flare_z] || z, angle, scale,            hflare_color      

      draw_hexagon        center_x + dx*0.75,   center_y + dy*0.75,   options[:outer_flare_z] || z,  angle,        scale,      color
      draw_hexagon        center_x + dx*1.5,    center_y + dy*1.5,    options[:outer_flare_z] || z,  angle,        scale*1.5,  color
      draw_blurred_circle center_x + dx*0.6,    center_y + dy*0.6,    options[:outer_flare_z] || z,  angle,        scale,      color
      draw_rainbow_flare  center_x + dx*1.1,    center_y + dy*1.1,    options[:outer_flare_z] || z,  flare_angle,  scale*1.2
      draw_rainbow_edge   edge_x, edge_y, options[:outer_flare_z] || z, edge_angle, 1.4
      
      color.alpha = prev_alpha
      #@@rainbow_flare_color.alpha = 80
      #@@base_color.alpha = 255
    end
    
    def draw_outer_flare x, y, z, center_x, center_y, strength, color=Gosu::Color.rgba(0, 0, 255, 255), scale=1.0, angle=0.0
      scale = 0 if scale < 0
      strength = 0 if strength < 0
      
      dx = center_x - x
      dy = center_y - y
      
      flare_angle = Gosu.angle(x, y, center_x, center_y)
      edge_angle  = Gosu.angle(dx, dy, 0, 0)
      center_dist = Math.sqrt(dx**2 + dy**2)
      edge_x = -(dx / center_dist * center_x * 1.0) + center_x
      edge_y = -(dy / center_dist * center_y * 1.0) + center_y
      
      
      prev_alpha = color.alpha
      color = color.dup
      alpha = strength
      alpha = 1 if alpha > 1
      color                  .alpha = alpha**0.9    * 210
      @@base_color           .alpha = alpha         * 255
      @@rainbow_flare_color  .alpha = alpha**0.4    * 100
      fade = (center_dist)/@@range
      fade = 1 if fade > 1
      fade = 0 if fade < 0
      fade = Math.sin(fade**0.75 * Math::PI)**1.5
      
      @@rainbow_flare_color  .alpha *= fade      

      draw_hexagon        center_x + dx*0.75,   center_y + dy*0.75, z,  angle,        scale,      color
      draw_hexagon        center_x + dx*1.5,    center_y + dy*1.5,  z,  angle,        scale*1.5,  color
      draw_blurred_circle center_x + dx*0.6,    center_y + dy*0.6,  z,  angle,        scale,      color
      draw_rainbow_flare  center_x + dx*1.1,    center_y + dy*1.1,  z,  flare_angle,  scale*1.2
      draw_rainbow_edge   edge_x, edge_y,                           z,  edge_angle, 1.4
      
      color.alpha = prev_alpha
    end
    
    def draw_center_flare x, y, z, center_x, center_y, strength, color=Gosu::Color.rgba(0, 0, 255, 255), scale=1.0, angle=0.0
      scale = 0 if scale < 0
      strength = 0 if strength < 0
      
      hflare_color = color.dup
      alpha = strength
      alpha = 1 if alpha > 1
      hflare_color           .alpha = alpha**1.0    * 255
      @@base_color           .alpha = alpha         * 255
      
      draw_horizontal_flare x, y, z, angle, scale, strength*0.6, hflare_color
      draw_star_flare       x, y, z, angle, scale**0.9,          hflare_color  
    end
    
    def draw_horizontal_flare x, y, z, angle, scale, strength, color
      @@horizontal_flare.draw_rot x, y, z, angle, 0.5, 0.5, scale*strength**1.2,    scale*strength*1.5,          color,        :additive
      @@horizontal_flare.draw_rot x, y, z, angle, 0.5, 0.5, scale*strength**2.0,    scale*strength, @@base_color, :additive
    end

    def draw_star_flare x, y, z, angle, scale, color
      @@star_flare.draw_rot x, y, z, angle, 0.5, 0.5, scale, scale, color, :additive
    end

    def draw_hexagon x, y, z, angle, scale, color
      @@blurred_hexagon.draw_rot x, y, z, angle, 0.5, 0.5, scale, scale, color, :additive
    end

    def draw_blurred_circle x, y, z, angle, scale, color
      @@blurred_circle.draw_rot x, y, z, angle, 0.5, 0.5, scale, scale, color, :additive
    end

    def draw_rainbow_flare x, y, z, angle, scale
      @@rainbow_flare_circle.draw_rot x, y, z, angle, 0.5, 0.5, scale, scale, @@rainbow_flare_color, :additive
    end

    def draw_rainbow_edge x, y, z, angle, scale
      @@rainbow_flare_edge.draw_rot x, y, z, angle, 0.5, 0.0, scale**0.5, 1.0, @@rainbow_flare_color, :additive
    end
    
    def load_images window, load_path=lense_flare_images_in_same_path_as_this_file
      @@range = window.width * 1.5
      @@star_flare           = Gosu::Image.new window, File.join(load_path, 'star_flare.png')
      @@horizontal_flare     = Gosu::Image.new window, File.join(load_path, 'horizontal_flare.png')
      @@blurred_circle       = Gosu::Image.new window, File.join(load_path, 'blurred_circle.png')
      @@blurred_hexagon      = Gosu::Image.new window, File.join(load_path, 'blurred_hexagon.png')
      @@rainbow_flare_circle = Gosu::Image.new window, File.join(load_path, 'rainbow_flare_circle.png')
      @@rainbow_flare_edge   = Gosu::Image.new window, File.join(load_path, 'rainbow_flare_edge.png')
    end
    
    def lense_flare_images_in_same_path_as_this_file
      File.join(File.dirname(__FILE__), 'lense_flare_images')
    end
  end
end