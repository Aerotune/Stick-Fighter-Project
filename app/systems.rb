module Systems
  Dir[File.join(File.dirname(__FILE__), *%w[systems *.rb])].each { |file| require file }
end