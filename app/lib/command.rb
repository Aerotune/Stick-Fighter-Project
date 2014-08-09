require_relative 'identifier'

class Command
  
  def id
    @id ||= Identifier.create_id.freeze
  end
  
  def done?
    !!@done
  end
  
  def do_action;         raise "Must be overriden in subclass"  end
  def undo_action;       raise "Must be overriden in subclass"  end
  
  def do!
    return self if @done
    do_action
    @done = true
    self
  end
  
  def undo!
    return self unless @done
    undo_action
    @done = false
    self
  end
  
end
