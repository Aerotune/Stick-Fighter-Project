require_relative 'identifier'

class Component
  def id
    @id ||= Identifier.create_id.freeze
  end
  
  ## Define the instance method as the one from the module AttributesAsMsgpack
  #include AttributesAsMsgpack
  #define_method :to_msgpack, AttributesAsMsgpack.instance_method(:to_msgpack)
  #def self.to_msgpack *o
  #  to_s.to_msgpack *o
  #end
end