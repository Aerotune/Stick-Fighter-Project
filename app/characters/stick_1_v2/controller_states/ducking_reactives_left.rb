class Characters::Stick1V2::ControllerStates::DuckingReactivesLeft < Character::ControllerState
  def on_hit punch_hit_box
    case punch_hit_box.hit_direction
    when 'left'
      set_state "FallToStomachLeft"
    when 'right'
      set_state "FallToBackLeft"
    when 'up'
      set_state "KnockupLeft"
    when 'down'
      set_state "SlammedLeft"
    end
  end
end