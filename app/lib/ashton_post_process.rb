class Gosu::Window
  def post_process options={}
    shaders = *options[:shaders]
    shaders << options[:shader] if options[:shader]
    z = options[:z]
    
    raise ArgumentError, "Block required" unless block_given?
    raise TypeError, "Can only process with Shaders" unless shaders.all? {|s| s.is_a? Ashton::Shader }

    # In case no shaders are passed, just run the contents of the block.
    unless shaders.size > 0
      yield
      return
    end

    buffer1 = primary_buffer
    buffer1.clear

    # Allow user to draw into a buffer, rather than the window.
    buffer1.render do
      yield
    end

    if shaders.size > 1
      buffer2 = secondary_buffer # Don't need to clear, since we will :replace.

      # Draw into alternating buffers, applying each shader in turn.
      shaders[0...-1].each do |shader|
        buffer1, buffer2 = buffer2, buffer1
        buffer1.render do
          buffer2.draw 0, 0, nil, shader: shader, mode: :replace
        end
      end
    end
    
    buffer1.draw 0, 0, nil, shader: shaders.last
    # Draw the buffer directly onto the window, utilising the (last) shader.
    
  end
  
  
  
end