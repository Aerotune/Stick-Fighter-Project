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
    @objects << Stage::Level::Platform.new(@level_assets['platform_1'], 100, 500)
    @objects << Stage::Level::Platform.new(@level_assets['platform_1'], 350, 800)
    @objects << Stage::Level::Platform.new(@level_assets['platform_1'], 1250, 400)
    @objects << Stage::Level::Platform.new(@level_assets['platform_1'], 1000, 1200)
    @objects << Stage::Level::Platform.new(@level_assets['platform_1'], 1500, 1200)
    @objects << Stage::Level::Platform.new(@level_assets['platform_1'], 2750, 1200)
    
    @objects << Stage::Level::Platform.new(@level_assets['platform_1'], 50, 1800)
    @objects << Stage::Level::Platform.new(@level_assets['platform_1'], 750, 1600)
    @objects << Stage::Level::Platform.new(@level_assets['platform_1'], 1000, 1800)
    @objects << Stage::Level::Platform.new(@level_assets['platform_1'], 1500, 1800)
    @objects << Stage::Level::Platform.new(@level_assets['platform_1'], 2000, 1800)
    @objects << Stage::Level::Platform.new(@level_assets['platform_1'], 2500, 1800)
    @objects << Stage::Level::Platform.new(@level_assets['platform_1'], 3000, 1800)
    
    @objects << Stage::Level::Platform.new(@level_assets['platform_1'], 500, 1900)
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