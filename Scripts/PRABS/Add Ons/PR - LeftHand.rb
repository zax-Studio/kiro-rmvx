################################################################################
################################################################################
########################  PR - LeftHand ########################################
################################################################################
################################################################################
#==============================================================================
# Pode selecionar tanto um escudo quanto uma arma na mão esquerda
#==============================================================================
  script_name = "LeftHand"
  version = 1.0
#==============================================================================
# Verifica se pode carregar o script
#==============================================================================

PRCoders.log_script(script_name, version)

if PRCoders.check_enabled?(script_name, version)

PRCoders.load_script(script_name, version)

#==============================================================================
# Game_Actor
#==============================================================================

class Game_Actor < Game_Battler
  
  #--------------------------------------------------------------------------
  # ● Váriável
  #--------------------------------------------------------------------------
 
  attr_writer :two_swords_style
  
  #--------------------------------------------------------------------------
  # ● Alias
  #--------------------------------------------------------------------------
 
  alias pr_abs_gactor_initialize initialize
  
  #--------------------------------------------------------------------------
  # ● Inicialização
  #--------------------------------------------------------------------------
 
  def initialize(actor_id)
    pr_abs_gactor_initialize(actor_id)
    @two_swords_style = actor.two_swords_style
  end
  
  #--------------------------------------------------------------------------
  # ● Duas mãos?
  #--------------------------------------------------------------------------
 
  def two_swords_style
    return @two_swords_style
  end
  
  #--------------------------------------------------------------------------
  # ● Equipável na segunda mão?
  #--------------------------------------------------------------------------
 
  def second_hand_equippable?(item)
    if item.is_a?(RPG::Weapon)
      return self.class.weapon_set.include?(item.id)
    elsif item.is_a?(RPG::Armor)
      return self.class.armor_set.include?(item.id)
    end
    return false
  end
  
end
  
#==============================================================================
# Scene_Equip
#==============================================================================

class Scene_Equip < Scene_Base
  
  #--------------------------------------------------------------------------
  # ● Atualiza o Item
  #--------------------------------------------------------------------------
  
  def update_item_selection
    if Input.trigger?(Input::B)
      Sound.play_cancel
      @equip_window.active = true
      @item_window.active = false
      @item_window.index = -1
    elsif Input.trigger?(Input::C)
      Sound.play_equip
      @actor.change_equip(@equip_window.index, @item_window.item)
      if @equip_window.index == 1
        if @item_window.item.is_a?(RPG::Weapon)
          @actor.two_swords_style = true
        else
          @actor.two_swords_style = false
        end
      end
      @equip_window.active = true
      @item_window.active = false
      @item_window.index = -1
      @equip_window.refresh
      for item_window in @item_windows
        item_window.refresh
      end
    end
  end
end

#==============================================================================
# ■ Window_EquipItem
#==============================================================================

class Window_EquipItem < Window_Item
 
  #--------------------------------------------------------------------------
  # Inicialização
  #--------------------------------------------------------------------------
  
  def initialize(x, y, width, height, actor, equip_type)
    @actor = actor
    @equip_type = equip_type
    super(x, y, width, height)
  end
  
  #--------------------------------------------------------------------------
  # ● Inclui na janela?
  #--------------------------------------------------------------------------
 
  def include?(item)
    return true if item == nil
    if @equip_type == 0
      return false unless item.is_a?(RPG::Weapon)
    elsif @equip_type == 1
      if item.is_a?(RPG::Weapon) or (item.is_a?(RPG::Armor) and item.kind == 0)
        return @actor.second_hand_equippable?(item)
      else
        return false
      end
    else
      return false unless item.is_a?(RPG::Armor)
      return false unless item.kind == @equip_type - 1
    end
    return @actor.equippable?(item)
  end
  
end

end

