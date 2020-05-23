#_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
#_/   ◆                        MiniMap - KGC_MiniMap                     ◆ VX ◆
#_/   ◇                       Last Update: 2008/09/08                         ◇
#_/   ◆                    Translation by Mr. Anonymous                       ◆
#_/   ◆ KGC Site:                                                             ◆
#_/   ◆ http://f44.aaa.livedoor.jp/~ytomy/                                    ◆
#_/   ◆ Translator's Blog:                                                    ◆
#_/   ◆ http://mraprojects.wordpress.com                                      ◆
#_/----------------------------------------------------------------------------
#_/  This script creates a "minimap" of the current area and displays it on the
#_/ screen. Note that you may disable the MiniMap on a given map by tagging the
#_/ map's name with [NOMAP].
#_/============================================================================
#_/ Install: Insert above KGC_SetAttackElement, if applicable.
#_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/

#==============================================================================#
#                             ★ Customization ★                                #
#==============================================================================#

module KGC
module MiniMap
  #                          ◆ MiniMap Switch ◆
  # Here you may assign an in-game switch number to activate/deactivate the map.
  MINIMAP_SWITCH_ID = 48

  #                   ◆ MiniMap Display Properties ◆
  # Here you may specify the X and Y coordinates as well as the width and height
  # of the MiniMap. 
  # Format:             X Coordinate    Y Coordinate     Width      Height
  MAP_RECT = Rect.new(          10,            310,       120,       90)
  
  #                         ◆ Map Z Coordinate ◆
  # Here you my specify the map's Z coordinate (depth).
  MAP_Z = 0
  
  #                      ◆ MiniMap Block Grid Size ◆
  # Here you may specify the grid size of the minimap. 3 or more is recommended.
  GRID_SIZE = 5

  #             ◆ MiniMap Foreground Color (Passable Space) ◆
  # Format:                     Red,   Green,   Blue,   Grey
  FOREGROUND_COLOR = Color.new( 214,     190,     66,    160)
  
  #              ◆ MiniMap Background Color (Not Passable) ◆
  # Format:                     Red,   Green,   Blue,   Grey
  BACKGROUND_COLOR = Color.new( 204,     248,    255,    160)

  #                   ◆ Current Position Marker Color ◆
  # Format:                     Red,   Green,   Blue,   Grey
  POSITION_COLOR   = Color.new( 255,      55,      0,   192)
  #                  ◆ Destination Event Marker Color ◆
  
  # To start this effect, the event must have [MOVE] in its name.
  # Format:                     Red,   Green,   Blue,   Grey
  MOVE_EVENT_COLOR = Color.new( 255,     160,      0,    192)

  #                      ◆ Custom Objects Colors ◆
  # Here you may specify different colors for different types of object markers.
  # For example, you may have NPCs labeled [OBJ 1] in the event's name, while 
  # monsters labeled at [OBJ 2] and so forth.
  # Please note that it's possible to add more, after OBJ 3. Just stick with
  # the format: Color.new(0, 0, 0, 192),  # [OBJ 4]
  OBJECT_COLOR = [
  # Format:   Red,   Green,   Blue,   Grey
    Color.new(  0,     160,      0,   192),  # [OBJ 1]
    Color.new(  0,     160,    160,   192),  # [OBJ 2]
    Color.new(  0,       0,    255,   255),  # [OBJ 3]
    Color.new(  0,     255,  255,    255),  # [OBJ 4]
    Color.new(  255,  120,   -255,   255),  # [OBJ 5]
    # Insert additional objects here.
    
  ]  # <- Do not remove!

  # ◆ Position Marker Blinking Strength ◆
  # Here you may specify how frequently the positional market blinks.
  # A range of 5 to 8 is recommended.
  BLINK_LEVEL = 0
end
end

#=============================================================================#
#                          ★ End Customization ★                              #
#=============================================================================#

#=================================================#
#                    IMPORT                       #
#=================================================#

$imported = {} if $imported == nil
$imported["MiniMap"] = true

if $data_mapinfos == nil
  $data_mapinfos = load_data("Data/MapInfos.rvdata")
end

#=================================================#

#==============================================================================
# □ KGC::MiniMap::Regexp
#==============================================================================
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #
#                           Name Box Tag Strings                              #
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #
#  Whatever word(s) are after the separator ( | ) in the following lines are 
#   what are used to determine what is searched for in the name box of an event. 

module KGC::MiniMap
  module Regexp
    # ミニマップ非表示
    NO_MINIMAP = /\[NOMAP\]/i
    # 移動イベント
    MOVE_EVENT = /\[MOVE\]/i
    # オブジェクト
    OBJECT = /\[OBJ(?:ECT)?\s*(\d)\]/i
  end

  module_function
  #--------------------------------------------------------------------------
  # ○ ミニマップ全体をリフレッシュ
  #--------------------------------------------------------------------------
  def refresh
    return unless $scene.is_a?(Scene_Map)
    $scene.refresh_minimap
  end
  #--------------------------------------------------------------------------
  # ○ ミニマップのオブジェクトを更新
  #--------------------------------------------------------------------------
  def update_object
    return unless $scene.is_a?(Scene_Map)
    $scene.update_minimap_object
  end
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# □ KGC::Commands
#==============================================================================

module KGC
module Commands
  module_function
  #--------------------------------------------------------------------------
  # ○ Show the MiniMap
  #--------------------------------------------------------------------------
  def show_minimap
    $game_system.minimap_show = true
  end
  #--------------------------------------------------------------------------
  # ○ Hide the MiniMap
  #--------------------------------------------------------------------------
  def hide_minimap
    $game_system.minimap_show = false
  end
end
end

#=================================================#
#             INCLUDE COMMANDS                    #
#=================================================#
#    Include KGC::Commands in Game_Interpreter    #
#=================================================#

class Game_Interpreter
  include KGC::Commands
end

#=================================================#

#==============================================================================
# ■ RPG::MapInfo
#==============================================================================

class RPG::MapInfo
  #--------------------------------------------------------------------------
  # ● マップ名取得
  #--------------------------------------------------------------------------
  def name
    return @name.gsub(/\[.*\]/) { "" }
  end
  #--------------------------------------------------------------------------
  # ○ オリジナルマップ名取得
  #--------------------------------------------------------------------------
  def original_name
    return @name
  end
  #--------------------------------------------------------------------------
  # ○ ミニマップのキャッシュ生成
  #--------------------------------------------------------------------------
  def create_minimap_cache
    @__minimap_show = !(@name =~ KGC::MiniMap::Regexp::NO_MINIMAP)
  end
  #--------------------------------------------------------------------------
  # ○ ミニマップ表示
  #--------------------------------------------------------------------------
  def minimap_show?
    create_minimap_cache if @__minimap_show == nil
    return @__minimap_show
  end
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# ■ Game_System
#==============================================================================

class Game_System
  #--------------------------------------------------------------------------
  # ○ ミニマップ表示フラグ取得
  #--------------------------------------------------------------------------
  def minimap_show
    return $game_switches[KGC::MiniMap::MINIMAP_SWITCH_ID]
  end
  #--------------------------------------------------------------------------
  # ○ ミニマップ表示フラグ変更
  #--------------------------------------------------------------------------
  def minimap_show=(value)
    $game_switches[KGC::MiniMap::MINIMAP_SWITCH_ID] = value
  end
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# ■ Game_Map
#==============================================================================

class Game_Map
  #--------------------------------------------------------------------------
  # ○ ミニマップを表示するか
  #--------------------------------------------------------------------------
  def minimap_show?
    return $data_mapinfos[map_id].minimap_show?
  end
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# ■ Game_Event
#==============================================================================

class Game_Event < Game_Character
  #--------------------------------------------------------------------------
  # ○ イベント名
  #--------------------------------------------------------------------------
  def name
    return @event.name
  end
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# □ Game_MiniMap
#------------------------------------------------------------------------------
#   ミニマップを扱うクラスです。
#==============================================================================

class Game_MiniMap
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize(tilemap)
    @map_rect = KGC::MiniMap::MAP_RECT
    @grid_size = [KGC::MiniMap::GRID_SIZE, 1].max

    @x = 0
    @y = 0
    @size = [@map_rect.width / @grid_size, @map_rect.height / @grid_size]
    @tilemap = tilemap

    create_sprites
    refresh
  end
  #--------------------------------------------------------------------------
  # ○ スプライト作成
  #--------------------------------------------------------------------------
  def create_sprites
    # マップ用スプライト作成
    @map_sprite = Sprite.new
    @map_sprite.x = @map_rect.x
    @map_sprite.y = @map_rect.y
    @map_sprite.z = KGC::MiniMap::MAP_Z
    bitmap_width = $game_map.width * @grid_size + @map_rect.width
    bitmap_height = $game_map.height * @grid_size + @map_rect.height
    @map_sprite.bitmap = Bitmap.new(bitmap_width, bitmap_height)
    @map_sprite.src_rect = @map_rect

    # オブジェクト用スプライト作成
    @object_sprite = Sprite_MiniMapIcon.new
    @object_sprite.x = @map_rect.x
    @object_sprite.y = @map_rect.y
    @object_sprite.z = KGC::MiniMap::MAP_Z + 1
    @object_sprite.bitmap = Bitmap.new(bitmap_width, bitmap_height)
    @object_sprite.src_rect = @map_rect

    # 現在位置スプライト作成
    @position_sprite = Sprite_MiniMapIcon.new
    @position_sprite.x = @map_rect.x + @size[0] / 2 * @grid_size
    @position_sprite.y = @map_rect.y + @size[1] / 2 * @grid_size
    @position_sprite.z = KGC::MiniMap::MAP_Z + 2
    bitmap = Bitmap.new(@grid_size, @grid_size)
    bitmap.fill_rect(bitmap.rect, KGC::MiniMap::POSITION_COLOR)
    @position_sprite.bitmap = bitmap
  end
  #--------------------------------------------------------------------------
  # ● 解放
  #--------------------------------------------------------------------------
  def dispose
    @map_sprite.bitmap.dispose
    @map_sprite.dispose
    @object_sprite.bitmap.dispose
    @object_sprite.dispose
    @position_sprite.bitmap.dispose
    @position_sprite.dispose
  end
  #--------------------------------------------------------------------------
  # ○ 可視状態取得
  #--------------------------------------------------------------------------
  def visible
    return @map_sprite.visible
  end
  #--------------------------------------------------------------------------
  # ○ 可視状態設定
  #--------------------------------------------------------------------------
  def visible=(value)
    @map_sprite.visible = value
    @object_sprite.visible = value
    @position_sprite.visible = value
  end
  #--------------------------------------------------------------------------
  # ○ リフレッシュ
  #--------------------------------------------------------------------------
  def refresh
    draw_map
    update_object_list
    draw_object
    update_position
  end
  #--------------------------------------------------------------------------
  # ○ マップ描画
  #--------------------------------------------------------------------------
  def draw_map
    bitmap = @map_sprite.bitmap
    bitmap.fill_rect(bitmap.rect, KGC::MiniMap::BACKGROUND_COLOR)

    rect = Rect.new(0, 0, @grid_size, @grid_size)
    move_events = $game_map.events.values.find_all { |e|
      e.name =~ KGC::MiniMap::Regexp::MOVE_EVENT
    }
    $game_map.width.times { |i|     # X座標
      $game_map.height.times { |j|  # Y座標
        next unless $game_map.passable?(i, j)

        rect.x = @map_rect.width / 2 + @grid_size * i
        rect.y = @map_rect.height / 2 + @grid_size * j
        color = KGC::MiniMap::FOREGROUND_COLOR
        move_events.each { |e|
          if e.x == i && e.y == j
            color = KGC::MiniMap::MOVE_EVENT_COLOR
            break
          end
        }
        bitmap.fill_rect(rect, color)
      }
    }
  end
  #--------------------------------------------------------------------------
  # ○ オブジェクト一覧更新
  #--------------------------------------------------------------------------
  def update_object_list
    @object_list = []
    $game_map.events.values.each { |e|
      if e.name =~ KGC::MiniMap::Regexp::OBJECT
        type = $1.to_i
        if @object_list[type] == nil
          @object_list[type] = []
        end
        @object_list[type] << e
      end
    }
  end
  #--------------------------------------------------------------------------
  # ○ オブジェクト描画
  #--------------------------------------------------------------------------
  def draw_object
    # 下準備
    bitmap = @object_sprite.bitmap
    bitmap.clear
    rect = Rect.new(0, 0, @grid_size, @grid_size)
    mw = @map_rect.width / 2
    mh = @map_rect.height / 2

    # オブジェクト描画
    @object_list.each_with_index { |list, i|
      color = KGC::MiniMap::OBJECT_COLOR[i - 1]
      next if list.nil? || color.nil?
      list.each { |obj|
        # グラフィックがある場合のみ表示
        if obj.character_name != "" || obj.tile_id > 0
          rect.x = mw + obj.real_x * @grid_size / 256
          rect.y = mh + obj.real_y * @grid_size / 256
          bitmap.fill_rect(rect, color)
        end
      }
    }
  end
  #--------------------------------------------------------------------------
  # ○ 更新
  #--------------------------------------------------------------------------
  def update
    draw_object
    update_position
    if @map_sprite.visible
      @map_sprite.update
      @object_sprite.update
      @position_sprite.update
    end
  end
  #--------------------------------------------------------------------------
  # ○ 位置更新
  #--------------------------------------------------------------------------
  def update_position
    sx = $game_player.real_x * @grid_size / 256
    sy = $game_player.real_y * @grid_size / 256
    @map_sprite.src_rect.x = sx
    @map_sprite.src_rect.y = sy
    @object_sprite.src_rect.x = sx
    @object_sprite.src_rect.y = sy
  end
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# □ Sprite_MiniMapIcon
#------------------------------------------------------------------------------
#   ミニマップ用アイコンのクラスです。
#==============================================================================

class Sprite_MiniMapIcon < Sprite
  DURATION_MAX = 60
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #     viewport : ビューポート
  #--------------------------------------------------------------------------
  def initialize(viewport = nil)
    super(viewport)
    @duration = DURATION_MAX / 2
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  def update
    super
    @duration += 1
    if @duration == DURATION_MAX
      @duration = 0
    end
    update_effect
  end
  #--------------------------------------------------------------------------
  # ○ エフェクトの更新
  #--------------------------------------------------------------------------
  def update_effect
    self.color.set(255, 255, 255,
      (@duration - DURATION_MAX / 2).abs * KGC::MiniMap::BLINK_LEVEL)
  end
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# ■ Spriteset_Map
#==============================================================================

class Spriteset_Map
  attr_reader :minimap
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  alias initialize_KGC_MiniMap initialize
  def initialize
    initialize_KGC_MiniMap

    create_minimap
  end
  #--------------------------------------------------------------------------
  # ○ ミニマップ作成
  #--------------------------------------------------------------------------
  def create_minimap
    return unless $game_map.minimap_show?

    @minimap = Game_MiniMap.new(@tilemap)
    @minimap.visible = $game_system.minimap_show
  end
  #--------------------------------------------------------------------------
  # ● 解放
  #--------------------------------------------------------------------------
  alias dispose_KGC_MiniMap dispose
  def dispose
    dispose_KGC_MiniMap

    dispose_minimap
  end
  #--------------------------------------------------------------------------
  # ○ ミニマップ解放
  #--------------------------------------------------------------------------
  def dispose_minimap
    @minimap.dispose if @minimap != nil
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  alias update_KGC_MiniMap update
  def update
    update_KGC_MiniMap

    update_minimap
  end
  #--------------------------------------------------------------------------
  # ○ ミニマップ更新
  #--------------------------------------------------------------------------
  def update_minimap
    return if @minimap == nil

    if $game_system.minimap_show
      @minimap.visible = true
      @minimap.update
    else
      @minimap.visible = false
    end
  end
  #--------------------------------------------------------------------------
  # ○ ミニマップ全体をリフレッシュ
  #--------------------------------------------------------------------------
  def refresh_minimap
    @minimap.refresh
  end
  #--------------------------------------------------------------------------
  # ○ ミニマップのオブジェクトを更新
  #--------------------------------------------------------------------------
  def update_minimap_object
    @minimap.update_object_list
  end
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# ■ Scene_Map
#==============================================================================

class Scene_Map
  #--------------------------------------------------------------------------
  # ○ ミニマップ全体をリフレッシュ
  #--------------------------------------------------------------------------
  def refresh_minimap
    @spriteset.refresh_minimap
  end
  #--------------------------------------------------------------------------
  # ○ ミニマップのオブジェクトを更新
  #--------------------------------------------------------------------------
  def update_minimap_object
    @spriteset.update_minimap_object
  end
end
