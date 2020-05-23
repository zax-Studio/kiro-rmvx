#==============================================================================
# Congig - Animation
# -----------------------------------------------------------------------------
# Setupping the Frames
# -----------------------------------------------------------------------------
# 1 - Setting the number of Frames
#    FRAMES["Image Name"] = Frames
#    Ex:
#    Graphics/Characters/Hero/Attack.png ( 6 frames )
#    Use: FRAMES["Hero/Attack"] = 6
# -----------------------------------------------------------------------------
# 2 - Setting the hit Frame (The frame that the damage will pop up)
#    DAMAGE_FRAME["Image Name"] = Frame that the damage will pop up
#==============================================================================

module PRABS::CONFIG::ANIMATION
  
  # Animation Speed
  # 1 - Verty Fast : 10 - Very Slow
  DELAY = 3
  
  # Animations Frames
  # Frames de Kiro
  FRAMES["$016-Thief01/FrontAttack"] = 6
  FRAMES["$016-Thief01/FrontFrontAttack"] = 6
  # Frames de Nick
  FRAMES["$001-Fighter01/FrontAttack"] = 6
  FRAMES["$001-Fighter01/FrontFrontAttack"] = 6
  FRAMES["$001-Fighter01/Arco"] = 6
  # Frames de Jezameni
  FRAMES["$Yoskut/FrontAttack"] = 6
  FRAMES["$Yoskut/FrontFrontAttack"] = 4
  FRAMES["$Yoskut/Arco"] = 6
  
  # Damage Frame
  # Damage Frames de Kiro
  DAMAGE_FRAME["$016-Thief01/FrontAttack"] = 4
  DAMAGE_FRAME["$016-Thief01/FrontFrontAttack"] = 4
  # Damage Frames de Nick
  DAMAGE_FRAME["$001-Fighter01/FrontAttack"] = 4
  DAMAGE_FRAME["$001-Fighter01/FrontFrontAttack"] = 4
  # Damage Frames de Jezameni
  DAMAGE_FRAME["$Yoskut/FrontAttack"] = 4
  DAMAGE_FRAME["$Yoskut/FrontFrontAttack"] = 4
  
  # Enemy - Attacking
  FRAMES["$051-Undead01/Attack"] = 7

end
