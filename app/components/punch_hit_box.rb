require_relative 'hit_box'
class Components::PunchHitBox < Components::HitBox
  attr_reader :hit_direction, :strength, :hit_entities
  
  def initialize hit_direction, strength, *args
    @hit_direction = hit_direction
    @strength = strength
    @hit_entities = []
    super *args
  end
end