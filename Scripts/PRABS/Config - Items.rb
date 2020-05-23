#==============================================================================
# PRABS::CONFIG::DATABASE
# -----------------------------------------------------------------------------
# Items
# -----------------------------------------------------------------
# !!!! See LINE 44 to check the Drop Items !!!!
# -----------------------------------------------------------------
# 1 - Setting a normal Item
#    ITEMS[id] = [a, b, c, d]
#    a - Number of houses in front of the player
#    b - Range
#    c - Type:
#        LINHA : Linear
#        CRUZ  : Crux
#        RED   : Circle
#        QUAD  : Square
#    d - Image name when the you uses it (Use "" for default) 
# -----------------------------------------------------------------
# 2 - Setting a shootable Item
#    ITEMS[id] = [a, b, SHOOT, c]
#    a - Map ID
#    b - Event ID
#    c - Image Name (Use "" for default)
# -----------------------------------------------------------------
# 3 - Setting the Default Item:
#    DEFAULT_ITEM = [a, b, c, d]
#==============================================================================

module PRABS::CONFIG::DATABASE
  
  # Default Item:
  # 1 House in Front, Range 1, Circular Area, No Image
  DEFAULT_ITEM = [1, 1, RED, ""]
  
  # Item 4 - Potion
  ITEMS[34] = [0, 1, QUAD, ""]
  
  # Bomb
  ITEMS[36] = [64, 4, SHOOT, ""] 
  
#==============================================================================
# Items Dropped by the enemey
#------------------------------------------------------------------------------
# Setting the configuration of the dropped items
#------------------------------------------------------------------------------
# 1 - Setting an item to catch automatically when catch it on the map.
#    CATCH_AND_USE_ITEMS[id] = true   
# -----------------------------------------------------------------
# 2 - Setting the "Catch and Use" animation
#    CATCH_ITEM_ANIMATIONS[id] = Animation ID
# -----------------------------------------------------------------
# 3 - Default "Catch and Use" animation
#    DEFAULT_CATCH_ITEM_ANIMATION = Animation ID
#==============================================================================

  
  DEFAULT_CATCH_ITEM_ANIMATION = 85
  
  # Orb de HP
  CATCH_AND_USE_ITEMS[31] = true
  
  # Orb de MP
  CATCH_AND_USE_ITEMS[32] = true
  
  # Orb de HP e MP
  CATCH_AND_USE_ITEMS[33] = true
  
  CATCH_AND_USE_ITEMS[37] = true
  
  CATCH_AND_USE_ITEMS[38] = true
  
  CATCH_AND_USE_ITEMS[39] = true
  

end
