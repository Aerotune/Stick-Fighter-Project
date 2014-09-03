class Characters::Stick1V2::ControllerStates::InAirNeutralLeft < Character::ControllerState
  def update_game_logic time
    if @character.hit_level_left && @character.current_animation_state.velocity_y(time) < 1400
      set_state "WallIdleLeft"
    end
  end
end