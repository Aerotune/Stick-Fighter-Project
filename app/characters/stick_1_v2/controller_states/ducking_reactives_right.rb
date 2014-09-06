class Characters::Stick1V2::ControllerStates::DuckingReactivesRight < Character::ControllerState
  def on_hit punch_hit_box
    case punch_hit_box.hit_direction
    when 'right'
      set_state "FallToStomachRight"
    when 'left'
      set_state "FallToBackRight"
    when 'up'
      set_state "KnockupRight"
    when 'down'
      set_state "SlammedRight"
    end
  end
end