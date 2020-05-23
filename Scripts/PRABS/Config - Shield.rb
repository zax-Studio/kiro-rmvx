#==============================================================================
# PRABS::CONFIG::DATABASE
# -----------------------------------------------------------------------------
# Shield
# -----------------------------------------------------------------------------
# Use:
#   skills = [1, 2, 3, 4, 5, 6, 7, 8 ... ] # skills the shield can reflect (shootable only)
#   self.setup_shield(a, b, c, skills)
#   a - Shield ID
#   b - Shield Animation
#   c - (true if hero can move using shield)
# -----------------------------------------------------------------------------
# OBS: Coloque:
#   skills = [0] # Reflect all skills (shootable only)
#==============================================================================

module PRABS::CONFIG::DATABASE
  
  skills = [0]
  self.setup_shield(1, "Guard", false, skills)
  self.setup_shield(2, "Guard", false, skills)
  self.setup_shield(3, "Guard", false, skills)
  self.setup_shield(4, "Guard", false, skills)
  self.setup_shield(5, "Guard", false, skills)
  self.setup_shield(6, "Guard", false, skills)
  
end
