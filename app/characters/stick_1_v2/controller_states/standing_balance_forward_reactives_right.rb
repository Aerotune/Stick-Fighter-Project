class Characters::Stick1V2::ControllerStates::StandingBalanceForwardReactivesRight < Character::ControllerState
  def on_hit punch_hit_box
    case punch_hit_box.hit_direction
    when 'right'
      if controls.control_down? 'move right'
        set_state "StaggerForwardRight"
      else
        set_state "FallToStomachRight"
      end
    when 'left'
      set_state "PunchedFrontRight"
    when 'up'
      set_state "KnockupRight"
    when 'down'
      set_state "SlammedRight"
    end
  end
end