 
=begin
 
 New Character Properties with Calls 2.2
 by PK8
 Created: 5/12/2009
 Modified: 6/11/2012
 ──────────────────────────────────────────────────────────────────────────────
 ■ Author's Notes
   I wanted to work on letting game creators animate character sprites a little
   more through script calls. I noticed certain properties such as angle, color,
   mirror, tone, and angle were missing so I wanted to add them in.
 ──────────────────────────────────────────────────────────────────────────────
 ■ Introduction & Description
   This script adds additional properties from the Sprite class to
   Game_Character such as angle, color, mirror, tone, zoom_x, and zoom_y.
   For this version, I also combined my Event Angle/Color/Mirror/Tone/Zoom
   add-ons and my script calls with this script.
 ──────────────────────────────────────────────────────────────────────────────
 ■ Features
   o This gives Character sprites additional properties from the Sprite class
     such as Angle, Color, Mirror, Tone, Zoom, and Wave.
   o Change the angle, color, mirror, tone, and zoom of a character sprite using
     script calls.
   o Set Angle, Color, Mirror, Tone, Zoom, and Wave of Events using special
     comments.
   o Change certain properties of a character sprite to a desired value in a
     certain number of frames with a script call.
 ──────────────────────────────────────────────────────────────────────────────
 ■ Methods Aliased
   Sprite_Character.update
   Game_Character.initialize
   Game_Character.update
   Game_Event.refresh
 ──────────────────────────────────────────────────────────────────────────────
 ■ Thanks
   Charlie Fleed showed me how to create these special comments a few years ago.
   This one is more of a shoutout than a thanks. Okay, it's a bit of both. I'd
     like to send a shoutout to Prof. Meow Meow who showed me a demo of his a
     few years ago making use of a previous version of this script. I thought
     it was an awesome experience being able to see how other people would use
     it, and I enjoyed how Prof. Meow Meow made use of it. So hey Prof., if
     you're still RMing, thanks.
 ──────────────────────────────────────────────────────────────────────────────
 ■ Changelog (MM/DD/YYYY)
 v1     (05/10/2009): Initial release.
 v1.1   (05/10/2009): Replaced attr_reader with attr_accessor.
 v1.2   (05/12/2009): Replaced initial zoom_x/zoom_y value of 1.0 with 100
 v2     (04/14/2012): Combines Event Angle/Color/Mirror/Tone/Zoom and
                      changing properties in frames but throws in various
                      new calls to the mix while some of them are renamed,
                      such as sizex_change => zoom_x_change.
 v2.1   (04/15/2012): Added relative arguments for all methods.
 v2.1.1 (06/11/2012): Reduced the lines of code by about about a hundred, and
                      added new instance variables that can be written into via
                      script calls such as the @*_target and @*_duration
                      variables.
 v2.2   (06/11/2012): Users can now use Arrays when changing Tones and Colors of
                      characters via script calls.
                      (Example: $game_player.tone = [0, -255, 0, 120])
 ──────────────────────────────────────────────────────────────────────────────
 ■ Usage
 ┌──────────────────────────────────────────────────────────────────────────┐
 │ ■ Adjusting Character Sprites.                                           │
 └┬───────────────┬─────────────────────────────────────────────────────────┘
  │ Setting Angle │
  └───────────────┘
              Syntax
   Player:    $game_player.angle = value
   Event:     $game_map.events[id].angle = value
   Vehicle:   $game_map.vehicle[id].angle = value
   
              Examples
   Player:    $game_player.angle = 90
   Event:     $game_map.events[1].angle = 90
   Vehicle:   $game_map.vehicle[1].angle = 90
   
 └┬───────────────┬─────────────────────────────────────────────────────────┘
  │ Setting Color │
  └───────────────┘
              Min/Max values
   r/g/b:     0/255
   alpha:     0/255 (Optional)
 
              Syntax (All channels)
   Player:    $game_player.color = Color.new(red, green, blue[, alpha])
   Event:     $game_map.events[id].color = Color.new(red, green, blue[, alpha])
   Vehicle:   $game_map.vehicle[id].color = Color.new(red, green, blue[, alpha])
   
              Examples (All: without Alpha)
   Player:    $game_player.color = Color.new(255, 255, 255)
   Event:     $game_map.events[1].color = Color.new(255, 255, 255)
   Vehicle:   $game_map.vehicle[1].color = Color.new(255, 255, 255)
              
              Examples (All: with Alpha)
   Player:    $game_player.color = Color.new(255, 255, 255, 255)
   Event:     $game_map.events[1].color = Color.new(255, 255, 255, 255)
   Vehicle:   $game_map.vehicle[1].color = Color.new(255, 255, 255, 255)
 
              Syntax (Specific)
   Player:    $game_player.color.red = value
   Player:    $game_player.color.green = value
   Player:    $game_player.color.blue = value
   Player:    $game_player.color.alpha = value
   
   Event:     $game_map.events[id].color.red = value
   Event:     $game_map.events[id].color.green = value
   Event:     $game_map.events[id].color.blue = value
   Event:     $game_map.events[id].color.alpha = value
   
   Vehicle:   $game_map.vehicle[id].color.red = value
   Vehicle:   $game_map.vehicle[id].color.green = value
   Vehicle:   $game_map.vehicle[id].color.blue = value
   Vehicle:   $game_map.vehicle[id].color.alpha = value
   
              Examples (Specific)
   Player:    $game_player.color.red = 60
   Player:    $game_player.color.green = 120
   Player:    $game_player.color.blue = 180
   Player:    $game_player.color.alpha = 255
   
   Event:     $game_map.events[1].color.red = 60
   Event:     $game_map.events[1].color.green = 120
   Event:     $game_map.events[1].color.blue = 180
   Event:     $game_map.events[1].color.alpha = 255
   
   Vehicle:   $game_map.vehicle[1].color.red = 60
   Vehicle:   $game_map.vehicle[1].color.green = 120
   Vehicle:   $game_map.vehicle[1].color.blue = 180
   Vehicle:   $game_map.vehicle[1].color.alpha = 255
 
 └┬────────────────┬────────────────────────────────────────────────────────┘
  │ Setting Mirror │
  └────────────────┘
              Values
   true:      Turns Mirror on.
   false:     Turns Mirror off.
  
              Syntax
   Player:    $game_player.mirror = value
   Event:     $game_map.events[id].mirror = value
   Vehicle:   $game_map.vehicle[id].mirror = value
  
              Examples
   Player:    $game_player.mirror = true
   Event:     $game_map.events[1].mirror = true
   Vehicle:   $game_map.vehicle[1].mirror = true
  
 └┬──────────────┬──────────────────────────────────────────────────────────┘
  │ Setting Tone │
  └──────────────┘
              Min/Max values
   r/g/b:     -255/255
   gray:      0/255 (Optional)
   
              Syntax (All)
   Player:    $game_player.tone = Tone.new(red, green, blue[, gray])
   Event:     $game_map.events[id].tone = Tone.new(red, green, blue[, gray])
   Vehicle:   $game_map.vehicle[id].tone = Tone.new(red, green, blue[, gray])
   
              Examples (All: without Gray)
   Player:    $game_player.tone = Tone.new(255, 255, 255)
   Event:     $game_map.events[1].tone = Tone.new(255, 255, 255)
   Vehicle:   $game_map.vehicle[1].tone = Tone.new(255, 255, 255)
              
              Examples (All: with Gray)
   Player:    $game_player.tone = Tone.new(255, 255, 255, 255)
   Event:     $game_map.events[1].tone = Tone.new(255, 255, 255, 255)
   Vehicle:   $game_map.vehicle[1].tone = Tone.new(255, 255, 255, 255)
 
              Syntax (Specific)
   Player:    $game_player.tone.red = value
   Player:    $game_player.tone.green = value
   Player:    $game_player.tone.blue = value
   Player:    $game_player.tone.gray = value
   
   Event:     $game_map.events[id].tone.red = value
   Event:     $game_map.events[id].tone.green = value
   Event:     $game_map.events[id].tone.blue = value
   Event:     $game_map.events[id].tone.gray = value
   
   Vehicle:   $game_map.vehicle[id].tone.red = value
   Vehicle:   $game_map.vehicle[id].tone.green = value
   Vehicle:   $game_map.vehicle[id].tone.blue = value
   Vehicle:   $game_map.vehicle[id].tone.gray = value
   
              Examples (Specific)
   Player:    $game_player.tone.red = 60
   Player:    $game_player.tone.green = 120
   Player:    $game_player.tone.blue = 180
   Player:    $game_player.tone.gray = 255
   
   Event:     $game_map.events[1].tone.red = 60
   Event:     $game_map.events[1].tone.green = 120
   Event:     $game_map.events[1].tone.blue = 180
   Event:     $game_map.events[1].tone.alpha = 255
   
   Vehicle:   $game_map.vehicle[1].tone.red = 60
   Vehicle:   $game_map.vehicle[1].tone.green = 120
   Vehicle:   $game_map.vehicle[1].tone.blue = 180
   Vehicle:   $game_map.vehicle[1].tone.alpha = 255
  
 └┬──────────────┬──────────────────────────────────────────────────────────┘
  │ Setting Zoom │
  └──────────────┘
              Values
   100:       Denotes actual pixel size
  
              Syntax
   Player:    $game_player.zoom_x = value
   Player:    $game_player.zoom_y = value
   
   Event:     $game_map.events[id].zoom_x = value
   Event:     $game_map.events[id].zoom_y = value
   
   Vehicle:   $game_map.vehicle[id].zoom_x = value
   Vehicle:   $game_map.vehicle[id].zoom_y = value
  
              Examples
   Player:    $game_player.zoom_x = 125
   Player:    $game_player.zoom_y = 125
   
   Event:     $game_map.events[1].zoom_x = 125
   Event:     $game_map.events[1].zoom_y = 125
   
   Vehicle:   $game_map.vehicle[1].zoom_x = 125
   Vehicle:   $game_map.vehicle[1].zoom_y = 125
 
 └┬──────────────┬──────────────────────────────────────────────────────────┘
  │ Setting Wave │
  └──────────────┘
              Values
  Wave Length: Minimum is 2
  
              Syntax
  Player:     $game_player.wave_amp = value
  Player:     $game_player.wave_length = value
  Player:     $game_player.wave_speed = value
  
  Event:      $game_map.events[id].wave_amp = value
  Event:      $game_map.events[id].wave_length = value
  Event:      $game_map.events[id].wave_speed = value
  
  Vehicle:    $game_map.vehicle[id].wave_amp = value
  Vehicle:    $game_map.vehicle[id].wave_length = value
  Vehicle:    $game_map.vehicle[id].wave_speed = value
  
 ┌──────────────────────────────────────────────────────────────────────────┐
 │ ■ Special Comments for Events                                            │
 └──────────────────────────────────────────────────────────────────────────┘
   You get to set up how events would appear.
 
   Angle:       $angle value
   Color:       $color red green blue alpha
   Color Red:   $color_red value
   Color Green: $color_green value
   Color Blue:  $color_blue value
   Color Alpha: $color_alpha value
     * Red/Green/Blue/Alpha: 0/255
   Mirror:      $mirror
   Mirror False:$mirror false
   Mirror True: $mirror true
   Tone:        $tone red green blue gray
   Tone Red:    $tone red
   Tone Green:  $tone green
   Tone Blue:   $tone blue
   Tone Gray:   $tone gray
     * Red/Green/Blue: -255/255 | Gray: 0/255
   Zoom:        $zoom zoom_x zoom_y
   Zoom X:      $zoom_x value
   Zoom Y:      $zoom_y value
     * 100: Denotes actual pixel size
   Wave Amp:    $wave_amp value
   Wave Length: $wave_length value
     * Minimum value: 2
   Wave Speed:  $wave_speed value
   
 ┌──────────────────────────────────────────────────────────────────────────┐
 │ ■ Changing properties in frames                                          │
 └┬─────────────────────────┬───────────────────────────────────────────────┘
  │ Setting Angle in frames │
  └─────────────────────────┘
  Player:     $game_player.angle_change(value, duration, relative)
  Event:      $game_map.events[id].angle_change(value, duration, relative)
  Vehicle:    $game_map.vehicle[id].angle_change(value, duration, relative)
  * relative: Optional. Set to false by default.
  
 └┬─────────────────────────┬───────────────────────────────────────────────┘
  │ Setting Color in frames │
  └─────────────────────────┘
              Syntax (All)
  Player:     $game_player.color_change([red, green, blue, alpha], duration,
              relative)
  Event:      $game_map.events[id].color_change([red, green, blue, alpha]),
              duration, relative)
  Vehicle:    $game_map.events[id].color_change([red, green, blue, alpha],
              duration, relative)
  * alpha: 0 - 255. Optional.
  * relative: Optional. Set to false by default.
                
              Syntax (Specific)
  Player:     $game_player.color_red_change(value, duration, rel)
  Player:     $game_player.color_green_change(value, duration, rel)
  Player:     $game_player.color_blue_change(value, duration, rel)
  Player:     $game_player.color_alpha_change(value, duration, rel)
  
  Event:      $game_map.events[id].color_red_change(value, duration, rel)
  Event:      $game_map.events[id].color_green_change(value, duration, rel)
  Event:      $game_map.events[id].color_blue_change(value, duration, rel)
  Event:      $game_map.events[id].color_alpha_change(value, duration, rel)
  
  Vehicle:    $game_map.vehicle[id].color_red_change(value, duration, rel)
  Vehicle:    $game_map.vehicle[id].color_green_change(value, duration, rel)
  Vehicle:    $game_map.vehicle[id].color_blue_change(value, duration, rel)
  Vehicle:    $game_map.vehicle[id].color_alpha_change(value, duration, rel)
  * relative: Optional. Set to false by default.
  
 └┬────────────────────────┬────────────────────────────────────────────────┘
  │ Setting Tone in Frames │
  └────────────────────────┘
              Syntax (All)
  Player:     $game_player.tone_change([red, green, blue, gray], duration,
              relative)
  Event:      $game_map.events[id].tone_change([red, green, blue, gray],
              duration, relative)
  Vehicle:    $game_map.vehicle[id].tone_change([red, green, blue, gray],
              duration, relative)
  * gray: 0 - 255. Optional.
  * relative: Optional. Set to false by default.
                
              Syntax (Specific)
  Player:     $game_player.tone_red_change(value, duration, rel)
  Player:     $game_player.tone_green_change(value, duration, rel)
  Player:     $game_player.tone_blue_change(value, duration, rel)
  Player:     $game_player.tone_gray_change(value, duration, rel)
  
  Event:      $game_map.events[id].tone_red_change(value, duration, rel)
  Event:      $game_map.events[id].tone_green_change(value, duration, rel)
  Event:      $game_map.events[id].tone_blue_change(value, duration, rel)
  Event:      $game_map.events[id].tone_gray_change(value, duration, rel)
  
  Vehicle:    $game_map.vehicle[id].tone_red_change(value, duration, rel)
  Vehicle:    $game_map.vehicle[id].tone_green_change(value, duration, rel)
  Vehicle:    $game_map.vehicle[id].tone_blue_change(value, duration, rel)
  Vehicle:    $game_map.vehicle[id].tone_gray_change(value, duration, rel)
  * relative: Optional. Set to false by default.
  
 └┬────────────────────────┬────────────────────────────────────────────────┘
  │ Setting Zoom in Frames │
  └────────────────────────┘
              Syntax (All)
  Player:     $game_player.zoom_change(zoom_x, zoom_y, duration, rel)
  Event:      $game_map.events[id].zoom_change(zoom_x, zoom_y, duration, rel)
  Vehicle:    $game_map.vehicle[id].zoom_change(zoom_x, zoom_y, duration, rel)
  * relative: Optional. Set to false by default.
  
              Syntax (Specific)
  Player:     $game_player.zoom_x_change(value, duration, rel)
  Player:     $game_player.zoom_y_change(value, duration, rel)
  
  Event:      $game_map.events[id].zoom_x_change(value, duration, rel)
  Event:      $game_map.events[id].zoom_y_change(value, duration, rel)
  
  Vehicle:    $game_map.vehicle[id].zoom_x_change(value, duration, rel)
  Vehicle:    $game_map.vehicle[id].zoom_y_change(value, duration, rel)
  * relative: Optional. Set to false by default.
 
 └┬────────────────────────┬────────────────────────────────────────────────┘
  │ Setting Wave in Frames │
  └────────────────────────┘
              Syntax (Wave Amplitude)
  Player:     $game_player.wave_amp_change(value, duration, rel)
  Event:      $game_map.events[id].wave_amp_change(value, duration, rel)
  Vehicle:    $game_map.vehicle[id].wave_amp_change(value, duration, rel)
  
              Syntax (Wave Length)
  Player:     $game_player.wave_length_change(value, duration, rel)
  Event:      $game_map.events[id].wave_length_change(value, duration, rel)
  Vehicle:    $game_map.vehicle[id].wave_length_change(value, duration, rel)
  
              Syntax (Wave Speed)
  Player:     $game_player.wave_speed_change(value, duration, rel)
  Event:      $game_map.events[id].wave_speed_change(value, duration, rel)
  Vehicle:    $game_map.vehicle[id].wave_speed_change(value, duration, rel)
  * relative: Optional. Set to false by default.
 ──────────────────────────────────────────────────────────────────────────────
 ■ FAQ
   o I am getting a FalseClass error whenever I apply Tone/Color. What do I do?
     Add "return true" (no quotes) into the script call.
  
=end
 
#==============================================================================
# ** Sprite_Character
#------------------------------------------------------------------------------
#  This sprite is used to display the character.It observes the Game_Character
#  class and automatically changes sprite conditions.
#==============================================================================
 
class Sprite_Character < Sprite_Base
    #---------------------------------------------------------------------------
    # * Alias Listings
    #---------------------------------------------------------------------------
    alias_method(:pk8_ncp_update, :update) unless method_defined?(:pk8_ncp_update)
    #--------------------------------------------------------------------------
    # * Frame Update
    #--------------------------------------------------------------------------
    def update
      pk8_ncp_update
      super
      self.tone = @character.tone
      self.angle = @character.angle
      self.zoom_x = @character.zoom_x / 100.0
      self.zoom_y = @character.zoom_y / 100.0
      self.mirror = @character.mirror
      self.color = @character.color
      self.wave_amp = @character.wave_amp
      self.wave_length = @character.wave_length
      self.wave_speed = @character.wave_speed
    end
  end
   
  #==============================================================================
  # ** Game_Character
  #------------------------------------------------------------------------------
  #  This class deals with characters. It's used as a superclass for the
  #  Game_Player and Game_Event classes.
  #==============================================================================
   
  class Game_Character
    #--------------------------------------------------------------------------
    # * Public Instance Variables
    #--------------------------------------------------------------------------
    attr_accessor :tone, :angle, :zoom_x, :zoom_y, :mirror, :color, :wave_amp, 
                  :wave_length, :wave_speed, :angle_target, :angle_duration,
                  :tone_target, :tone_duration, :tone_red_target,
                  :tone_red_duration, :tone_green_target, :tone_green_duration,
                  :tone_blue_target, :tone_blue_duration, :tone_gray_target,
                  :tone_gray_duration, :color_target, :color_duration,
                  :color_red_target, :color_red_duration, :color_green_target,
                  :color_green_duration, :color_blue_target, :color_blue_duration,
                  :zoom_x_target, :zoom_x_duration, :zoom_y_target,
                  :zoom_y_duration, :wave_amp_target, :wave_amp_duration,
                  :wave_length_target, :wave_length_duration, :wave_speed_target,
                  :wave_speed_duration
    #---------------------------------------------------------------------------
    # * Alias Listings
    #---------------------------------------------------------------------------
    unless method_defined?(:pk8_ncp_initialize)
      alias_method(:pk8_ncp_initialize, :initialize) 
      alias_method(:pk8_ncp_update, :update)
    end
    #--------------------------------------------------------------------------
    # * Object Initialization
    #--------------------------------------------------------------------------
    def initialize
      pk8_ncp_initialize
      @tone = Tone.new(0, 0, 0, 0)
      @angle = 0
      @zoom_x, @zoom_y = 100.0, 100.0
      @mirror = false
      @color = Color.new(0, 0, 0, 0)
      @angle_target, @angle_duration             = 0, 0
      @tone_target, @tone_duration               = Tone.new(0,0,0,0), 0
      @tone_red_target, @tone_red_duration       = 0, 0
      @tone_green_target, @tone_green_duration   = 0, 0
      @tone_blue_target, @tone_blue_duration     = 0, 0
      @tone_gray_target, @tone_gray_duration     = 0, 0
      @color_target, @color_duration             = Color.new(0,0,0,0), 0
      @color_red_target, @color_red_duration     = 0, 0
      @color_green_target, @color_green_duration = 0, 0
      @color_blue_target, @color_blue_duration   = 0, 0
      @color_alpha_target, @color_alpha_duration = 0, 0
      @zoom_x_target, @zoom_x_duration           = 0, 0
      @zoom_y_target, @zoom_y_duration           = 0, 0
      @wave_amp_target, @wave_amp_duration       = 0, 0
      @wave_length_target, @wave_length_duration = 2, 0
      @wave_speed_target, @wave_speed_duration   = 0, 0
      @wave_amp, @wave_length, @wave_speed       = 0, 2, 0
    end
    #--------------------------------------------------------------------------
    # * Set Tone
    #--------------------------------------------------------------------------
    def tone=(value)
      value = Tone.new(*value) if value.is_a?(Array)
      @tone = value
    end
    #--------------------------------------------------------------------------
    # * Set Color
    #--------------------------------------------------------------------------
    def color=(value)
      value = Color.new(*value) if value.is_a?(Array)
      @color = value
    end
    #--------------------------------------------------------------------------
    # * Angle Change
    #     angle     : Picture angle
    #     duration  : Frame amount.
    #     relative  : References current value and adds to it, if true.
    #--------------------------------------------------------------------------
    def angle_change(angle, duration, relative = false)
      @angle_target = (relative == true ? @angle + angle : angle)
      @angle_duration = duration
      @angle = @angle_target.clone if @angle_duration == 0
    end
    #--------------------------------------------------------------------------
    # * Tone Change
    #     tone     : Target Tone. (Tone.new(red, green, blue[, gray))
    #     duration : Frame amount.
    #     relative : References current value and adds to it, if true.
    #--------------------------------------------------------------------------
    def tone_change(tone, duration, relative = false)
      tone = Tone.new(*tone) if tone.is_a?(Array)
      if relative == true
        tone.red, tone.green = @tone.red + tone.red, @tone.green + tone.green
        tone.blue, tone.gray = @tone.blue + tone.blue, @tone.gray + tone.gray
      end
      @tone_target = tone.clone
      @tone_duration = duration
      @tone = @tone_target.clone if @tone_duration == 0
    end
    #--------------------------------------------------------------------------
    # * Tone Red Change
    #     tone_red : Target Red Tone. (-255 - 255)
    #     duration : Frame amount.
    #     relative : References current value and adds to it, if true.
    #--------------------------------------------------------------------------
    def tone_red_change(tone_red, duration, relative = false)
      @tone_red_target = (relative == true ? @tone.red + tone_red : tone_red)
      @tone_red_duration = duration
      @tone.red = @tone_red_target.clone if @tone_red_duration == 0
    end
    #--------------------------------------------------------------------------
    # * Tone Green Change
    #     tone_green : Target Green Tone. (-255 - 255)
    #     duration   : Frame amount.
    #     relative   : References current value and adds to it, if true.
    #--------------------------------------------------------------------------
    def tone_green_change(tone_green, duration, relative = false)
      @tone_green_target = (relative==true ? @tone.green+tone_green : tone_green)
      @tone_green_duration = duration
      @tone.green = @tone_green_target.clone if @tone_green_duration == 0
    end
    #--------------------------------------------------------------------------
    # * Tone Blue Change
    #     tone_blue : Target Blue Tone. (-255 - 255)
    #     duration  : Frame amount.
    #     relative  : References current value and adds to it, if true.
    #--------------------------------------------------------------------------
    def tone_blue_change(tone_blue, duration, relative = false)
      @tone_blue_target = (relative == true ? @tone.blue+tone_blue : tone_blue)
      @tone_blue_duration = duration
      @tone.blue = @tone_blue_target.clone if @tone_blue_duration == 0
    end
    #--------------------------------------------------------------------------
    # * Tone Gray Change
    #     tone_blue : Target Gray Tone. (0 - 255)
    #     duration  : Frame amount.
    #     relative  : References current value and adds to it, if true.
    #--------------------------------------------------------------------------
    def tone_gray_change(tone_gray, duration, relative = false)
      @tone_gray_target = (relative == true ? @tone.gray + tone_gray : tone_gray)
      @tone_gray_duration = duration
      @tone.gray = @tone_gray_target.clone if @tone_gray_duration == 0
    end
    #--------------------------------------------------------------------------
    # * Color Change
    #     color     : Target Color. (Color.new(red, green, blue[, alpha))
    #     duration  : Frame amount.
    #     relative  : References current value and adds to it, if true.
    #--------------------------------------------------------------------------
    def color_change(color, duration, relative = false)
      color = Color.new(*color) if color.is_a?(Array)
      if relative == true
        color.red, color.green = @color.red+color.red, @color.green+color.green
        color.blue, color.alpha = @color.blue+color.blue, @color.alpha+color.alpha
      end
      @color_target = color.clone
      @color_duration = duration
      @color = @color_target.clone if @color_duration == 0
    end
    #--------------------------------------------------------------------------
    # * Color Red Change
    #     color_red : Target Red Color. (0 - 255)
    #     duration  : Frame amount.
    #     relative  : References current value and adds to it, if true.
    #--------------------------------------------------------------------------
    def color_red_change(color_red, duration, relative = false)
      @color_red_target = (relative == true ? @color.red + color_red : color_red)
      @color_red_duration = duration
      @color.red = @color_red_target.clone if @color_red_duration == 0
    end
    #--------------------------------------------------------------------------
    # * Color Green Change
    #     color_green : Target Green Color. (0 - 255)
    #     duration    : Frame amount.
    #     relative    : References current value and adds to it, if true.
    #--------------------------------------------------------------------------
    def color_green_change(color_green, duration, relative = false)
      @color_green_target=(relative==true ?@color.green+color_green : color_green)
      @color_green_duration = duration
      @color.green = @color_green_target.clone if @color_green_duration == 0
    end
    #--------------------------------------------------------------------------
    # * Color Blue Change
    #     color_blue : Target Blue Color. (0 - 255)
    #     duration   : Frame amount.
    #     relative   : References current value and adds to it, if true.
    #--------------------------------------------------------------------------
    def color_blue_change(color_blue, duration, relative = false)
      @color_blue_target =(relative == true ? @color.blue+color_blue : color_blue)
      @color_blue_duration = duration
      @color.blue = @color_blue_target.clone if @color_blue_duration == 0
    end
    #--------------------------------------------------------------------------
    # * Color Alpha Change
    #     color_alpha : Target Alpha. (0 - 255)
    #     duration    : Frame amount.
    #     relative    : References current value and adds to it, if true.
    #--------------------------------------------------------------------------
    def color_alpha_change(color_alpha, duration, relative = false)
      @color_alpha_target=(relative==true ?@color.alpha+color_alpha : color_alpha)
      @color_alpha_duration = duration
      @color.alpha = @color_alpha_target.clone if @color_alpha_duration == 0
    end
    #--------------------------------------------------------------------------
    # * Zoom Change
    #     zoom_x    : X-Axis Zoom Level
    #     zoom_y    : Y-Axis Zoom Level
    #     duration  : Frame amount.
    #     relative  : References current value and adds to it, if true.
    #--------------------------------------------------------------------------
    def zoom_change(zoom_x, zoom_y, duration, relative = false)
      if relative == true
        @zoom_x_target, @zoom_y_target = @zoom_x + zoom_x, @zoom_y + zoom_y
      else
        @zoom_x_target, @zoom_y_target = zoom_x, zoom_y
      end
      @zoom_x_duration = duration
      @zoom_x = @zoom_x_target.clone if @zoom_x_duration == 0
      @zoom_y_duration = duration
      @zoom_y = @zoom_y_target.clone if @zoom_y_duration == 0
    end
    #--------------------------------------------------------------------------
    # * Zoom_X Change
    #     zoom_x    : X-Axis Zoom Level
    #     duration  : Frame amount.
    #     relative  : References current value and adds to it, if true.
    #--------------------------------------------------------------------------
    def zoom_x_change(zoom_x, duration, relative = false)
      @zoom_x_target = (relative == true ? @zoom_x + zoom_x : zoom_x)
      @zoom_x_duration = duration
      @zoom_x = @zoom_x_target.clone if @zoom_x_duration == 0
    end
    #--------------------------------------------------------------------------
    # * Zoom_Y Change
    #     zoom_y    : Y-Axis Zoom Level
    #     duration  : Frame amount.
    #     relative  : References current value and adds to it, if true.
    #--------------------------------------------------------------------------
    def zoom_y_change(zoom_y, duration, relative = false)
      @zoom_y_target = (relative == true ? @zoom_y + zoom_y : zoom_y)
      @zoom_y_duration = duration
      @zoom_y = @zoom_y_target.clone if @zoom_y_duration == 0
    end
    #--------------------------------------------------------------------------
    # * Wave Amplitude Change
    #     wave_amp : Target Wave Amplitude. (0 > )
    #     duration : Frame amount.
    #     relative : References current value and adds to it, if true.
    #--------------------------------------------------------------------------
    def wave_amp_change(wave_amp, duration, relative = false)
      @wave_amp_target = (relative == true ? @wave_amp + wave_amp : wave_amp)
      @wave_amp_duration = duration
      @wave_amp = @wave_amp_target.clone if @wave_amp_duration == 0
    end
    #--------------------------------------------------------------------------
    # * Wave Length Change
    #     wave_length : Target Wave Length. (2 > )
    #     duration    : Frame amount.
    #     relative    : References current value and adds to it, if true.
    #--------------------------------------------------------------------------
    def wave_length_change(wave_length, duration, relative = false)
      @wave_length_target=(relative==true ?@wave_length+wave_length : wave_length)
      @wave_length_target = 2 if @wave_length_target < 2
      @wave_length_duration = duration
      @wave_length = @wave_length_target.clone if @wave_length_duration == 0
    end
    #--------------------------------------------------------------------------
    # * Wave Speed Change
    #     wave_speed : Target Wave Speed. (0 > )
    #     duration   : Frame amount.
    #     relative   : References current value and adds to it, if true.
    #--------------------------------------------------------------------------
    def wave_speed_change(wave_speed, duration, relative = false)
      @wave_speed_target = (relative==true ? @wave_speed+wave_speed : wave_speed)
      @wave_speed_duration = duration
      @wave_speed = @wave_speed_target.clone if @wave_speed_duration == 0
    end
    #--------------------------------------------------------------------------
    # * Frame Update
    #--------------------------------------------------------------------------
    def update
      pk8_ncp_update
      if @angle_duration >= 1         # Angle
        d = @angle_duration
        @angle = (@angle * (d - 1) + @angle_target) / d
        @angle_duration -= 1
      end
      if @color_duration >= 1         # Color
        d = @color_duration
        @color.red = (@color.red * (d - 1) + @color_target.red) / d
        @color.green = (@color.green * (d - 1) + @color_target.green) / d
        @color.blue = (@color.blue * (d - 1) + @color_target.blue) / d
        @color.alpha = (@color.alpha * (d - 1) + @color_target.alpha) / d
        @color_duration -= 1
      end
      if @color_red_duration >= 1    # Red color
        d = @color_red_duration
        @color.red = (@color.red * (d - 1) + @color_red_target) / d
        @color_red_duration -= 1
      end
      if @color_green_duration >= 1  # Green color
        d = @color_green_duration
        @color.green = (@color.green * (d - 1) + @color_green_target) / d
        @color_green_duration -= 1
      end
      if @color_blue_duration >= 1   # Blue color
        d = @color_blue_duration
        @color.blue = (@color.blue * (d - 1) + @color_blue_target) / d
        @color_blue_duration -= 1
      end
      if @color_alpha_duration >= 1  # Alpha
        d = @color_alpha_duration
        @color.alpha = (@color.alpha * (d - 1) + @color_alpha_target) / d
        @color_alpha_duration -= 1
      end
      if @tone_duration >= 1         # Tone
        d = @tone_duration
        @tone.red = (@tone.red * (d - 1) + @tone_target.red) / d
        @tone.green = (@tone.green * (d - 1) + @tone_target.green) / d
        @tone.blue = (@tone.blue * (d - 1) + @tone_target.blue) / d
        @tone.gray = (@tone.gray * (d - 1) + @tone_target.gray) / d
        @tone_duration -= 1
      end
      if @tone_red_duration >= 1     # Red Tone
        d = @tone_red_duration
        @tone.red = (@tone.red * (d - 1) + @tone_red_target) / d
        @tone_red_duration -= 1
      end
      if @tone_green_duration >= 1   # Green Tone
        d = @tone_green_duration
        @tone.green = (@tone.green * (d - 1) + @tone_green_target) / d
        @tone_green_duration -= 1
      end
      if @tone_blue_duration >= 1    # Blue Tone
        d = @tone_blue_duration
        @tone.blue = (@tone.blue * (d - 1) + @tone_blue_target) / d
        @tone_blue_duration -= 1
      end
      if @tone_gray_duration >= 1    # Gray Tone
        d = @tone_gray_duration
        @tone.gray = (@tone.gray * (d - 1) + @tone_gray_target) / d
        @tone_gray_duration -= 1
      end
      if @zoom_x_duration >= 1       # Zoom X
        d = @zoom_x_duration
        @zoom_x = (@zoom_x * (d - 1) + @zoom_x_target) / d
        @zoom_x_duration -= 1
      end
      if @zoom_y_duration >= 1       # Zoom Y
        d = @zoom_y_duration
        @zoom_y = (@zoom_y * (d - 1) + @zoom_y_target) / d
        @zoom_y_duration -= 1
      end
      if @wave_amp_duration >= 1     # Wave Amplitude
        d = @wave_amp_duration
        @wave_amp = (@wave_amp * (d - 1) + @wave_amp_target) / d
        @wave_amp_duration -= 1
      end
      if @wave_length_duration >= 1  # Wave Length
        d = @wave_length_duration
        @wave_length = (@wave_length * (d - 1) + @wave_length_target) / d
        @wave_length_duration -= 1
      end
      if @wave_speed_duration >= 1   # Wave Speed
        d = @wave_speed_duration
        @wave_speed = (@wave_speed * (d - 1) + @wave_speed_target) / d
        @wave_speed_duration -= 1
      end
    end
  end
   
  #==============================================================================
  # ** Game_Event
  #------------------------------------------------------------------------------
  #  This class deals with events. It handles functions including event page 
  #  switching via condition determinants, and running parallel process events.
  #  It's used within the Game_Map class.
  #==============================================================================
   
  class Game_Event < Game_Character
    #---------------------------------------------------------------------------
    # * Alias Listings
    #---------------------------------------------------------------------------
    alias_method(:pk8_ncp_refresh, :refresh) if !method_defined?(:pk8_ncp_refresh)
    #--------------------------------------------------------------------------
    # * Refresh
    #--------------------------------------------------------------------------
    def refresh
      pk8_ncp_refresh
      event_angle_commands(@page) if @page != nil
      event_color_commands(@page) if @page != nil
      event_color_red_commands(@page) if @page != nil
      event_color_green_commands(@page) if @page != nil
      event_color_blue_commands(@page) if @page != nil
      event_color_alpha_commands(@page) if @page != nil
      event_mirror_commands(@page) if @page != nil
      event_tone_commands(@page) if @page != nil
      event_tone_red_commands(@page) if @page != nil
      event_tone_green_commands(@page) if @page != nil
      event_tone_blue_commands(@page) if @page != nil
      event_tone_gray_commands(@page) if @page != nil
      event_zoom_commands(@page) if @page != nil
      event_zoom_x_commands(@page) if @page != nil
      event_zoom_y_commands(@page) if @page != nil
      event_wave_amp_commands(@page) if @page != nil
      event_wave_length_commands(@page) if @page != nil
      event_wave_speed_commands(@page) if @page != nil
    end
    #--------------------------------------------------------------------------
    # * Event Tone
    #--------------------------------------------------------------------------
    def event_tone_commands(page)
      l = page.list
      for i in 0..l.length - 2
        c = l[i]
        if (c.code == 108 and c.parameters[0][0,5].to_s.downcase.include?("$tone"
          ) and !c.parameters[0][0,9].to_s.downcase.include?("$tone_red") and
          !c.parameters[0][0,11].to_s.downcase.include?("$tone_green") and
          !c.parameters[0][0,10].to_s.downcase.include?("$tone_blue") and
          !c.parameters[0][0,10].to_s.downcase.include?("$tone_gray"))
          c_substrings = c.parameters[0].split(' ')
          red = c_substrings[1].to_i
          green = c_substrings[2].to_i
          blue = c_substrings[3].to_i
          gray = c_substrings[4].to_i
          @tone = Tone.new(red, green, blue, gray)
        end
      end
    end
    #--------------------------------------------------------------------------
    # * Event Tone: Red
    #--------------------------------------------------------------------------
    def event_tone_red_commands(page)
      l = page.list
      for i in 0..l.length - 2
        c = l[i]
        if (c.code == 108 and c.parameters[0][0,9].to_s.downcase.include?(
          "$tone_red"))
          c_substrings = c.parameters[0].split(' ')
          @tone.red = c_substrings[1].to_i
        end
      end
    end
    #--------------------------------------------------------------------------
    # * Event Tone: Green
    #--------------------------------------------------------------------------
    def event_tone_green_commands(page)
      l = page.list
      for i in 0..l.length - 2
        c = l[i]
        if (c.code == 108 and c.parameters[0][0,11].to_s.downcase.include?(
          "$tone_green"))
          c_substrings = c.parameters[0].split(' ')
          @tone.green = c_substrings[1].to_i
        end
      end
    end
    #--------------------------------------------------------------------------
    # * Event Tone: Blue
    #--------------------------------------------------------------------------
    def event_tone_blue_commands(page)
      l = page.list
      for i in 0..l.length - 2
        c = l[i]
        if (c.code == 108 and c.parameters[0][0,10].to_s.downcase.include?(
          "$tone_blue"))
          c_substrings = c.parameters[0].split(' ')
          @tone.blue = c_substrings[1].to_i
        end
      end
    end
    #--------------------------------------------------------------------------
    # * Event Tone: Gray
    #--------------------------------------------------------------------------
    def event_tone_gray_commands(page)
      l = page.list
      for i in 0..l.length - 2
        c = l[i]
        if (c.code == 108 and c.parameters[0][0,10].to_s.downcase.include?(
          "$tone_gray"))
          c_substrings = c.parameters[0].split(' ')
          @tone.gray = c_substrings[1].to_i
        end
      end
    end
    #--------------------------------------------------------------------------
    # * Event Color
    #--------------------------------------------------------------------------
    def event_color_commands(page)
      l = page.list
      for i in 0..l.length - 2
        c = l[i]
        if (c.code == 108 and c.parameters[0][0,6].to_s.downcase.include?(
          "$color") and !c.parameters[0][0,10].to_s.downcase.include?("$color_red"
          ) and !c.parameters[0][0,12].to_s..downcase.include?("$color_green") and
          !c.parameters[0][0,11].to_s.downcase.include?("$color_blue") and
          !c.parameters[0][0,12].to_s.downcase.include?("$color_alpha"))
          c_substrings = c.parameters[0].split(' ')
          red, green = c_substrings[1].to_i, c_substrings[2].to_i
          blue, alpha = c_substrings[3].to_i, c_substrings[4].to_i
          @color = Color.new(red, green, blue, alpha)
        end
      end
    end
    #--------------------------------------------------------------------------
    # * Event Color: Red
    #--------------------------------------------------------------------------
    def event_color_red_commands(page)
      l = page.list
      for i in 0..l.length - 2
        c = l[i]
        if (c.code == 108 and c.parameters[0][0,10].to_s.downcase.include?(
          "$color_red"))
          c_substrings = c.parameters[0].split(' ')
          @color.red = c_substrings[1].to_i
        end
      end
    end
    #--------------------------------------------------------------------------
    # * Event Color: Green
    #--------------------------------------------------------------------------
    def event_color_green_commands(page)
      l = page.list
      for i in 0..l.length - 2
        c = l[i]
        if (c.code == 108 and c.parameters[0][0,12].to_s.downcase.include?(
          "$color_green"))
          c_substrings = c.parameters[0].split(' ')
          @color.green = c_substrings[1].to_i
        end
      end
    end
    #--------------------------------------------------------------------------
    # * Event Color: Blue
    #--------------------------------------------------------------------------
    def event_color_blue_commands(page)
      l = page.list
      for i in 0..l.length - 2
        c = l[i]
        if (c.code == 108 and c.parameters[0][0,11].to_s.downcase.include?(
          "$color_blue"))
          c_substrings = c.parameters[0].split(' ')
          @color.blue = c_substrings[1].to_i
        end
      end
    end
    #--------------------------------------------------------------------------
    # * Event Color: Alpha
    #--------------------------------------------------------------------------
    def event_color_alpha_commands(page)
      l = page.list
      for i in 0..l.length - 2
        c = l[i]
        if (c.code == 108 and c.parameters[0][0,12].to_s.downcase.include?(
          "$color_alpha"))
          c_substrings = c.parameters[0].split(' ')
          @color.alpha = c_substrings[1].to_i
        end
      end
    end
    #--------------------------------------------------------------------------
    # * Event Zoom
    #--------------------------------------------------------------------------
    def event_zoom_commands(page)
      l = page.list
      for i in 0..l.length - 2
        c = l[i]
        if (c.code == 108 and c.parameters[0][0,5].to_s.downcase.include?(
          "$zoom") and !c.parameters[0][0,7].to_s.downcase.include?("$zoom_x") and
          !c.parameters[0][0,7].to_s.downcase.include?("$zoom_y"))
          c_substrings = c.parameters[0].split(' ')
          @zoom_x, @zoom_y = c_substrings[1].to_i, c_substrings[2].to_i
        end
      end
    end
    #--------------------------------------------------------------------------
    # * Event Zoom: X
    #--------------------------------------------------------------------------
    def event_zoom_x_commands(page)
      l = page.list
      for i in 0..l.length - 2
        c = l[i]
        if (c.code == 108 and c.parameters[0][0,7].to_s.downcase.include?(
          "$zoom_x"))
          c_substrings = c.parameters[0].split(' ')
          @zoom_x = c_substrings[1].to_i
        end
      end
    end
    #--------------------------------------------------------------------------
    # * Event Zoom: Y
    #--------------------------------------------------------------------------
    def event_zoom_y_commands(page)
      l = page.list
      for i in 0..l.length - 2
        c = l[i]
        if (c.code == 108 and c.parameters[0][0,7].to_s.downcase.include?(
          "$zoom_y"))
          c_substrings = c.parameters[0].split(' ')
          @zoom_y = c_substrings[1].to_i
        end
      end
    end
    #--------------------------------------------------------------------------
    # * Event Angle
    #--------------------------------------------------------------------------
    def event_angle_commands(page)
      l = page.list
      for i in 0..l.length - 2
        c = l[i]
        if (c.code == 108 and c.parameters[0][0,6].to_s.downcase.include?(
          "$angle"))
          c_substrings = c.parameters[0].split(' ')
          @angle = c_substrings[1].to_i
        end
      end
    end
    #--------------------------------------------------------------------------
    # * Event Mirror
    #--------------------------------------------------------------------------
    def event_mirror_commands(page)
      l = page.list
      for i in 0..l.length - 2
        c = l[i]
        if (c.code == 108 and c.parameters[0][0,7].to_s.downcase.include?(
          "$mirror"))
          c_substrings = c.parameters[0].split(' ')
          if c_substrings[1].to_s.downcase.empty?; @mirror = true
          else; @mirror = (c_substrings[1].to_s.downcase == "true" ? true : false)
          end
        end
      end
    end
    #--------------------------------------------------------------------------
    # * Event Wave Amplitude
    #--------------------------------------------------------------------------
    def event_wave_amp_commands(page)
      l = page.list
      for i in 0..l.length - 2
        c = l[i]
        if (c.code == 108 and c.parameters[0][0,9].to_s.downcase.include?(
          "$wave_amp"))
          c_substrings = c.parameters[0].split(' ')
          @wave_amp = c_substrings[1].to_i
        end
      end
    end
    #--------------------------------------------------------------------------
    # * Event Wave Length
    #--------------------------------------------------------------------------
    def event_wave_length_commands(page)
      l = page.list
      for i in 0..l.length - 2
        c = l[i]
        if (c.code == 108 and c.parameters[0][0,12].to_s.downcase.include?(
          "$wave_length"))
          c_substrings = c.parameters[0].split(' ')
          @wave_length = 2 if c_substrings[1].to_i < 2
          @wave_length = c_substrings[1].to_i
        end
      end
    end
    #--------------------------------------------------------------------------
    # * Event Wave Speed
    #--------------------------------------------------------------------------
    def event_wave_speed_commands(page)
      l = page.list
      for i in 0..l.length - 2
        c = l[i]
        if (c.code == 108 and c.parameters[0][0,11].to_s.downcase.include?(
          "$wave_speed"))
          c_substrings = c.parameters[0].split(' ')
          @wave_speed = c_substrings[1].to_i
        end
      end
    end
  end
   