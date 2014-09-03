class Characters::Stick1V2::ControllerStates::InAirReactivesRight < Character::ControllerState
  def on_hit punch_hit_box
    set_state "InAirDizzyRight", 'strength' => punch_hit_box.strength
  end
end