#==============================================================================
# Scene_Map
#==============================================================================

class Scene_Map < Scene_Base
  
  #--------------------------------------------------------------------------
  # Alias
  #--------------------------------------------------------------------------
 
  alias pr_abs_scene_map_start start
  alias pr_abs_scene_map_update update
  alias pr_abs_scene_map_terminate terminate
  
  def start
    pr_abs_scene_map_start
    @hud = SpriteHUD.new
    @hud.setup_y
    @hud.z = 9999
    $game_map.update
    $game_player.refresh
    @hud.update
  end
  
  def update
    @hud.update
    $game_party.update
    pr_abs_scene_map_update
  end
  
  #--------------------------------------------------------------------------
  # Fim do processo
  #--------------------------------------------------------------------------
  
  def terminate
    @hud.dispose
    for event in $game_map.events.values
      event.scene_unsetup
    end
    $game_player.scene_unsetup
    pr_abs_scene_map_terminate
  end
  
end
