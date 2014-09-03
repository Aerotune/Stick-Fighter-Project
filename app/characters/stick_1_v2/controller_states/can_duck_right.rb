class Characters::Stick1V2::ControllerStates::CanDuckRight < Character::ControllerState
  def control_down control
    case control
    when 'move down'
      set_state "StandToDuckRight"
    end
  end
end