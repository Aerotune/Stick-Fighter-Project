class Components::Sprite < Component
  attr_accessor :name, :center_x, :center_y, :images, :factor_x, :fps, :mode, :image, :index, :done
  
  def initialize options
    @name     = options["name"]
    @center_x = options["center_x"]
    @center_y = options["center_y"]
    @images   = options["images"]
    @factor_x = options["factor_x"] || 1
    @fps      = @images.length.to_f / options["duration"] if options["duration"]
    @fps    ||= options["fps"]  || 27
    @mode     = options["mode"] || "loop"
    @image    = @images.first
    @index    = 0
    @done     = false
  end
  
  def mode=mode
    @done = false
    @mode = mode
  end
  
  def done?
    case mode
    when 'forward'
      @index == @images.length - 1
    when 'backward'
      @index == 0
    else
      false
    end
  end
  
  def progress
    @index.to_f/@images.length
  end
end