#==============================================================================
# PRABS::CONFIG::DATABASE
# -----------------------------------------------------------------------------
# Skill configuration
# -----------------------------------------------------------------
# 1 - Setting a normal skill
#    SKILLS[id] = [a, b, c, d, e]
#    a - Number of houses in front of the player
#    b - Range
#    c - Type:
#        LINHA : Linear
#        CRUZ  : Crux
#        RED   : Circle
#        QUAD  : Square
#    d - Image Name (Use "" for default) * 
#    e - Required Item [Item ID, Amount, Spend?(true or false)] - Use nil for none (Optional)
# -----------------------------------------------------------------
# 2 - Setting a shootable skill
#    SKILLS[id] = [a, b, SHOOT, c, d, e]
#    a - Map ID
#    b - Event ID
#    c - Image Name (Use "" for default) *
#    d - Required Item [Item ID, Amount, Spend?(true or false)] - Use nil for none (Optional)
#    e - ID of an animation over the player (Optional)
# -----------------------------------------------------------------
# 3 - Setting the default skill. (In case one doesn't exist)
#            DEFAULT_SKILL = [a, b, c, d, e, f]
# -----------------------------------------------------------------
# *Obs: Image name will be $Char_name + Image Name
#==============================================================================

module PRABS::CONFIG::DATABASE
  
  # Default
  DEFAULT_SKILL = [5, 5, QUAD, ""]
    
  # Skills
  # Front C
  SKILLS[84] = [1, 1, QUAD, ""]
  # Front Front C
  SKILLS[85] = [64, 1, SHOOT, "", nil, 83]
  # Thunder
  SKILLS[86] = [5, 5, QUAD, ""]
  # FireBall
  SKILLS[87] = [64, 2, SHOOT, ""]
  # Arrow
  SKILLS[88] = [64, 3, SHOOT, "", [35, 1, true]]
  # Lanza
  SKILLS[91] = [64, 6, SHOOT, "", nil, 83]

  # Bomb - Damage
  SKILLS[89] = [0, 4, RED, ""]
  # Impacto Frio
  SKILLS[64] = [0, 6, RED, ""]

  # FireBall - Passable
  SKILLS[90] = [64, 5, SHOOT, ""]

end
