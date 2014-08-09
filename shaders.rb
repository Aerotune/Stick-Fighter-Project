module Shaders
  class << self
    attr_reader :tint
  
    def load
      return if @loaded
      @loaded = true
      @tint = Ashton::Shader.new(fragment: 'shaders/tint.frag', uniforms: {color: [0,0,0]})
    end
  end
end