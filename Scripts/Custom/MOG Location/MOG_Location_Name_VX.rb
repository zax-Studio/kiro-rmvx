#_______________________________________________________________________________
# MOG_Location_Name_VX V1.0
#_______________________________________________________________________________
# By Moghunter
# http://www.atelier-rgss.com
#_______________________________________________________________________________
# Apresenta uma janela com o nome do map.
# É necessário ter uma imagem com o nome de  MAPNAME
# dentro da pasta Graphics/System.
#_______________________________________________________________________________
module MOG
  #Font Name.
  MPFONT = "Press Start 2P"
  #Fade ON/OFF(True - False).
  MPNMFD = true
  #Fade Time.
  MPNMTM = 12
  #Window Position.
  # 0 = Upper Left.
  # 1 = Lower Left.
  # 2 = Upper Right.
  # 3 = Lower Right.
  MPNMPS = 3
  # Disable Switch(ID).
  WM_SWITCH_VIS_DISABLE = 56

  @PREVIOUSMAP = ""
end

#_________________________________________________
###############
# Game_System #
###############
class Game_System
  attr_accessor :fdtm
  attr_accessor :mpnm_x
  attr_accessor :mpnm_y
  alias mog_vx06_initialize initialize

  def initialize
    mog_vx06_initialize
    @fdtm = 255 + 40 * MOG::MPNMTM
    if MOG::MPNMPS == 0
      @mpnm_x = -300
      @mpnm_y = 0
    elsif MOG::MPNMPS == 1
      @mpnm_x = -300
      @mpnm_y = 320
    elsif MOG::MPNMPS == 2
      @mpnm_x = 640
      @mpnm_y = 0
    else
      @mpnm_x = 640
      @mpnm_y = 320
    end
  end

  def mpnm_x
    return @mpnm_x
  end

  def mpnm_y
    return @mpnm_y
  end

  def fdtm
    if @fdtm <= 0
      @fdtm = 0
    end
    return @fdtm
  end
end

############
# Game_Map #
############
class Game_Map
  attr_reader :map_id

  def mpname
    $mpname = load_data("Data/MapInfos.rvdata")
    $mpname[@map_id].name
  end
end

###############
# Window Base #
###############
class Window_Base < Window
  def nd_mapic
    mapic = Cache.system("")
  end

  def draw_mpname(x, y)
    mapic = Cache.system("untitled3") rescue nd_mapic
    cw = mapic.width
    ch = mapic.height
    src_rect = Rect.new(0, 0, cw, ch)
    $MapName = $game_map.mpname.to_s if $MapName  == nil
    self.contents.blt(x, y - ch + 65, mapic, src_rect)
    self.contents.font.name = MOG::MPFONT
    self.contents.font.size = 22
    self.contents.font.bold = true
    self.contents.font.shadow = false
    self.contents.font.color = Color.new(0, 0, 0, 255)
    self.contents.draw_text(x + 77, y + 27, 110, 32, $MapName, 1)
    self.contents.font.color = Color.new(255, 255, 255, 255)
    self.contents.draw_text(x + 75, y + 25, 110, 32, $MapName, 1)
    $MapName = nil
  end
end

##########
# Mpname #
##########
class Mpname < Window_Base
  def initialize(x, y)
    super($game_system.mpnm_x, $game_system.mpnm_y, 250, WLH + 70)
    self.opacity = 0
    refresh
  end

  def refresh
    self.contents.clear
    draw_mpname(10, 0)
  end
end

#############
# Scene_Map #
#############
class Scene_Map
  alias mog_vx06_start start

  def start
    @mpnm = Mpname.new($game_system.mpnm_x, $game_system.mpnm_y)
    @mpnm.contents_opacity = $game_system.fdtm
    if $game_switches[MOG::WM_SWITCH_VIS_DISABLE] == false
      @mpnm.visible = true
    else
      @mpnm.visible = false
    end
    mog_vx06_start
  end

  alias mog_vx06_terminate terminate

  def terminate
    mog_vx06_terminate
    @mpnm.dispose
  end

  alias mog_vx06_update update

  def update
    mog_vx06_update
    location_name_update
  end

  def location_name_update
    $game_system.mpnm_x = @mpnm.x
    $game_system.mpnm_y = @mpnm.y
    if $game_switches[MOG::WM_SWITCH_VIS_DISABLE] == true or $game_system.fdtm <= 0
      @mpnm.visible = false
    else
      @mpnm.visible = true
    end
    if MOG::MPNMPS == 0 or MOG::MPNMPS == 1
      if @mpnm.x < 0
        @mpnm.x += 5
      elsif @mpnm.x >= 0
        @mpnm.x = 0
      end
    else
      if @mpnm.x > 300
        @mpnm.x -= 5
      elsif @mpnm.x <= 300
        @mpnm.x = 300
      end
    end
    @mpnm.contents_opacity = $game_system.fdtm
    if MOG::MPNMFD == true
      $game_system.fdtm -= 3
    end
  end

  alias mog_vx06_update_transfer_player update_transfer_player

  def update_transfer_player
    return unless $game_player.transfer?
    @mpnm.contents_opacity = 0
    mog_vx06_update_transfer_player
    if MOG::MPNMPS == 0
      $game_system.mpnm_x = -340
      $game_system.mpnm_y = 0
    elsif MOG::MPNMPS == 1
      $game_system.mpnm_x = -340
      $game_system.mpnm_y = 320
    elsif MOG::MPNMPS == 2
      $game_system.mpnm_x = 640
      $game_system.mpnm_y = 0
    else
      $game_system.mpnm_x = 640
      $game_system.mpnm_y = 320
    end
    @mpnm.y = $game_system.mpnm_y
    @mpnm.x = $game_system.mpnm_x
    $game_system.fdtm = 255 + 60 * MOG::MPNMTM
    @mpnm.refresh
  end
end

$mogscript = {} if $mogscript == nil
$mogscript["location_name_vx"] = true
