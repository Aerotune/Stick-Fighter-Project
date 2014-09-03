class Characters::Stick1V2::ControllerStates::InAirAttacksLeft < Character::ControllerState
  def control_down control
    case control
    when 'attack punch'
      case controls.latest_move
      when "move up"
        if controls.time_since_control_down('move up') < 0.125
          set_state "InAirKickUpLeft"
        else
          set_state "InAirPunchLeft"
        end
      when "move left"
        if controls.time_since_control_down('move left') < 0.125
          set_state "InAirKickLeft"
        else
          set_state "InAirPunchLeft"
        end
      else
        if controls.control_down?("move down")
          set_state "InAirAttackDownLeft"
        else
          set_state "InAirPunchLeft"
        end
      end
    end
  end
end