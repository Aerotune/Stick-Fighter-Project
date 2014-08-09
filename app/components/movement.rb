class Components::Movement < Component
  attr_accessor :movement
  def initialize movement
    super()
    @movement = movement
  end
end