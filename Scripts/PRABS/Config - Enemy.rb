#==============================================================================
# Congig - Animation
# -----------------------------------------------------------------------------
# Setting the Enemy's Animation
# -----------------------------------------------------------------------------
# 1 - Setupping an Attack for Enemy (Picture Animation Only)
#       self.setup_attack_enemy_animation(a, b, c, d)
#       a - Enemy ID
#       b - Number of the sequency (0 for all)
#       c - Animation Name
#       d - Animation ID
# -----------------------------------------------------------------------------
# 2 - Setting an Skill for Enemy(Animação de Picture)
#       self.setup_skill_enemy_animation(a, b, c)
#       a - Enemy ID
#       b - Skill ID
#       c - Animation Name
#-----------------------------------------------------------------------------
# *Obs: Image name will be $Char_name + Animation Name
# Ex:
# self.setup_skill_enemy_animation(1, 0, "Habilidade", 1)
# Event's character name: "$Inimigo"
# "Graphics/Characters/$Inimigo/Habilidade.ext"
#==============================================================================

module PRABS::CONFIG::ENEMY

    DEFAULT_ANIMATION_ATTACK_ID = 84
  
    # Wasp - ID 3, 47
    self.setup_attack_enemy_animation([3, 47], 0, "", 92)

    # Bat - ID 21, 14
    self.setup_attack_enemy_animation([2, 14], 0, "", 93)

    # Wolves - ID 46
    self.setup_attack_enemy_animation(46, 0, "", 94)

    # Valorias - ID 49, 50
    self.setup_attack_enemy_animation([49, 50], 0, "", 95)

    # Bosses - ID 33, 36, 37, 38, 39, 52
    self.setup_attack_enemy_animation([33, 36, 37, 38, 39, 52], 0, "", 96)

    # Ice - ID 19, 40
    self.setup_attack_enemy_animation([19, 40], 0, "", 97)

    # Big Monsters - ID 17, 41, 44, 45, 48
    self.setup_attack_enemy_animation([17, 41, 44, 45, 48], 0, "", 98)
end
