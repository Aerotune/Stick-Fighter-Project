require 'gosu'
require 'ashton'

class Window < Gosu::Window
  def initialize
    super 800, 600, false
    
    @image = Gosu::Image.new self, 'resources/graphics/map_art/background/pyramide_1.png'
    @bloom = Ashton::Shader.new(fragment: 'shaders/bloom_horizontal.frag', width: 800, strength: 0.5)
    #@blur_horizontal = Ashton::Shader.new(fragment: 'shaders/blur_horizontal.frag', uniforms: {width: @image.width*0.25})
    #@blur_vertical   = Ashton::Shader.new(fragment: 'shaders/blur_vertical.frag', uniforms: {height: @image.height*0.25})
  end
  
  
  def draw
    #blurs = []
    #blurs += [@blur_horizontal] * 3
    #blurs += [@blur_vertical] * 3
    #post_process *blurs do
    #  @image.draw mouse_x,mouse_y,0, 0.2, 0.2
    #end
    
    post_process @bloom do
      @image.draw mouse_x,mouse_y,0, 0.2, 0.2
    end
  end
end

Window.new.show