class Characters::Stick1V2::ControllerStates::InAirNeutralRight < Character::ControllerState
  def update_game_logic time
    if @character.hit_level_right && @character.current_animation_state.velocity_y(time) < 1400
      set_state "WallIdleRight"
    end
  end
end