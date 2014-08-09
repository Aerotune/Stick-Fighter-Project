class Range
  @attributes = ["begin", "end", "exclude_end"]
  def to_msgpack *a
    {
      'class' => self.class.to_s,
      'begin' => self.begin,
      'end'   => self.end,
      'exclude_end' => exclude_end?
    }.to_msgpack *a
  end
  
  def self.msgpack_create msgpack
    new msgpack['begin'], msgpack['end'], msgpack['begin'], msgpack['exclude_end']
  end
end

module AttributesAsMsgpack
  def to_msgpack *a
    variables = {'class' => self.class.to_s}
    
    instance_variables.each do |variable_name|
      variables[variable_name] = instance_variable_get variable_name
    end
    
    variables.to_msgpack *a
  end
  
  module ClassMethods
    def msgpack_create msgpack
      instance = allocate
      msgpack.delete 'class'
            
      msgpack.each do |variable_name, variable_value|
        if variable_value.kind_of?(Hash) && variable_value.has_key?('class')
          klass = const_get variable_value['class']
          variable_value = klass.msgpack_create variable_value
        end
        instance.instance_variable_set variable_name, variable_value
      end
            
      instance
    end
  end
  
  def self.prepended base; base.extend ClassMethods end
  def self.included  base; base.extend ClassMethods end
end