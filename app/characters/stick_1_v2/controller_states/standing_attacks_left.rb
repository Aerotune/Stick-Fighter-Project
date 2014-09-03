class Characters::Stick1V2::ControllerStates::StandingAttacksLeft < Character::ControllerState
  def control_down control
    case control
    when 'attack punch'
      if controls.control_down?('move left') && controls.time_since_control_down('move left') < 0.125
        set_state "RunningAttackLeft"
      else
        set_state "PunchLeft"
      end
    when 'move down'
      set_state "StandToDuckLeft"
    end
  end
end