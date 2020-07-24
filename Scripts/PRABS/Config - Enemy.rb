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
  
    # Wasp - 3
    self.setup_attack_enemy_animation(3, 0, "", 92)

    # Bat - ID 2
    self.setup_attack_enemy_animation(2, 0, "", 93)

    # Valorias - ID 49, 50
    self.setup_attack_enemy_animation([49, 50], 0, "", 95)

    # Ice - ID 40
    self.setup_attack_enemy_animation([40], 0, "", 97)

    # Bosses - ID 33,36,37,38,39,52
    self.setup_attack_enemy_animation([33,36,37,38,39,52], 0, "", 96)
end
