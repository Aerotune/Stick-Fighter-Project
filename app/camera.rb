class Camera
  attr_accessor :x, :y, :zoom, :angle
  
  def initialize x, y, zoom=1.0
    @x = x
    @y = y
    @zoom = zoom
    @angle = 0
  end
end