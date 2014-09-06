class Characters::Stick1V2::ControllerStates::DuckingActivesRight < Character::ControllerState
  def control_down control
    case control
    when 'attack punch'
      set_state "UppercutRight"
    end
  end
end