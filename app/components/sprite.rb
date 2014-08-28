class Components::Sprite < Component
  attr_accessor :start_time, :name, :center_x, :center_y, :factor_x, :fps, :mode, :frames, :frame, :index, :done
  
  def initialize options
    @start_time = options["start_time"]
    @name     = options["name"]
    @center_x = options["center_x"]
    @center_y = options["center_y"]
    @frames   = options["frames"]
    @factor_x = options["factor_x"] || 1
    @fps      = @frames.length.to_f / options["duration"] if options["duration"]
    @fps    ||= options["fps"]  || 27
    @mode     = options["mode"] || "loop"
    @frame    = @frames.first
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
      @index >= @frames.length - 1
    when 'backward'
      @index == 0
    else
      false
    end
  end
  
  def progress
    @index.to_f/@frames.length
  end
end