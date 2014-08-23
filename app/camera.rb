class Camera
  attr_accessor :x, :y, :zoom
  
  def initialize x, y, zoom=1.0
    @x = x
    @y = y
    @zoom = zoom
  end
end