#~ -----------------------------------------------------------------------------
#~ |                        $Game Over Menu by Moon$                           |
#~ -----------------------------------------------------------------------------
#~ |      What this script do?                                                 |
#~ |  It adds menu in the Gameover scene                                       |
#~ |  You will be able to choose between                                       |
#~ |       "Back to the title"                                                 |
#~ |       "Continue"                                                          |
#~ |       "Shutdown"                                                          |
#~ |  Ufcourse, these menus are all vocab and can be changed                   |
#~ -----------------------------------------------------------------------------


module Vocab
  #~ Change the vocab here if you want something different
  Back_to_title = "Inicio"
end


class Scene_Gameover < Scene_Base  
  def start
    super
    RPG::BGM.stop
    RPG::BGS.stop
    $data_system.gameover_me.play
    create_gameover_graphic
    check_continue
    create_game_over_window
    @gold_window = Window_Gold.new(384, 0)
  end
  
  def update
    super
    @gold_window.update
    @command_window.update
    if Input.trigger?(Input::C)
      case @command_window.index
      when 0    # Back to title
      $scene = Scene_Title.new
      Graphics.fadeout(120)
      when 1    # Continue
        command_continue
      when 2    # Shutdown
        command_shutdown
      end
    end
  end
  
  def terminate
    super
    @gold_window.dispose
    dispose_command_window
    snapshot_for_background
    dispose_title_graphic
  end
  
  def create_game_over_window
    s1 = Vocab::Back_to_title
    s2 = Vocab::continue
    s3 = Vocab::shutdown
    @command_window = Window_Command.new(172, [s1, s2, s3])
    @command_window.x = (544 - @command_window.width) / 2
    @command_window.y = 288
    if @continue_enabled
      @command_window.index = 1
    else
      @command_window.draw_item(1, false)
    end
    @command_window.openness = 0
    @command_window.open
  end
  
  def dispose_command_window
    @command_window.dispose
  end
  
  def dispose_title_graphic
    @sprite.bitmap.dispose
    @sprite.dispose
  end
  
  def check_continue
    @continue_enabled = (Dir.glob('Save*.rvdata').size > 0)
  end
  
  def command_continue
    if @continue_enabled
      Sound.play_decision
      $scene = Scene_File.new(false, true, false)
    else
      Sound.play_buzzer
    end
  end
  
  def command_shutdown
    Sound.play_decision
    RPG::BGM.fade(800)
    RPG::BGS.fade(800)
    RPG::ME.fade(800)
    $scene = nil
  end
end