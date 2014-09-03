class Characters::Stick1V2::ControllerStates::InAirAttacksRight < Character::ControllerState
  def control_down control
    case control
    when 'attack punch'
      case controls.latest_move
      when "move up"
        if controls.time_since_control_down('move up') < 0.125
          set_state "InAirKickUpRight"
        else
          set_state "InAirPunchRight"
        end
      when "move right"
        if controls.time_since_control_down('move right') < 0.125
          set_state "InAirKickRight"
        else
          set_state "InAirPunchRight"
        end
      else
        if controls.control_down?("move down")
          set_state "InAirAttackDownRight"
        else
          set_state "InAirPunchRight"
        end
      end
    end
  end
end