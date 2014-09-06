class Characters::Stick1V2::AnimationStates::InAirDizzyRight < Character::State
  attr_reader :components
  
  def initialize character
    @character = character
    @duration = 0.4
    @sprite_sheet_id = 'in_air_dizzy'
    @sprite_options = {'factor_x' => -1, 'duration' => @duration}
    @movement_options = {'on_surface' => false}
  end
  
  def on_set options
    @dizzy_duration = options['strength'] * @duration
    SoundResource.play 'punched' unless options['squelch']
  end
  
  def update_game_logic time 
    local_time = time - @state_set_time
       
    if @character.hit_level_down
      animation_time = local_time % @duration
      if animation_time > @duration * 0.1 && animation_time < @duration * 0.75
        set_state "FallToBackRight", 'start_y' => @character.hit_level_down, 'squelch' => true
      else
        set_state "LandRight", 'start_y' => @character.hit_level_down
      end
    else
      if local_time > @dizzy_duration
        set_state 'InAirRight'
      else
        case controls.latest_horizontal_move
        when 'move right'
          set_in_air_velocity_x time, 720
        when 'move left'
          set_in_air_velocity_x time, -720
        else
          set_in_air_velocity_x time, 0
        end
      end
    end
  end
end