#==============================================================================
# ■ Scene_item
#------------------------------------------------------------------------------
# 　アイテム画面の処理を行うクラスです。
#==============================================================================

class Scene_Item < Scene_Base

  alias pr_abs_scitem_terminate terminate
  alias pr_abs_scitem_update update
  alias pr_abs_scitem_update_item_selection update_item_selection
  
  def terminate
    $game_temp.hotkey_message_counter = 0
    pr_abs_scitem_terminate
  end
  
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  
  def update
    pr_abs_scitem_update
    if $game_temp.hotkey_message_counter > 0
      @help_window.set_text($game_temp.hotkey_message)
      $game_temp.hotkey_message_counter -= 1
    end
  end
  
  #--------------------------------------------------------------------------
  # ● アイテム選択の更新
  #--------------------------------------------------------------------------
  NOT_HUD_CONSUMABLE_TEXT = "*NOTHUD"

  def update_item_selection
    unless @item_window.item.nil?
      if @item_window.item.is_a?(RPG::Item) && !@item_window.item.note.include?(NOT_HUD_CONSUMABLE_TEXT)
        for hotkey in $game_player.hotkeys
          if Input.trigger?(hotkey.key)
            for hotkey2 in $game_player.hotkeys
              hotkey2.clear if hotkey2.item?(@item_window.item.id)
            end
            $game_temp.hotkey_message_counter = 60
            $game_temp.hotkey_message = "Objeto equipado #{@item_window.item.name}"
            hotkey.set_item(@item_window.item.id)
            break
          end
        end
      end
    end
    pr_abs_scitem_update_item_selection
  end

end
