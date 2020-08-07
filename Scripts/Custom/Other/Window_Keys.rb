#==============================================================================
# ** Window_Keys
#------------------------------------------------------------------------------
#  This window displays the number of keys.
#==============================================================================
class Window_Keys < Window_Base
  ON_OFF_SWITCH = 84

  #--------------------------------------------------------------------------
  # * Object Initialization
  #     x : window X coordinate
  #     y : window Y coordinate
  #--------------------------------------------------------------------------
  def initialize(x, y)
    super(x, y, 84, WLH + 32)
    refresh
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    self.contents.clear
    self.draw_icon(80, 0, 0, true)
    self.contents.draw_text(32, 0, self.width, WLH, $game_variables[5])
  end

  def terminate
    $game_switches[ON_OFF_SWITCH] = false
    dispose
    $keywindow = nil
  end
end