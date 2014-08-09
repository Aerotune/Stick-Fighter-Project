module Settings
  Dir[File.join(File.dirname(__FILE__), *%w[settings *.rb])].each { |file| require file }
end