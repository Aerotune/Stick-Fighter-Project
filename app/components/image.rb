class Components::Image < Component
  attr_accessor :name, :center_x, :center_y, :images, :factor_x, :fps, :image, :index
  
  def initialize options
    @name     = options["name"]
    @center_x = options["center_x"]
    @center_y = options["center_y"]
    @image    = options["image"]
    @factor_x = options["factor_x"] || 1
  end
end