class Characters::Stick1 < Character
  Dir[File.join(File.dirname(__FILE__), *%w[stick_1 *.rb])].each { |file| require file }
  spritesheets_folder 'resources', 'images', 'stick_1_v1'
end