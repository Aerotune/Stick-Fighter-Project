class Characters::Stick1V2::ControllerStates::StandingBalanceBackwardReactivesRight < Character::ControllerState
  def on_hit punch_hit_box
    case punch_hit_box.hit_direction
    when 'right'
      set_state "PunchedBehindRight"
    when 'left'
      if controls.control_down? 'move left'
        set_state "StaggerBackwardRight"
      else
        set_state "FallToBackRight"
      end
    end
  end
end