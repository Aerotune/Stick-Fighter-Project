require 'rubygems'
require 'gosu'
require_relative 'box3d'
require_relative 'flat'
require_relative 'camera'
require_relative 'level_object_dragger'
require_relative 'spatial_hash'

class Window < Gosu::Window
  attr_reader :blurs
  def initialize
    $window = super 1200, 800, false
    @camera = Camera.new 0, 0, 1.0
    
    @spatial_hash = SpatialHash.new 2048
    
    (0..0).reverse_each do |z|
      z = z*64
      
      front = 1.1 - 0.1*z
      back =  1.1 - 0.1*z-0.2
      
      100.times do |x|
        100.times do |i|
          #@spatial_hash.add Flat.new(-100+x*600, 100-i*400)
          @spatial_hash.add Box3D.new( -100+x*600, 100-i*400, 'front_parallax_factor' => front, 'back_parallax_factor' => back)
        end
      end
    end
    
    @level_object_dragger = LevelObjectDragger.new @spatial_hash, @camera    
  end
  
  def needs_cursor?
    true
  end
  
  def button_down id
    case id
    when Gosu::KbSpace
      @level_object_dragger.start_drag @camera
    when Gosu::MsLeft
      screen_factor = @camera.screen_factor(1.0)
      mouse_level_x = @camera.x_for_screen_x($window.mouse_x, screen_factor)
      mouse_level_y = @camera.y_for_screen_y($window.mouse_y, screen_factor)
      drag_object = find_mouse_hit
      if drag_object
        @drag_object = drag_object
        @level_object_dragger.start_drag @drag_object
      end
    when Gosu::MsWheelUp
      @camera.zoom += 0.025
    when Gosu::MsWheelDown
      @camera.zoom -= 0.025
    end
  end
  
  def find_level_mouse_hit
    @spatial_hash[mouse_level_x, mouse_level_y].find { |drag_object| drag_object.bounding_box.hit_screen_point?(mouse_x, mouse_y, @camera, @camera.screen_factor(drag_object.parallax_factor)) }
  end
  
  def find_mouse_hit
    @spatial_hash.each_cells_in @camera.bounding_box do |cell|
      cell.each do |drag_object|
        if drag_object.bounding_box.hit_screen_point?(mouse_x, mouse_y, @camera, @camera.screen_factor(drag_object.parallax_factor))
          return drag_object
        end
      end
    end
    
    nil
  end
    
  def button_up id
    case id
    when Gosu::KbSpace
      @level_object_dragger.stop_drag @camera
    when Gosu::MsLeft
      @level_object_dragger.stop_drag @drag_object
    end
  end
  
  def update
    @level_object_dragger.update
    @camera.update
    
    @spatial_hash.each_cells_in @camera.bounding_box do |cell|
      cell.each do |object|
        object.update @camera
        object.bounding_box.color.red = 255
        object.bounding_box.color.green = 0
      end
    end
    
    screen_factor = @camera.screen_factor(1.0)
    mouse_level_x = @camera.x_for_screen_x($window.mouse_x, screen_factor)
    mouse_level_y = @camera.y_for_screen_y($window.mouse_y, screen_factor)

    @spatial_hash[mouse_level_x, mouse_level_y].each do |object|
      if object.bounding_box.hit_point? mouse_level_x, mouse_level_y
        object.bounding_box.color.red = 0
        object.bounding_box.color.green = 255
      end
    end
    
    
  end
  
  def draw
    @spatial_hash.each_cells_in @camera.bounding_box do |cell|
      cell.each do |object|
        object.draw if object.respond_to? :draw
        #object.bounding_box.draw @camera, object.parallax_factor
      end
    end
    @camera.bounding_box.draw @camera, 1.0
  end
  
  def fill c1, c2=c1, c3=c2, c4=c3
    x1 = 0
    y1 = 0
    
    x2 = width
    y2 = 0
    
    x3 = width
    y3 = height
    
    x4 = 0
    y4 = height
    
    $window.draw_quad x1, y1, c1, x2, y2, c2, x3, y3, c3, x4, y4, c4
  end
end
#require 'ruby-prof'
#RubyProf.start
Window.new.show
#result = RubyProf.stop
#printer = RubyProf::FlatPrinter.new(result)
#printer.print(STDOUT)