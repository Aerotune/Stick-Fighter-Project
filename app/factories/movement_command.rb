module Factories::MovementCommand
  def self.construct entity_manager, entity, time, options
    if options['on_surface']
      velocity = options['velocity'] || 0
      Commands::SetMovementInLine.new(entity_manager, entity, velocity, time, options)
    else
      if entity_manager.get_component(entity, Components::Movement).movement.class == MovementInAir
        if options['start_velocity_y'] || options['start_velocity_x']
          start_velocity_y = options['start_velocity_y']
          start_velocity_x = options['start_velocity_x']
          Commands::SetMovementInAir.new(entity_manager, entity, start_velocity_x, start_velocity_y, time)
        end
      else
        start_velocity_y = options['start_velocity_y']
        start_velocity_x = options['start_velocity_x']
        Commands::SetMovementInAir.new(entity_manager, entity, start_velocity_x, start_velocity_y, time)
      end
    end
  end
end