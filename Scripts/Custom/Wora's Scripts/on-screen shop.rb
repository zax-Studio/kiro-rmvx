#=======================================================================
# ● [VX] ◦ On-Screen Shop ◦ □
#-------------------------------------------------------------------
# ◦ by Woratana [woratana@hotmail.com]
# ◦ Thaiware RPG Maker Community
# ◦ Released on: 14/05/2008
# ◦ Version: 1.0
#=======================================================================

class Scene_Shop < Scene_Base
  
  USE_SPRITESET = true
  # Do you want to use real map as background? (tile will animate)
  
  #--------------------------------------------------------------------------
  # * Start processing
  #--------------------------------------------------------------------------
  alias wora_sceshop_str_oshop start
  def start
    wora_sceshop_str_oshop
    @spriteset = Spriteset_Map.new if USE_SPRITESET
    @gold_window.x = Graphics.width - @gold_window.width - 24
    @gold_window.y = Graphics.height - @gold_window.height - 24
    @buy_window.x = @sell_window.x = 0
    @number_window.x = 0
    @dummy_window.y = @help_window.height
    @buy_window.y = @sell_window.y = @help_window.height
    @number_window.y = @status_window.y = @help_window.height
    @buy_window.height = @sell_window.height = 200
    @number_window.height = @status_window.height = 200
    @dummy_window.y = Graphics.height
    @status_window.create_contents
    @help_window.visible = false
  end
  #--------------------------------------------------------------------------
  # * Termination Processing
  #--------------------------------------------------------------------------
  alias wora_sceshop_ter_oshop terminate
  def terminate
    wora_sceshop_ter_oshop
    @spriteset.dispose if USE_SPRITESET
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  alias wora_sceshop_upd_oshop update
  def update
    wora_sceshop_upd_oshop
    if @command_window.active
      @help_window.visible = false
    elsif @buy_window.active
      @help_window.visible = @buy_window.visible
    elsif @sell_window.active
      @help_window.visible = @sell_window.visible
    end
    @spriteset.update if USE_SPRITESET
  end
  #--------------------------------------------------------------------------
  # * Create Command Window
  #--------------------------------------------------------------------------
  def create_command_window
    s1 = Vocab::ShopBuy
    s2 = Vocab::ShopSell
    s3 = Vocab::ShopCancel
    @command_window = Window_Command.new(120, [s1, s2, s3])
    @command_window.y = Graphics.height - @command_window.height - 24
    @command_window.x = 24
    if $game_temp.shop_purchase_only
      @command_window.draw_item(1, false)
    end
  end
end

class Window_ShopNumber < Window_Base
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    y = 64
    self.contents.clear
    draw_item_name(@item, 0, y)
    self.contents.font.color = normal_color
    self.contents.draw_text(212, y, 20, WLH, "×")
    self.contents.draw_text(248, y, 20, WLH, @number, 2)
    self.cursor_rect.set(244, y, 28, WLH)
    draw_currency_value(@price * @number, 4, y + WLH * 2, 264)
  end
end

class Window_ShopStatus < Window_Base
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    self.contents.clear
    if @item != nil
      number = $game_party.item_number(@item)
      self.contents.font.color = system_color
      self.contents.draw_text(4, 0, 200, WLH, Vocab::Possession)
      self.contents.font.color = normal_color
      self.contents.draw_text(4, 0, 200, WLH, number, 2)
      for actor in $game_party.members
        x = 4
        y = WLH * (2 + actor.index)
        draw_actor_parameter_change(actor, x, y)
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Draw Actor's Current Equipment and Parameters
  #--------------------------------------------------------------------------
  def draw_actor_parameter_change(actor, x, y)
    return if @item.is_a?(RPG::Item)
    enabled = actor.equippable?(@item)
    self.contents.font.color = normal_color
    self.contents.font.color.alpha = enabled ? 255 : 128
    self.contents.draw_text(x, y, 200, WLH, actor.name)
    if @item.is_a?(RPG::Weapon)
      item1 = weaker_weapon(actor)
    elsif actor.two_swords_style and @item.kind == 0
      item1 = nil
    else
      item1 = actor.equips[1 + @item.kind]
    end
    if enabled
      if @item.is_a?(RPG::Weapon)
        atk1 = item1 == nil ? 0 : item1.atk
        atk2 = @item == nil ? 0 : @item.atk
        change = atk2 - atk1
      else
        def1 = item1 == nil ? 0 : item1.def
        def2 = @item == nil ? 0 : @item.def
        change = def2 - def1
      end
      if change > 0 # If increase status
        
      elsif change < 0 # If decrease status
        self.contents.font.color.alpha = 128
      else # if not change status
        self.contents.font.color.alpha = 128
      end
      self.contents.draw_text(x, y, 200, WLH, sprintf("%+d", change), 2)
    end
  end
end