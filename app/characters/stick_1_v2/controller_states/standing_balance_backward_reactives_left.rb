class Characters::Stick1V2::ControllerStates::StandingBalanceBackwardReactivesLeft < Character::ControllerState
  def on_hit punch_hit_box
    case punch_hit_box.hit_direction
    when 'left'
      set_state "PunchedBehindLeft"
    when 'right'
      if controls.control_down? 'move right'
        set_state "StaggerBackwardLeft"
      else
        set_state "FallToBackLeft"
      end
    end
  end
end