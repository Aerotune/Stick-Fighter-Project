class Stage::Level
  def initialize
    @level_assets = {}
    resource_path = File.join 'resources', 'graphics', 'map_art', 'level'
    Dir[File.join resource_path, '*.json'].each do |level_asset_file|
      meta_data = JSON.parse_file level_asset_file
        
      @level_assets[meta_data['id']] = {
        'image' => Gosu::Image.new($window, File.join(resource_path, meta_data['image'])),
        'bounding_box' => meta_data['bounding_box']
      }
    end
    
    p @level_assets
  end
  
  def update
    
  end
  
  def draw
    @level_assets['platform_1']['image'].draw 0,0,0
  end
end