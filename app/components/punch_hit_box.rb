require_relative 'hit_box'
class Components::PunchHitBox < Components::HitBox
  attr_reader :punch_direction
  
  def initialize punch_direction, *args
    @punch_direction = punch_direction
    super *args
  end
end