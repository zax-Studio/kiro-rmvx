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
  FRAMES["$Kiro/FrontAttack"] = 4
  FRAMES["$Kiro/FrontFrontAttack"] = 4
  FRAMES["$Kiro/Pickaxe"] = 4
  # Frames de Nick
  FRAMES["$Nick/Arco"] = 4
  # Frames de Jezameni
  FRAMES["$Jezameni/FrontAttack"] = 4
  FRAMES["$Jezameni/FrontFrontAttack"] = 4
  
  # Damage Frame
  # Damage Frames de Kiro
  DAMAGE_FRAME["$Kiro/FrontAttack"] = 3
  DAMAGE_FRAME["$Kiro/FrontFrontAttack"] = 4
  DAMAGE_FRAME["$Kiro/Pickaxe"] = 3
  # Damage Frames de Nick
  DAMAGE_FRAME["$Nick/Arco"] = 4
  # Damage Frames de Jezameni
  DAMAGE_FRAME["$Jezameni/FrontAttack"] = 3
  DAMAGE_FRAME["$Jezameni/FrontFrontAttack"] = 4
  
  # Enemy - Attacking
  FRAMES["$051-Undead01/Attack"] = 7

end
