class Stage::Level::Platform
  def initialize meta_data, x, y
    @meta_data = meta_data
    @x = x
    @y = y
    @z = 0
  end
  
  def update
    
  end
  
  def draw
    @meta_data['image'].draw @x, @y, @z
  end
  
  def left
    @meta_data['bounding_box']['x'] + @x
  end
  
  def right
    left + @meta_data['bounding_box']['width']
  end
  
  def top
    @meta_data['bounding_box']['y'] + @y
  end
  
  def bottom
    top + @meta_data['bounding_box']['height']
  end
end