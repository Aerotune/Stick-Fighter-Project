require 'gosu'
#require 'ashton'
require_relative 'shaders'
require_relative 'sprite_sheet'
require_relative 'settings'

Dir[File.join(File.dirname(__FILE__), *%w[app lib *.rb])].each { |file| require file }
Dir[File.join(File.dirname(__FILE__), *%w[app *.rb])]    .each { |file| require file }

class Window < Gosu::Window
  def initialize
    $window = super 800, 600, false, 16.6666
    
    @entity_manager = EntityManager.new
    #entity1 = @entity_manager.create_entity
    #entity2 = @entity_manager.create_entity
    #@tint = Components::Tint.new([0.0, 0.0, 0.5])
    #@entity_manager.add_component entity1, @tint
    #
    #@tint = Components::Tint.new([0.5, 0.0, 0.0])
    #@entity_manager.add_component entity2, @tint
    #
    #
    #@stick_1.set_state :IdleRight
    #
    #@stick_2 = Characters::Stick1.new @entity_manager, entity2, Settings::CONTROLS['player2']
    #@stick_2.set_state :IdleRight
    #$stick_2 = @stick_2
    
    @stick_1 = Factories::Player.construct @entity_manager, 500, 500, 'player1', [0.5, 0, 0], :IdleLeft
    @stick_2 = Factories::Player.construct @entity_manager, 200, 500, 'player2', [0, 0, 0.5], :IdleRight
    #$stick_2 = @stick_2
    
    #Shaders.load
  end
  
  def button_down id
    @stick_1.button_down id
    @stick_2.button_down id
  end
  
  def button_up id
    @stick_1.button_up id
    @stick_2.button_up id
  end
  
  def update
    @stick_1.update
    @stick_2.update
    Systems::HitTest.update @entity_manager
    Systems::Sprite.update @entity_manager
  end
  
  def draw
    fill 0xFF557BC6, 0xFF4F91ED

    scale = 0.5
    scale scale, scale, width/2.0, height do
      Systems::Sprite.draw @entity_manager
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