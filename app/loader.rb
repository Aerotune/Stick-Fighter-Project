class Loader
  attr_reader :loaded
  
  def initialize
    @font = Gosu::Font.new $window, "Arial", 18
  end
  
  def load
    require_relative File.join('..', 'shaders')
    require_relative File.join('..', 'settings')

    Dir[File.join(File.dirname(__FILE__), *%w[lib *.rb])].each { |file| require file }
    Dir[File.join(File.dirname(__FILE__), *%w[*.rb])]    .each { |file| require file }
    
    Shaders.load
    LenseFlare.load_images $window, 'resources/graphics/lense_flare/'
    Stage::Background.load
    Characters.constants.each do |character_constant|
      Characters.const_get(character_constant).require_image_resource
    end
    SoundResource.load
  end
  
  def update
    if @has_drawn && !@loaded
      @loaded = true
      load
      $window.reset_stage
    end
  end
  
  def draw
    @font.draw "Loading...", $window.width/2.0-30, $window.height/2.0, 0
    @has_drawn = true
  end
end