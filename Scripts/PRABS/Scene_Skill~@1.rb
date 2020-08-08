#==============================================================================
# ■ Scene_skill
#------------------------------------------------------------------------------
# 　アイテム画面の処理を行うクラスです。
#==============================================================================

class Scene_Skill < Scene_Base

  alias pr_abs_scskill_terminate terminate
  alias pr_abs_scskill_update update
  alias pr_abs_scskill_update_skill_selection update_skill_selection
  
  def terminate
    $game_temp.hotkey_message_counter = 0
    pr_abs_scskill_terminate
  end
  
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  
  def update
    pr_abs_scskill_update
    if $game_temp.hotkey_message_counter > 0
      @help_window.set_text($game_temp.hotkey_message)
      $game_temp.hotkey_message_counter -= 1
    end
  end
  
  #--------------------------------------------------------------------------
  # ● アイテム選択の更新
  #--------------------------------------------------------------------------
  
  def update_skill_selection
    unless @skill_window.skill.nil?
      for hotkey in $game_player.hotkeys
        if Input.trigger?(hotkey.key)
          for hotkey2 in $game_player.hotkeys
            hotkey2.clear if hotkey2.skill?(@skill_window.skill.id)
          end
          $game_temp.hotkey_message_counter = 60
          $game_temp.hotkey_message = "Técnica equipada #{@skill_window.skill.name}"
          hotkey.set_skill(@skill_window.skill.id)
          return
        end
      end
    end
    pr_abs_scskill_update_skill_selection
  end

end
