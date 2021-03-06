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
    @objects << Stage::Level::Box.new(100,  500  - 1000)
    @objects << Stage::Level::Box.new(350,  800  - 1000)
    @objects << Stage::Level::Box.new(1250, 400  - 1000)
    @objects << Stage::Level::Box.new(1000, 1200 - 1000, 'width' => 1015)
    @objects << Stage::Level::Box.new(2750, 1200 - 1000)
    @objects << Stage::Level::Box.new(2450,  100 - 1000, 'width' => 700, 'height' => 600, 'solid' => true)
    @objects << Stage::Level::Box.new(-350, 2200 - 1000, 'width' => 700)
    @objects << Stage::Level::Box.new(650,  1550 - 1000, 'width' => 250)
    @objects << Stage::Level::Box.new(1000, 1800 - 1000, 'width' => 3000, 'height' => 3000, 'solid' => true)
    @objects << Stage::Level::Box.new(3500,  500 - 1000, 'width' => 2000, 'height' => 1000, 'solid' => true)
    @objects << Stage::Level::Box.new(4100,  400 - 2000, 'width' => 200, 'height' => 1000, 'solid' => true)
    @objects << Stage::Level::Box.new(3500,  100 - 1000)
    @objects << Stage::Level::Box.new(500,  1900 - 1000, 'width' => 500)
    @objects << Stage::Level::Box.new(500,  2500 - 1000, 'width' => 500)
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