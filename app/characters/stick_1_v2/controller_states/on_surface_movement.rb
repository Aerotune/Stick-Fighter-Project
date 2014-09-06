class Characters::Stick1V2::ControllerStates::OnSurfaceMovement < Character::ControllerState
  def update_game_logic time
    animation_state_name = @character.current_animation_state.class.name
    is_crawl_speed = animation_state_name.match /Duck|Crawl/
    speed = is_crawl_speed ? 380 : 720

    case controls.latest_horizontal_move
    when 'move right'; set_velocity time, speed
    when 'move left';  set_velocity time, -speed
    else
      set_velocity time, 0
    end
  end
end