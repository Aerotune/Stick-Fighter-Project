class Characters::Stick1V2::ControllerStates::StandingBalanceNeutralReactivesRight < Character::ControllerState
  def on_hit punch_hit_box
    case punch_hit_box.hit_direction
    when 'left'
      if punch_hit_box.strength > 1.5
        if controls.control_down? 'move left'
          set_state "StaggerBackwardRight"
        else
          set_state "FallToBackRight"
        end
      else
        set_state "PunchedFrontRight"
      end
    when 'right'
      if punch_hit_box.strength > 1.5
        if controls.control_down? 'move right'
          set_state "StaggerForwardRight"
        else
          set_state "FallToStomachRight"
        end
      else
        set_state "PunchedBehindRight"
      end
    when 'up'
      set_state "KnockupRight"
    when 'down'
      set_state "SlammedRight"
    end
  end
end