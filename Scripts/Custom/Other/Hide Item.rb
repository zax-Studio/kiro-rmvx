#==============================================================================
# ** Hide Item Snippet
#------------------------------------------------------------------------------
# Author  : puppeto4 (puppeto5@hotmail.com)
# Version : 1.0 revision 1
# Date    : 20 / 06 / 2008
# Note    : Order Pizza Hut, support the rebellion.
# Check RPG RPG Revolution(http://www.rpgrevolution.com) for support
#------------------------------------------------------------------------------
# Function :  
#   This snippet will hide choosen item from showing in item window.
#==============================================================================
# ** Puppeto
#------------------------------------------------------------------------------
#  This module handles setup for any script writen by me ^^.
#==============================================================================
module Puppeto
  # Text that need to be put in the note field to hide the item.
  Hidden_Text     = "*HIDDEN"
#==============================================================================
# ** End of Puppeto module
#------------------------------------------------------------------------------
end  
#==============================================================================
# ** Window_Item
#------------------------------------------------------------------------------
#  This window displays a list of inventory items for the item screen, etc.
#==============================================================================
class Window_Item < Window_Selectable
  #--------------------------------------------------------------------------
  # * Whether or not to include in item list
  #     item : item
  #--------------------------------------------------------------------------
  def show?(item)
    return false if item.note.include?(Puppeto::Hidden_Text)
    return true
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    @data = []
    for item in $game_party.items
      next unless include?(item) and show?(item)
      @data.push(item)
      if item.is_a?(RPG::Item) and item.id == $game_party.last_item_id
        self.index = @data.size - 1
      end
    end
    @data.push(nil) if include?(nil)
    @item_max = @data.size
    create_contents
    for i in 0...@item_max
      draw_item(i)
    end
  end  
end
#==============================================================================
# ** Window_EquipItem
#------------------------------------------------------------------------------
#  This window displays choices when opting to change equipment on the
# equipment screen.
#==============================================================================
class Window_EquipItem < Window_Item
  #--------------------------------------------------------------------------
  # * Whether to include item in list
  #     item : item
  #--------------------------------------------------------------------------
  def show?(item)
    return false if item.note.include?(Puppeto::Hidden_Text)  
    return @actor.equippable?(item)
  end
end
#==============================================================================
# ** Window_ShopSell
#------------------------------------------------------------------------------
#  This window displays items in possession for selling on the shop screen.
#==============================================================================
class Window_ShopSell < Window_Item
  #--------------------------------------------------------------------------
  # * Whether or not to include in item list
  #     item : item
  #--------------------------------------------------------------------------
  def show?(item)
    return false if item.note.include?(Puppeto::Hidden_Text)
    return true    
  end
end