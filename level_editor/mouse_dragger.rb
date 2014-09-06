class MouseDragger  
  def reset
    @start_mouse_x = $window.mouse_x
    @start_mouse_y = $window.mouse_y
  end
  
  def dx
    $window.mouse_x - @start_mouse_x
  end
  
  def dy
    $window.mouse_y - @start_mouse_y
  end
end