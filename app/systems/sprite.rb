module Systems::Sprite
  @vanishing_point_x = $window.width/2.0
  @vanishing_point_y = $window.height/2.0
  @parallax_factor = 1.0
  
  class << self    
    
    def update entity_manager, time
      entity_manager.each_entity_with_components Components::Sprite do |entity, sprites|
        sprites.each do |sprite|
          sprite_time = time - sprite.start_time
          case sprite.mode
          when "forward"
            sprite.index = sprite_time * sprite.fps
            if sprite.index > sprite.frames.length-1
              sprite.index = sprite.frames.length-1
            end

            sprite.frame = sprite.frames[sprite.index]
          when "backward"
            sprite.index = sprite.index - sprite_time * sprite.fps
            if sprite.index < 0
              sprite.index = 0
            end
            sprite.frame = sprite.frames[sprite.index]
          when "loop"
            sprite.index = (sprite_time * sprite.fps) % sprite.frames.length
            sprite.frame = sprite.frames[sprite.index]
            #p sprite.frames.length
            #p sprite.frame
          end
        end
      end
    end
    
    def draw entity_manager, camera
      #entity_manager.each_entity_with_components Components::Image do |entity, image_components|
      #  position = entity_manager.get_component entity, Components::Position
      #  tint = entity_manager.get_component entity, Components::Tint
      #  if position
      #    image_components.each do |image_component|
      #      x = position.x
      #      y = position.y
      #      screen_x = @vanishing_point_x + (x - camera.x) * @parallax_factor * camera.zoom
      #      screen_y = @vanishing_point_y + (y - camera.y) * @parallax_factor * camera.zoom
      #      z = ZOrder::CHARACTER
      #      angle = 0
      #      center_x = image_component.center_x.to_f / image_component.image.width
      #      center_y = image_component.center_y.to_f / image_component.image.height
      #      factor_x = image_component.factor_x * camera.zoom
      #      factor_y = 1.0                      * camera.zoom
      #      if false#tint
      #        Shaders.tint[:color] = tint.color
      #        $window.post_process shaders: Shaders.tint, z: z do
      #          image_component.image.draw_rot screen_x, screen_y, z, angle, center_x, center_y, factor_x, factor_y
      #        end
      #      else
      #        image_component.image.draw_rot screen_x, screen_y, z, angle, center_x, center_y, factor_x, factor_y
      #      end
      #    end
      #  end
      #end
      $window.rotate camera.angle, @vanishing_point_x, @vanishing_point_y do
        entity_manager.each_entity_with_components Components::Sprite do |entity, sprites|
          position = entity_manager.get_component entity, Components::Position
          tint = entity_manager.get_component entity, Components::Tint
          if position
            sprites.each do |sprite|
              anchor_x = position.x
              anchor_y = position.y
              
              screen_anchor_x = @vanishing_point_x + (anchor_x - camera.x) * @parallax_factor * camera.zoom
              screen_anchor_y = @vanishing_point_y + (anchor_y - camera.y) * @parallax_factor * camera.zoom
              
              center_x = sprite.center_x.to_f * sprite.factor_x
              center_y = sprite.center_y.to_f
              
              screen_x = @vanishing_point_x + (anchor_x - center_x + sprite.frame['offset_x'].to_i - camera.x) * @parallax_factor * camera.zoom
              screen_y = @vanishing_point_y + (anchor_y - center_y + sprite.frame['offset_y'].to_i - camera.y) * @parallax_factor * camera.zoom
              z = ZOrder::CHARACTER
              angle = 0
              
              factor_x = sprite.factor_x  * camera.zoom
              factor_y = 1.0              * camera.zoom
              
              image = sprite.frame['image']
              if false#tint
                Shaders.tint[:color] = tint.color
                $window.post_process shaders: Shaders.tint, z: z do
                  image.draw screen_x, screen_y, z, factor_x, factor_y
                end
              else
                #angle = Gosu.angle screen_anchor_x, screen_anchor_y, $window.mouse_x, $window.mouse_y
                #$window.rotate angle, screen_anchor_x, screen_anchor_y do
                scale = $big_sticks ? 1.2 : 1.0
                $window.scale scale, scale, screen_anchor_x, screen_anchor_y do
                  image.draw screen_x, screen_y, z, factor_x, factor_y
                end
              end
              
            end
          end
        end
      end
    end
    
  end
end