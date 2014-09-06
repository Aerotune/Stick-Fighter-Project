class Characters::Stick1V2::ControllerStates::StandingBalanceNeutralReactivesLeft < Character::ControllerState
  def on_hit punch_hit_box
    case punch_hit_box.hit_direction
    when 'right'
      if punch_hit_box.strength > 1.5
        if controls.control_down? 'move right'
          set_state "StaggerBackwardLeft"
        else
          set_state "FallToBackLeft"
        end
      else
        set_state "PunchedFrontLeft"
      end
    when 'left'
      if punch_hit_box.strength > 1.5
        if controls.control_down? 'move left'
          set_state "StaggerForwardLeft"
        else
          set_state "FallToStomachLeft"
        end
      else
        set_state "PunchedBehindLeft"
      end
    when 'up'
      set_state "KnockupLeft"
    when 'down'
      set_state "SlammedLeft"
    end
  end
end