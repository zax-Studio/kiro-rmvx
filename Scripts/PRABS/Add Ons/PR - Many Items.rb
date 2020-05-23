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
  orb_mp = [1, 32, 5]
  jin = [1, 37, 5]
  orb_hp_mp = [1, 33, 8]
  jin_plus = [1, 38,7]
  jin_plus_plus = [1, 39,9]
  flecha = [1, 35, 3]
  
  DATA[1] = [orb_hp, orb_mp, jin]
  DATA[2] = [orb_hp, orb_mp, jin]
  DATA[3] = [orb_hp, orb_mp, jin]
  DATA[4] = [orb_hp, orb_mp, jin]
  DATA[5] = [orb_hp, orb_mp, jin]
  DATA[6] = [orb_hp, orb_mp, jin]
  DATA[7] = [orb_hp, orb_mp, jin]
  DATA[8] = [orb_hp, orb_mp, jin, flecha]
  DATA[9] = [orb_hp, orb_mp, jin]
  DATA[10] = [orb_hp, orb_mp, orb_hp_mp, jin_plus, flecha]
  DATA[11] = [orb_hp, orb_mp, orb_hp_mp, jin_plus]
  DATA[12] = [orb_hp, orb_mp, orb_hp_mp, jin_plus]
  DATA[13] = [orb_hp, orb_mp, orb_hp_mp, jin_plus]
  DATA[14] = [orb_hp, orb_mp, orb_hp_mp, jin_plus, flecha]
  DATA[15] = [orb_hp, orb_mp, orb_hp_mp, jin_plus]
  DATA[16] = [orb_hp, orb_mp, orb_hp_mp, jin_plus]
  DATA[17] = [orb_hp, orb_mp, orb_hp_mp, jin_plus]
  DATA[18] = [orb_hp, orb_mp, orb_hp_mp, jin_plus]
  DATA[19] = [orb_hp, orb_mp, orb_hp_mp, jin_plus, flecha]
  DATA[20] = [orb_hp, orb_mp, orb_hp_mp, jin_plus_plus]
  DATA[21] = [orb_hp, orb_mp, orb_hp_mp, jin_plus_plus]
  DATA[22] = [orb_hp, orb_mp, orb_hp_mp, jin_plus_plus]
  DATA[23] = [orb_hp, orb_mp, orb_hp_mp, jin_plus_plus]
  DATA[24] = [orb_hp, orb_mp, orb_hp_mp, jin_plus_plus]
  DATA[25] = [orb_hp, orb_mp, orb_hp_mp, jin_plus_plus]
  DATA[26] = [orb_hp, orb_mp, orb_hp_mp, jin_plus_plus]
  DATA[27] = [orb_hp, orb_mp, orb_hp_mp, jin_plus_plus]
  DATA[28] = [orb_hp, orb_mp, orb_hp_mp, jin_plus_plus]
  DATA[41] = [orb_hp, orb_mp, jin_plus, flecha]
  DATA[42] = [orb_hp, orb_mp, jin_plus]
  
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
    items = [self.drop_item1, self.drop_item2]
    if PRManyItems::DATA[self.enemy_id] != nil
      for type, id, denominator in PRManyItems::DATA[self.enemy_id]
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
