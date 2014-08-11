require 'gosu'
#require 'ashton'
require_relative 'shaders'
require_relative 'settings'

Dir[File.join(File.dirname(__FILE__), *%w[app lib *.rb])].each { |file| require file }
Dir[File.join(File.dirname(__FILE__), *%w[app *.rb])]    .each { |file| require file }

class Window < Gosu::Window
  def initialize
    $window = super 1000, 600, false, 16.6666
    @stage = Stage.new
    
    #Shaders.load
  end
  
  def button_down id
    @stage.button_down id
  end
  
  def button_up id
    @stage.button_up id
  end
  
  def update
    @stage.update
  end
  
  def draw
    fill 0xFF557BC6, 0xFF4F91ED
    
    scale = 0.6
    scale scale, scale, width/2.0, height do
      @stage.draw
      #Systems::HitTest.draw @entity_manager
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