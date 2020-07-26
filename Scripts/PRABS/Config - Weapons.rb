#===============================================================================
# Config - Sequences
# -----------------------------------------------------------------------------
# Weapons ans Sequences Configuration
# -----------------------------------------------------------------------------
# 1 - Setting the Keys sequences:
#    SEQUENCES["sequnce name"] = [a, b, ...., c]
#    Set the sequence using the following values:
#    FRONT - Botão para frente
#    BACK  - Botão para trás
#    ATTACK - Botão de ataque
# Ex:
# Creating a Front, Front Attack sequence:
# SEQUENCES["front2x + attack"] = [FRONT, FRONT, ATTACK]
# -----------------------------------------------------------------------------
# 2 - Setting the sequence
#    Use:
#  data = []
#  data << [a, b, c, d, e]
#    a is the sequence. (e. SEQUENCES["front2x + attack"])
#    b - Skill that will be cast (0 for attack)
#    c - Animation Picture Name *
#    d - Delay between sequences. (optional)
#    e - (true, finish combo, false - continue combo) (optional)
# -----------------------------------------------------------------------------
# 2 - Setting the sequence
#    Use:
#  data = []
#  data << [a, b, c, d, e]
#  data << [a, b, c, d, e]
#  data << [a, b, c, d, e]
#  data << [a, b, c, d, e]
#  data << [a, b, c, d, e]
# -----------------------------------------------------------------------------
# 4 - Setting the sequence to a player
#    Use:
#  data = []
#  data << [...]
#  data << [...]
#  PRABS::HERO.add_sequence(a, b, c, data)
#  a - Hero ID
#  b - Weapon ID
#  c - Combo Index ( 0 - For all Combos )
# -----------------------------------------------------------------------------
# 5 - Setting the Max combo
#  PRABS::HERO.set_combo_max(a, b, c, d)
#  a - Hero ID
#  b - Weapon ID
#  c - Max Number of combos
#  d - Delay after the combo (frames)
# -----------------------------------------------------------------------------
# 6 - Example
# -----------------------------------------------------------------------------
#  # Data
#  data = []
#  data << [a, b, c, d, e]
#  data << [a, b, c, d, e]
#  data << [a, b, c, d, e]
#  data << [a, b, c, d, e]
#  data << [a, b, c, d, e]
# 
#  # Setting these sequences to hero 1, weapon 1, combos 1 & 2
#  PRABS::HERO.add_sequence(1, 1, 1, data)
#  PRABS::HERO.add_sequence(1, 1, 2, data)
#
#  # Data
#  data = []
#  data << [a, b, c, d, e]
#  data << [a, b, c, d, e]
#  data << [a, b, c, d, e]
#  data << [a, b, c, d, e]
#  data << [a, b, c, d, e]
#
#  # Setting these sequences to hero 1, weapon 1, combo 3
#  PRABS::HERO.add_sequence(1, 1, 3, data)
#
#  # Setting the Max combo to hero 1, weapon 1, max combo 3, delay 30 frames
#  PRABS::HERO.set_combo_max(1, 1, 3, 30)
#===============================================================================

module PRABS::SEQUENCE
  
  #-----------------------------------------------------------------------------
  # Sequences
  #-----------------------------------------------------------------------------
  SEQUENCES["a"] = [ATTACK]
  SEQUENCES["fa"] = [FRONT, ATTACK]
  SEQUENCES["ba"] = [BACK, ATTACK]
  SEQUENCES["ffa"] = [FRONT, FRONT, ATTACK]
  SEQUENCES["bfa"] = [BACK, FRONT, ATTACK]
  
#===============================================================================
# Sword
#===============================================================================

  data = [
    # Normal Attack, Image "Graphics/Characters/CharName + FrontAttack", delay 0, Continue the combo
    [SEQUENCES["a"], 0, "FrontAttack", 0, false],
    # Front + Attack Button, Image "Graphics/Characters/CharName + FrontAttack", delay 0, Continue the combo
    [SEQUENCES["fa"], 84, "FrontAttack", 0, false],
    # Front + Front + Attack Button, Image "Graphics/Characters/CharName + FrontFrontAttack", delay 0, Finish the combo
    #[SEQUENCES["ffa"], 85, "FrontFrontAttack", 0, true],

    [SEQUENCES["bfa"], 84, "SwordCircle", 30, true]
  ]
  # Setting these sequences to hero 1, weapon 1, combo 0 (all combos)
   # Armas de Kiro
  PRABS::HERO.add_sequence(9, 2, 0, data)
  PRABS::HERO.add_sequence(9, 6, 0, data)
  PRABS::HERO.add_sequence(9, 10, 0, data)
  PRABS::HERO.add_sequence(9, 13, 0, data)
  PRABS::HERO.add_sequence(9, 16, 0, data)
  PRABS::HERO.add_sequence(9, 21, 0, data)
  PRABS::HERO.add_sequence(9, 29, 0, data)
  PRABS::HERO.add_sequence(9, 30, 0, data)
  PRABS::HERO.add_sequence(9, 33, 0, data)
  
  # Setting the Max combo to hero 1, weapon 1, max combo 5, delay 60 frames
   # Max combos de Kiro
  PRABS::HERO.set_combo_max(9, 2, 3, 60)
  PRABS::HERO.set_combo_max(9, 6, 3, 60)
  PRABS::HERO.set_combo_max(9, 10, 5, 60)
  PRABS::HERO.set_combo_max(9, 13, 5, 60)
  PRABS::HERO.set_combo_max(9, 16, 5, 60)
  PRABS::HERO.set_combo_max(9, 21, 5, 60)
  PRABS::HERO.set_combo_max(9, 29, 7, 30)
  PRABS::HERO.set_combo_max(9, 30, 4, 60)
  PRABS::HERO.set_combo_max(9, 33, 1, 10)
  
#===============================================================================
# Bow
#===============================================================================

  data = [
    [SEQUENCES["a"], 88, "Arco", 0, false, 2] # F: Offset of distance to attack
  ]

  # Setting these sequences to hero 1, weapon 2, combo 0 (all combos)
  # Arma de Nick
  PRABS::HERO.add_sequence(1, 4, 0, data)
  PRABS::HERO.add_sequence(1, 11, 0, data)

  data = [
    [SEQUENCES["a"], 88, "Arco", 0, false, 3] # F: Offset of distance to attack
  ]

  PRABS::HERO.add_sequence(1, 17, 0, data)
  PRABS::HERO.add_sequence(1, 24, 0, data)

  # Setting the Max combo to hero 1, weapon 2, max combo 1, delay 20 frames
  
  PRABS::HERO.set_combo_max(1, 4, 1, 20)
  PRABS::HERO.set_combo_max(1, 11, 2, 20)
  PRABS::HERO.set_combo_max(1, 17, 3, 20)
  PRABS::HERO.set_combo_max(1, 24, 4, 20)
  
#===============================================================================
# Spear
#===============================================================================

  data = [
    # Normal Attack, Image "Graphics/Characters/CharName + FrontAttack", delay 0, Continue the combo
    [SEQUENCES["a"], 0, "FrontAttack", 0, false],
    # Front + Attack Button, Image "Graphics/Characters/CharName + FrontAttack", delay 0, Continue the combo
    [SEQUENCES["fa"], 84, "FrontAttack", 0, false],
    [SEQUENCES["ffa"], 91, "FrontFrontAttack", 0, true]
  ]

   # Arma de Jezameni
  PRABS::HERO.add_sequence(2, 3, 0, data)
  PRABS::HERO.add_sequence(2, 9, 0, data)
  PRABS::HERO.add_sequence(2, 14, 0, data)
  PRABS::HERO.add_sequence(2, 20, 0, data)
  PRABS::HERO.add_sequence(2, 27, 0, data)

  # Max combo de Jezameni
  PRABS::HERO.set_combo_max(2, 3, 3, 30)
  PRABS::HERO.set_combo_max(2, 20, 4, 20)
  PRABS::HERO.set_combo_max(2, 27, 5, 15)

#===============================================================================
# Pickaxe
#===============================================================================

data = [
  # Normal Attack, Image "Graphics/Characters/CharName + Pickaxe", delay 0, Continue the combo
  [SEQUENCES["a"], 0, "Pickaxe", 0, false],
  # Front + Attack Button, Image "Graphics/Characters/CharName + Pickaxe", delay 0, Continue the combo
  [SEQUENCES["fa"], 0, "Pickaxe", 0, false]
]

# Pico
PRABS::HERO.add_sequence(9, 33, 0, data)
PRABS::HERO.add_sequence(1, 33, 0, data)
PRABS::HERO.add_sequence(2, 33, 0, data)

# Max combo para Pico
PRABS::HERO.set_combo_max(9, 33, 1, 20)
PRABS::HERO.set_combo_max(1, 33, 1, 20)
PRABS::HERO.set_combo_max(2, 33, 1, 20)
  
end
