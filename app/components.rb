module Components
  Dir[File.join(File.dirname(__FILE__), *%w[components *.rb])].each { |file| require file }
end