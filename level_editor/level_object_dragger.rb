require_relative 'mouse_dragger'

class LevelObjectDragger
  def initialize spatial_hash, camera
    @spatial_hash = spatial_hash
    @camera = camera
    @mouse_dragger = MouseDragger.new
  end
  
  def start_drag object
    @object = object
    @mouse_dragger.reset
    @start_x = @object.x
    @start_y = @object.y
    if @object.kind_of? Camera
      @drag_factor = @camera.zoom
    else
      @drag_factor = @camera.screen_factor(@object.parallax_factor)
    end
    @drag_factor = 1.0 if $window.button_down?(Gosu::KbLeftShift)
  end
  
  def stop_drag object
    @object = nil if @object == object
  end
  
  def stop_drag!
    @object = nil
  end
  
  def update
    return unless @object

    if @object.kind_of? Camera
      @object.x = @start_x - @mouse_dragger.dx / @drag_factor
      @object.y = @start_y - @mouse_dragger.dy / @drag_factor
    else
      x = @camera.x_for_screen_x($window.mouse_x, 1.0)
      y = @camera.y_for_screen_y($window.mouse_y, 1.0)
      @object.x = @start_x + @mouse_dragger.dx / @drag_factor
      @object.y = @start_y + @mouse_dragger.dy / @drag_factor
      @object.update @camera
      @spatial_hash.update @object
    end
  end
end