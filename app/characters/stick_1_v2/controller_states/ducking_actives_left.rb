class Characters::Stick1V2::ControllerStates::DuckingActivesLeft < Character::ControllerState
  def control_down control
    case control
    when 'attack punch'
      set_state "UppercutLeft"
    end
  end
end