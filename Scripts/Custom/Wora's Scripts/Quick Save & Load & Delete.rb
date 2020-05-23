#=======================================================================
# ● [VX] ◦ Quick Save / Load / Delete ◦ □
# * Save/Load/Delete save file you want with call script * 
#-------------------------------------------------------------------
# ◦ by Woratana [woratana@hotmail.com]
# ◦ Thaiware RPG Maker Community
# ◦ Released on: 22/05/2008
# ◦ Version: 1.0
#=======================================================================

#==================================================================
# ** FEATURES **
#-----------------------------------------------------------------
# - Call script to save/load/delete any save slot
# - Compatible with most of the scripts that edited Scene_File

#==================================================================
# ** HOW TO USE **
#-----------------------------------------------------------------
# - To do a quick save, call script:
#  $save.do(slot)
# For example: $save.do(1)
# * Script above will save in slot 1
#
# - To do a quick save on last slot that you use quick save, call script:
#  $save.redo
#-----------------------------------------------------------------
# - To do a quick load, call script:
#  $load.do(slot)
#
# - To do a quick load on last slot that you use quick load, call script:
#  $load.redo
#-----------------------------------------------------------------
# - To do a quick delete save file, call script:
#  $save.del(slot)
#-----------------------------------------------------------------
#                             +[ TIP ]+
# If you want to use value in variable for slot, type this for slot:
# $game_variables[variable_id]
# For example: $save.do ($game_variables[1])
#===========================================================================

#--------------------------
# ** START SETUP PART
#--------------------------

QUICK_LOAD_FADE_SCREEN = true # (true/false)
# Do you want screen to fade when using Quick Load?

#--------------------------
# ** END SETUP PART
#--------------------------

$worale = {} if $worale.nil?
$worale["QuickSave"] = true
#-------------------------------
# Quick Save
#-------------------------------
class Quick_Save
  def do(slot = 0)
    return if slot == 0
    $game_system.last_qsave_slot = slot
    save = Scene_File.new(false,false,false,1,slot)
  end
  
  def redo
    save = Scene_File.new(false,false,false,1, $game_system.last_qsave_slot)
  end
  
  def del(slot = 0)
    return if slot == 0
    delete = Scene_File.new(false,false,false,3,slot)
  end
end
$save = Quick_Save.new
#-------------------------------
# Quick Load
#-------------------------------
class Quick_Load
  def do(slot = 0)
    return if slot == 0
    $game_system.last_qload_slot = slot
    save = Scene_File.new(false,false,false,2,slot)
  end
  
  def redo
    save = Scene_File.new(false,false,false,2, $game_system.last_qsave_slot)
  end
end
$load = Quick_Load.new
#------------------------------------
# Game System: Store Variables
#------------------------------------
class Game_System
  attr_accessor :last_qsave_slot, :last_qload_slot
  alias wor_qsave_gamsys_ini initialize
  def initialize
    wor_qsave_gamsys_ini
    @last_qsave_slot = 1
    @last_qload_slot = 1
  end
end
#------------------------------------
# Scene File: Save/Load/Delete File
#------------------------------------
class Scene_File < Scene_Base
  alias wor_qsave_scefil_ini initialize
  
  def initialize(saving, from_title, from_event, skip = 0, slot = 0)
    filename = make_filename(slot - 1) if slot > 0
    if skip == 1 and slot > 0
      file = File.open(filename, "wb")
      write_save_data(file)
      file.close
      return
    elsif skip == 2 and slot > 0
      return if not FileTest.exist?(filename)
      file = File.open(filename, "rb")
      read_save_data(file)
      file.close
      $scene = Scene_Map.new
      if QUICK_LOAD_FADE_SCREEN
        RPG::BGM.fade(1)
        Graphics.fadeout(1)
        Graphics.wait(1)
      end
      @last_bgm.play
      @last_bgs.play
    elsif skip == 3 and slot > 0
      File.delete(filename) if FileTest.exist?(filename)
    else
      wor_qsave_scefil_ini(saving, from_title, from_event)
    end
  end
end