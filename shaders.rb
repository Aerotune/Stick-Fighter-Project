module Shaders
  class << self
    attr_reader :tint, :blur_horizontal, :blur_vertical, :darken
  
    def load
      return if @loaded
      @loaded = true
      @tint = Ashton::Shader.new(fragment: 'shaders/tint.frag', uniforms: {color: [0,0,0]})
      @blur_horizontal = Ashton::Shader.new(fragment: 'shaders/blur_horizontal.frag', uniforms: {width: 1000})
      @blur_vertical   = Ashton::Shader.new(fragment: 'shaders/blur_vertical.frag', uniforms: {height: 600})
    end
    
    def set_blur strength
      strength = 0 if strength < 0
      strength = 1 if strength > 1
      factor = 9-strength**0.06*8.6
      @blur_horizontal[:width] = 1000*factor
      @blur_vertical[:height] = 600*factor
    end
  end
end