class Characters::Stick1V2::ControllerStates::DuckingReactivesLeft < Character::ControllerState
  def on_hit punch_hit_box
    case punch_hit_box.hit_direction
    when 'left'
      set_state "FallToStomachLeft"
    when 'right'
      set_state "FallToBackLeft"
    end
  end
end