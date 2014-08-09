require_relative 'character'

module Characters
  Dir[File.join(File.dirname(__FILE__), *%w[characters *.rb])].each { |file| require file }
end