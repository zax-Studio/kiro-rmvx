################################################################################
########################  PR - Many Items #####################################
################################################################################
#==============================================================================
# Can Drop more than 2 items
#==============================================================================

module PRManyItems
  
  DATA = []
  # item1 = [type, id, chance]
  # type : 1 - Item
  #        2 - Weapon
  #        3 - Armor
  # id : Id
  # chance : 1 - 100   %  (1/1)
  #          2 - 50    %  (1/2)
  #          3 - 33,33 %  (1/3)
  #          4 - 25    %  (1/4)
  #          ....
  #          8   - 12,5  %  (1/8)
  #          ....
  #          100 - 1     % (1/100)
  # DATA[enemy ID] = [item1, item2, ..., item n]
  
  orb_hp = [1, 31, 2]
  #orb_mp = [1, 32, 5]
  #jin = [1, 37, 5]
  jin_plus = [1, 38, 4]
  #jin_plus_plus = [1, 39, 9]
  flechas = [1, 13, 2]
  bomba = [1, 36, 6]
  madera = [1, 14, 4]
  reanimador = [1, 5, 5]

  DEFAULT_DROP_ITEMS = [orb_hp, jin_plus, flechas, madera, bomba, reanimador]
  
  orb_hp = [1, 31, 1]
  orb_hp_mp = [1, 33, 3]
  flechas = [1, 13, 2]
  reanimador = [1, 5, 4]

  DATA[49] = [orb_hp, orb_hp_mp, flechas, reanimador]
  DATA[47] = [orb_hp_mp, flechas, reanimador]
  
end

#==============================================================================
# Nome do Script
#==============================================================================
  script_name = "ManyItems"
  version = 1.0
#==============================================================================
# Verifica se pode carregar o script
#==============================================================================
PRCoders.log_script(script_name, version)

if PRCoders.check_enabled?(script_name, version)

PRCoders.load_script(script_name, version)

#==============================================================================
# Classe Game_Enemy
#==============================================================================

class Game_Enemy < Game_Battler
  
  def drop_items
    data = []
    if PRManyItems::DATA[self.enemy_id] != nil
      data = PRManyItems::DATA[self.enemy_id]
    else
      data = PRManyItems::DEFAULT_DROP_ITEMS
    end
    return get_many_drop_items(data)
  end
  
  def get_many_drop_items(drop_items)
    items = [self.drop_item1, self.drop_item2]
    for type, id, denominator in drop_items
      item = RPG::Enemy::DropItem.new
      item.kind = type
      item.denominator = denominator
      case type
      when 1
        item.item_id = id
      when 2
        item.weapon_id = id
      when 3
        item.armor_id = id
      else
        next
      end
      items.push(item)
    end
    return items
  end

end

#==============================================================================
# Game_Troop
#==============================================================================

class Game_Troop
  
  #--------------------------------------------------------------------------
  # ● Make Drop
  #--------------------------------------------------------------------------
  def make_drop_items
    drop_items = []
    for enemy in dead_members
      for di in enemy.drop_items
        next if di.kind == 0
        next if rand(di.denominator) != 0
        if di.kind == 1
          drop_items.push($data_items[di.item_id])
        elsif di.kind == 2
          drop_items.push($data_weapons[di.weapon_id])
        elsif di.kind == 3
          drop_items.push($data_armors[di.armor_id])
        end
      end
    end
    return drop_items
  end

end

#==============================================================================
# Fim da verificação
#==============================================================================

end
