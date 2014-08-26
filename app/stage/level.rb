class Stage::Level
  Dir[File.join(File.dirname(__FILE__), *%w[level *.rb])].each { |file| require file }
  
  attr_reader :objects
  
  def initialize stage
    @stage = stage
    @level_assets = {}
    
    resource_path = File.join 'resources', 'graphics', 'map_art', 'level'
    Dir[File.join resource_path, '*.json'].each do |level_asset_file|
      meta_data = JSON.parse_file level_asset_file
        
      @level_assets[meta_data['id']] = {
        'image' => Gosu::Image.new($window, File.join(resource_path, meta_data['image']), true),
        'bounding_box' => meta_data['bounding_box']
      }
    end
    
    @objects = []
    @objects << Stage::Level::Box.new(100, 500)
    @objects << Stage::Level::Box.new(350, 800)
    @objects << Stage::Level::Box.new(1250, 400)
    @objects << Stage::Level::Box.new(1000, 1200, 'width' => 1015)
    @objects << Stage::Level::Box.new(2750, 1200)
    @objects << Stage::Level::Box.new(-350, 2200, 'width' => 700)
    @objects << Stage::Level::Box.new(650, 1550, 'width' => 250)
    @objects << Stage::Level::Box.new(1000, 1800, 'width' => 3000, 'height' => 1000, 'solid' => true)
    @objects << Stage::Level::Box.new(500, 1900, 'width' => 500)
    @objects << Stage::Level::Box.new(500, 2500, 'width' => 500)
  end
  
  def update
    @objects.each &:update
  end
  
  def draw camera
    @objects.each do |object|
      object.draw camera
    end
  end
end