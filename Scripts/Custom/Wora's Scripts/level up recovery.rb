#===============================================================
# ? [VX] ? Recover HP/MP/States when Level Up ? ?
#--------------------------------------------------------------
# ? by Woratana [woratana@hotmail.com]
# ? Thaiware RPG Maker Community
# ? Released on: 10/06/2008
# ? Version: 1.0
#--------------------------------------------------------------
# ? How to use:
# Put this script above main, you can setup script below
#=================================================================

class Game_Actor < Game_Battler
  
  #==================================
  # * SCRIPT SETUP PART
  #----------------------------------
  RECOVER_HP = true # Recover HP when level up? (true/false)
  RECOVER_MP = true # Recover MP when level up? 
  REMOVE_STATES = true # Cure all states when level up?
  #==================================
  
  alias wora_fullhpmp_gamact_lvup level_up
  def level_up
    wora_fullhpmp_gamact_lvup
    @hp = maxhp if RECOVER_HP
    @mp = maxmp if RECOVER_MP
    if REMOVE_STATES
      @states.clone.each {|i| remove_state(i) }
    end
  end
end