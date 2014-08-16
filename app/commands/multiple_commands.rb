class Commands::MultipleCommands < Command  
  def initialize commands
    @commands = commands
  end
  
  def do_action
    @commands.each &:do!
  end
  
  def undo_action
    @commands.each &:undo!
  end
end