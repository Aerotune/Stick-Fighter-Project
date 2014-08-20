require 'rubygems'
require 'gosu'
require 'ashton'
require_relative 'shaders'
require_relative 'settings'

Dir[File.join(File.dirname(__FILE__), *%w[app lib *.rb])].each { |file| require file }
Dir[File.join(File.dirname(__FILE__), *%w[app *.rb])]    .each { |file| require file }

class Window < Gosu::Window
  attr_reader :blurs
  def initialize
    $window = super 1000, 600, false#, 16.6666
    #$window = super Gosu.screen_width, Gosu.screen_height, true
    @stage = Stage.new
    
    @blur_strength = 0.9
    
    @buffer = Ashton::WindowBuffer.new
    Shaders.load
    
    @font = Gosu::Font.new self, "Arial", 16
  end
  
  def reset_stage
    @stage = Stage.new
  end
  
  def button_down id
    @stage.button_down id
    
    case id
    when Gosu::KbB
      @blur_strength += 0.1
    end
  end
  
  def button_up id 
    @stage.button_up id
  end
  
  def update
    @stage.update
    @blur_strength = mouse_y / height#(Math.sin(Time.now.to_f*0.5)+1)/2
  end
  
  def draw
    @stage.draw
    
    #blur
    
    @font.draw "fps: #{Gosu.fps}", $window.width - 60, 10, 0
  end
  
  def blur
    @buffer.capture
    
    Shaders.set_blur @blur_strength
    post_process Shaders.blur_horizontal, Shaders.blur_vertical do
      @buffer.draw 0,0,0
    end
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

Window.new.show