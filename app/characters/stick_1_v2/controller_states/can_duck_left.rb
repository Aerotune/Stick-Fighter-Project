class Characters::Stick1V2::ControllerStates::CanDuckLeft < Character::ControllerState
  def control_down control
    case control
    when 'move down'
      set_state "StandToDuckLeft"
    end
  end
end