#===============================================================
# ● [VX Snippet] ◦ Lock Screen ◦ □
# * Lock/Unlock screen from scroll with switch~ *
#--------------------------------------------------------------
# ◦ by Woratana [woratana@hotmail.com]
# ◦ Thaiware RPG Maker Community
# ◦ Released on: 02/06/2008
# ◦ Version: 1.0
#--------------------------------------------------------------

#==================================================================
# ** HOW TO USE **
#-----------------------------------------------------------------
# * Set the switch ID you want to use to lock/unlock screen in SETUP part.
# * Turn that switch ON/OFF to LOCK/UNLOCK screen.
#==================================================================

class Game_Map
  #==========================================================
  # * [START] LOCK SCREEN SCRIPT SETUP
  #----------------------------------------------------------
  LOCK_SWITCH_ID = 55
  # Switch to LOCK/UNLOCK screen. (turn this switch ON to LOCK)
  #----------------------------------------------------------
  # * [END] LOCK SCREEN SCRIPT SETUP
  #==========================================================
  
  # List all the methods that use for scroll
  AM = [:scroll_up, :scroll_down, :scroll_left, :scroll_right]
  AM.each do |m|
    new_m = 'wora_lockscr_gammap' + m.to_s                # Create new name
    alias_method(new_m, m) unless method_defined?(new_m)  # Alias the method
                                                          # Create script
ascript = <<_SCRIPT_
def #{m} (*args)
  return if $game_switches[#{LOCK_SWITCH_ID}]
  #{new_m} (*args)
end
_SCRIPT_
    eval(ascript) # Run script
  end
end