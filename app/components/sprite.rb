class Components::Sprite < Component
  attr_accessor :name, :center_x, :center_y, :images, :factor_x, :fps, :mode, :image, :index, :done
  
  def initialize options
    super()
    @name     = options["name"]
    @center_x = options["center_x"]
    @center_y = options["center_y"]
    @images   = options["images"]
    @factor_x = options["factor_x"] || 1
    @fps      = options["fps"] || 27
    @mode     = options["mode"] || "loop"
    @image    = @images.first
    @index    = 0
    @done     = false
  end
  
  def mode=mode
    @done = false
    @mode = mode
  end
end