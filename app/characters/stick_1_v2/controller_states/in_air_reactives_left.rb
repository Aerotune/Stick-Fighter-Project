class Characters::Stick1V2::ControllerStates::InAirReactivesLeft < Character::ControllerState
  def on_hit punch_hit_box
    set_state "InAirDizzyLeft", 'strength' => punch_hit_box.strength
  end
end