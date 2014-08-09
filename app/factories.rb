module Factories
  Dir[File.join(File.dirname(__FILE__), *%w[factories *.rb])].each { |file| require file }
end