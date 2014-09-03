class Characters::Stick1V2::ControllerStates::OnSurfaceMovement < Character::ControllerState
  def update_game_logic time
    case controls.latest_horizontal_move
    when 'move right'; set_velocity time, 520
    when 'move left';  set_velocity time, -520
    else
      set_velocity time, 0
    end
  end
end