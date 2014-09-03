require 'rubygems'
require 'gosu'
require 'ashton'

require_relative 'app/loader'

class Window < Gosu::Window
  attr_reader :blurs
  def initialize
    $window = super 1000, 600, false#, 16.6666
    #$window = super Gosu.screen_width, Gosu.screen_height, true
    @game_state = Loader.new
    
    #@blur_strength = 0.9
    #@buffer = Ashton::WindowBuffer.new
    
    
    #@font = Gosu::Font.new self, "Arial", 16
  end
  
  def needs_cursor?
    true
  end
  
  def reset_stage
    @game_state = Stage.new
  end
  
  def button_down id
    case id
    when Gosu::KbReturn
      #$fancy_effects = !$fancy_effects
      $big_sticks = !$big_sticks
    when Gosu::KbH
      $show_hit_boxes = !$show_hit_boxes
    end
    @game_state.button_down id if @game_state.respond_to? :button_down
  end
    
  def button_up id
    @game_state.button_up id if @game_state.respond_to? :button_up
  end
  
  def update
    @game_state.update
  end
  
  def draw
    @game_state.draw
    #blur
    #haze
    
    #@font.draw "fps: #{Gosu.fps}", $window.width - 60, 10, 0
  end
  
  #def blur
  #  @buffer.capture
  #
  #  Shaders.set_blur 1.0
  #  post_process shaders: [Shaders.blur_horizontal, Shaders.blur_vertical] do
  #    @buffer.draw 0,0,0
  #  end
  #end
  
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

Window.new.show