module SoundResource
  class << self
    def load
      @lands = [
        Gosu::Sample.new($window, 'resources/sound/sfx/land/land1.ogg'),
        Gosu::Sample.new($window, 'resources/sound/sfx/land/land2.ogg'),
        Gosu::Sample.new($window, 'resources/sound/sfx/land/land3.ogg'),
        Gosu::Sample.new($window, 'resources/sound/sfx/land/land4.ogg'),
        Gosu::Sample.new($window, 'resources/sound/sfx/land/land5.ogg'),
        Gosu::Sample.new($window, 'resources/sound/sfx/land/land6.ogg')     
      ]
      @jumps = [
        Gosu::Sample.new($window, 'resources/sound/sfx/jump/jump1.ogg'),
        Gosu::Sample.new($window, 'resources/sound/sfx/jump/jump2.ogg'),
        Gosu::Sample.new($window, 'resources/sound/sfx/jump/jump3.ogg')
      ]
      @wind = Gosu::Sample.new($window, 'resources/sound/sfx/wind/156414__felix-blume__wind-blowing-into-some-cactus-spine-on-the-top-of-the-mountain-in-the-desert-of-atacama-chile.ogg')
      @run_loop = Gosu::Sample.new($window, 'resources/sound/sfx/run_loop.ogg')
      @run_loop_instances = []
      @slide = Gosu::Sample.new($window, 'resources/sound/sfx/slide.ogg')
      @punch_swooshes = [
        Gosu::Sample.new($window, 'resources/sound/sfx/punch_swoosh/1.ogg'),
        Gosu::Sample.new($window, 'resources/sound/sfx/punch_swoosh/2.ogg'),
        Gosu::Sample.new($window, 'resources/sound/sfx/punch_swoosh/3.ogg'),
        Gosu::Sample.new($window, 'resources/sound/sfx/punch_swoosh/4.ogg'),
        Gosu::Sample.new($window, 'resources/sound/sfx/punch_swoosh/5.ogg'),
        Gosu::Sample.new($window, 'resources/sound/sfx/punch_swoosh/6.ogg'),
        Gosu::Sample.new($window, 'resources/sound/sfx/punch_swoosh/7.ogg'),
        Gosu::Sample.new($window, 'resources/sound/sfx/punch_swoosh/8.ogg'),
        Gosu::Sample.new($window, 'resources/sound/sfx/punch_swoosh/9.ogg') 
      ]
      
      @punched = [
        Gosu::Sample.new($window, 'resources/sound/sfx/punched/114683__qat__whack02.ogg'),
        Gosu::Sample.new($window, 'resources/sound/sfx/punched/100397__zgump__snare-05.ogg'),
        Gosu::Sample.new($window, 'resources/sound/sfx/punched/193023__oceanictrancer__house-snare.ogg')
      ]
      @falls = [
        Gosu::Sample.new($window, 'resources/sound/sfx/fall/1.ogg'),
        Gosu::Sample.new($window, 'resources/sound/sfx/fall/2.ogg'),
        Gosu::Sample.new($window, 'resources/sound/sfx/fall/3.ogg'),
        Gosu::Sample.new($window, 'resources/sound/sfx/fall/4.ogg'),
        Gosu::Sample.new($window, 'resources/sound/sfx/fall/5.ogg'),
        Gosu::Sample.new($window, 'resources/sound/sfx/fall/6.ogg'),
        Gosu::Sample.new($window, 'resources/sound/sfx/fall/7.ogg')  
      ]
    end
    
    def play id, volume=1.0, speed=1.0
      case id
      when 'land'
        @lands[rand(@lands.length)].play volume, speed+(rand-0.5)*0.25, false
      when 'wind'
        @wind_instance ||= @wind.play volume, speed, true
        @wind_instance.volume = volume
        @wind_instance.speed  = speed
      when 'jump'
        @jumps[rand(@jumps.length)].play volume, speed*(1+(rand-0.5)*0.25), false
      when 'run_loop'
        @run_loop.play(volume*0.8, 1.0, true)
      when 'slide'
        @slide.play volume*0.7, speed, false
      when 'punch'
        @punch_swooshes[rand(@punch_swooshes.length)].play volume*0.8, speed+(rand-0.25)*0.25, false
      when 'punched'
        @punched[rand(@punched.length)].play volume*0.1, speed-(rand)*0.4, false
      when 'fall'
        @falls[rand(@falls.length)].play volume, speed, false
      end
    end
    
    def stop id
      case id
      when 'wind'
        @wind_instance.stop if @wind_instance
      end
    end
  end
end