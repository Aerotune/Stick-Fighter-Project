class Components::HitBox < Component
  attr_accessor :x, :y, :width, :height
  def initialize x, y, width, height
    @x = x
    @y = y
    @width = width
    @height = height
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
end