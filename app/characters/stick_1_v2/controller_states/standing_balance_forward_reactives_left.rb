class Characters::Stick1V2::ControllerStates::StandingBalanceForwardReactivesLeft < Character::ControllerState
  def on_hit punch_hit_box
    case punch_hit_box.hit_direction
    when 'left'
      if controls.control_down? 'move left'
        set_state "StaggerForwardLeft"
      else
        set_state "FallToStomachLeft"
      end
    when 'right'
      set_state "PunchedFrontLeft"
    when 'up'
      set_state "KnockupLeft"
    when 'down'
      set_state "SlammedLeft"
    end
  end
end