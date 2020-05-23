#_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
#_/   ◆       Play Time And Location Window - MRA_LocationPlayTimeWindow ◆ VX ◆
#_/   ◇                      Last Update: 2008/09/16                          ◇
#_/   ◆                      Created by Mr. Anonymous                         ◆
#_/   ◆ Creator's Blog:                                                       ◆
#_/   ◆ http://mraprojects.wordpress.com                                      ◆
#_/----------------------------------------------------------------------------
#_/  This script adds a location and playtime window into the menu.
#_/============================================================================
#_/ Install: Insert above main.
#_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/

#=============================================================================#
#                             ★ Customization ★                               #
#=============================================================================#
module MRA
  module LocationPlayTimeWindow
  #            ◆ Full Size Location and Play Time Windows Toggle ◆
  #  This toggle allows you to enable/disable the full-size Location and Play
  #   Time windows that display the below-specified messages above the values.
  #  true = Full Sized windows in effect.
  #  false = Compact windows in effect. 
    FULL_SIZE_WINDOWS = false
  #                 ◆ Use Combined PlatTime/Location Window ◆
  
    USE_COMBINED_WINDOW = false
  #                           ◆ Show Time Window ◆    
    SHOW_TIME = true
  #                          ◆ Show Location Window ◆    
    SHOW_LOCATION = false
  #                          ◆ Location Window Text ◆
    LOC_TEXT = "Lugar:"
    
  #                          ◆ PlayTime Window Text ◆
    PT_TEXT = "Tiempo de juego:"
    
  end
end
#==============================================================================
# ■ Game_Map
#==============================================================================
class Game_Map
  #--------------------------------------------------------------------------
  # ● Open Global Variable
  #--------------------------------------------------------------------------
  attr_reader   :map_id
  #--------------------------------------------------------------------------
  # ● Convert and Load Map Name
  #--------------------------------------------------------------------------
  def map_name
    $map_name = load_data("Data/MapInfos.rvdata") 
    $map_name[@map_id].name
  end
end

#==================================End Class===================================#

#==============================================================================
# ■ Window_MapName
#------------------------------------------------------------------------------
# Create the window containing the current map's name.
#==============================================================================
if MRA::LocationPlayTimeWindow::USE_COMBINED_WINDOW == false
if MRA::LocationPlayTimeWindow::SHOW_LOCATION == true
  #--------------------------------------------------------------------------
  # ● Initialize
  #--------------------------------------------------------------------------
  class Window_Mapname < Window_Base
    def initialize(x, y)
      if MRA::LocationPlayTimeWindow::FULL_SIZE_WINDOWS == true
        super(x, y + 6, 160, WLH + 64)
      else 
        super(x, y + 92, 160, WLH + 22)
      end
      refresh
    end  
    
    #--------------------------------------------------------------------------
    # ● Refresh
    #--------------------------------------------------------------------------  
    def refresh
      self.contents.clear
      self.contents.font.color = normal_color
      if MRA::LocationPlayTimeWindow::FULL_SIZE_WINDOWS == true
        self.contents.font.color = system_color
        self.contents.draw_text(4, 0, 120, 32, MRA::LocationPlayTimeWindow::LOC_TEXT)
        self.contents.font.color = normal_color
        self.contents.draw_text(4, 32, 120, 32, $game_map.map_name.to_s, 2)
      else
        self.contents.draw_text(4, -8, 120, 30, $game_map.map_name.to_s, 2)
      end
    end
  end
end
end
#==================================End Class===================================#
#==============================================================================
# ■ Window_Time
#------------------------------------------------------------------------------
# Create the window containing the running playtime.
#==============================================================================
if MRA::LocationPlayTimeWindow::USE_COMBINED_WINDOW == false
if MRA::LocationPlayTimeWindow::SHOW_TIME == true
    #--------------------------------------------------------------------------
    # ● Initialize
    #--------------------------------------------------------------------------
  class Window_Time < Window_Base
    def initialize(x, y)
      if MRA::LocationPlayTimeWindow::FULL_SIZE_WINDOWS == true
        super(x, y + 2, 160, WLH + 64)
      else
        super(x, y + 46, 160, WLH + 22)
      end
      refresh
    end
    
    #--------------------------------------------------------------------------
    # ● Refresh
    #--------------------------------------------------------------------------    
    def refresh
      self.contents.clear
      if MRA::LocationPlayTimeWindow::FULL_SIZE_WINDOWS == true
        self.contents.font.color = system_color
        self.contents.draw_text(4, 0, 120, 32, MRA::LocationPlayTimeWindow::PT_TEXT)
      end
      @total_seconds = Graphics.frame_count / Graphics.frame_rate
      
      hours    =  @total_seconds / 60 / 60
      minutes  =  @total_seconds / 60 % 60
      seconds  =  @total_seconds % 60
      
      text = sprintf("%02d:%02d:%02d",  hours,  minutes,  seconds)
      
      self.contents.font.color = normal_color
      if MRA::LocationPlayTimeWindow::FULL_SIZE_WINDOWS == true
        self.contents.draw_text(4, 32, 120, 32, text, 2)
      else 
        self.contents.draw_text(4,  -8,  120,  30,  text,  2)
      end
    end
    #--------------------------------------------------------------------------
    # ● Update
    #--------------------------------------------------------------------------  
    def update
      super
      if Graphics.frame_count / Graphics.frame_rate != @total_seconds
        refresh
      end
    end
  end
end
end

#==============================================================================
# ■ Window_TimeMapName
#------------------------------------------------------------------------------
# Create the window containing the current play time and map's name.
#==============================================================================
if MRA::LocationPlayTimeWindow::USE_COMBINED_WINDOW == true
  #--------------------------------------------------------------------------
  # ● Initialize
  #--------------------------------------------------------------------------
  class Window_TimeMapname < Window_Base
    def initialize(x, y)
      super(x, y + 4, 160, WLH + 64)
      refresh
    end  
    #--------------------------------------------------------------------------
    # ● Refresh
    #--------------------------------------------------------------------------  
    def refresh
      self.contents.clear
      self.contents.font.color = system_color
      self.contents.draw_text(-2, -12, 120, 32, MRA::LocationPlayTimeWindow::LOC_TEXT)
      self.contents.draw_text(-2,  18, 120, 32, MRA::LocationPlayTimeWindow::PT_TEXT)
      self.contents.font.color = normal_color
      self.contents.draw_text(4, 3, 120, 32, $game_map.map_name.to_s, 2)
      @total_seconds = Graphics.frame_count / Graphics.frame_rate
      
      hours    =  @total_seconds / 60 / 60
      minutes  =  @total_seconds / 60 % 60
      seconds  =  @total_seconds % 60
        
      text = sprintf("%02d:%02d:%02d",  hours,  minutes,  seconds)
      self.contents.draw_text(4, 33, 120, 32, text, 2)
    end
    #--------------------------------------------------------------------------
    # ● Update
    #--------------------------------------------------------------------------  
    def update
      super
      if Graphics.frame_count / Graphics.frame_rate != @total_seconds
        refresh
      end
    end
  end
end
#==================================End Class===================================#
#==============================================================================
# ■ Scene_Menu
#------------------------------------------------------------------------------
# Update Scene_Menu class to include the new windows.
#==============================================================================

  #--------------------------------------------------------------------------
  # ● Start Processing
  #--------------------------------------------------------------------------
class Scene_Menu < Scene_Base
  alias start_MRA_LocationPlayTimeWindow start
    def start
      if MRA::LocationPlayTimeWindow::USE_COMBINED_WINDOW == false
        if MRA::LocationPlayTimeWindow::SHOW_TIME
          @playtime_window = Window_Time.new(0,  270)
          @playtime_window.openness = 0
          @playtime_window.open
        end
        if MRA::LocationPlayTimeWindow::SHOW_LOCATION
          @mapname_window = Window_Mapname.new(0,  178)
          @mapname_window.openness = 0
          @mapname_window.open
        end
      else
        @timemapname_window = Window_TimeMapname.new(0, 270)
        @timemapname_window.openness = 0
        @timemapname_window.open
      end
=begin
      if $imported["PlaceMission"]
      @info_window = Window_Information.new
      @info_window.back_opacity = 160
      @info_window.x = 160
      @info_window.y = 264
      end
=end
      start_MRA_LocationPlayTimeWindow
    end

  #--------------------------------------------------------------------------
  # ● Termination Processing
  #--------------------------------------------------------------------------
  alias terminate_MRA_LocationPlayTimeWindow terminate
    def terminate
      if MRA::LocationPlayTimeWindow::USE_COMBINED_WINDOW == false
        if MRA::LocationPlayTimeWindow::SHOW_TIME
          @playtime_window.dispose
        end
        if MRA::LocationPlayTimeWindow::SHOW_LOCATION
          @mapname_window.dispose
        end
      else
        @timemapname_window.dispose
      end
      #@info_window.dispose if @info_window != nil
      terminate_MRA_LocationPlayTimeWindow
    end

  #--------------------------------------------------------------------------
  # ● Frame Update
  #--------------------------------------------------------------------------
  alias update_MRA_LocationPlayTimeWindow update
    def update
      if MRA::LocationPlayTimeWindow::USE_COMBINED_WINDOW == false
        if MRA::LocationPlayTimeWindow::SHOW_TIME
          @playtime_window.update
        end
        if MRA::LocationPlayTimeWindow::SHOW_LOCATION
          @mapname_window.update
        end
      else
        @timemapname_window.update
      end
      #@info_window.update if @info_window != nil
      update_MRA_LocationPlayTimeWindow
    end
end
#==================================End Class===================================#