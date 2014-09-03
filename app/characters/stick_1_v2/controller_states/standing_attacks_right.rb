class Characters::Stick1V2::ControllerStates::StandingAttacksRight < Character::ControllerState
  def control_down control
    case control
    when 'attack punch'
      if controls.control_down?('move right') && controls.time_since_control_down('move right') < 0.125
        set_state "RunningAttackRight"
      else
        set_state "PunchRight"
      end
    end
  end
end