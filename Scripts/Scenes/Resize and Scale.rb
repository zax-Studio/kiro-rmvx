#==============================================================================
# Resize and Scale Screen
#==============================================================================
# Author  : OriginalWij (Scale: Mechacrash & Kylock)
# Version : 1.1         (Scale: 1.0)
#==============================================================================

#==============================================================================
# v1.0
# - Initial release
# v1.1
# - Fixed player screen centering
# - Aliased some methods to increase compatibility
#==============================================================================

#==============================================================================
# Config
#==============================================================================

module OW_RaS
  # TODO: Fix bug with compatibility with other scripts. Sprites are being carried over when scrolling to left or up
  # Screen width (in multiples of 32) [max = 640] [default = 544]
  WIDTH = 640
  # Screen height (in multiples of 32) [max = 480] [default = 416]
  HEIGHT = 480
  # Scale multiplier factor (width = WIDTH * SCALE, height = HEIGHT * SCALE)
  # [default = 1.0] (1.0 = do NOT scale the game-window's size)
  SCALE = 1.0
end

#==============================================================================
# Scale
#==============================================================================

class Scale
  #--------------------------------------------------------------------------
  # Scale Window (by Mechacrash & Kylock)
  #--------------------------------------------------------------------------
  def self.game_window(w, h)
    size = Win32API.new('user32', 'GetSystemMetrics', 'I', 'I')
    move = Win32API.new('user32', 'MoveWindow', ['l','i','i','i','i','l'], 'l')
    find = Win32API.new('user32', 'FindWindowEx', ['l','l','p','p'], 'i')
    window = find.call(0, 0, "RGSS Player", 0)
    window_w = size.call(0)
    window_h = size.call(1)
    move.call(window,(window_w - w) / 2,(window_h - h) / 2, w, h, 1)
  end
end

#==============================================================================
# Game_Map
#==============================================================================

class Game_Map
  #--------------------------------------------------------------------------
  # Scroll Setup (Mod)
  #--------------------------------------------------------------------------
  alias ow_ras_gm_setup_scroll setup_scroll unless $@
  def setup_scroll
    ow_ras_gm_setup_scroll
    @margin_x = (width - (Graphics.width / 32)) * 256 / 2
    @margin_y = (height - (Graphics.height / 32)) * 256 / 2
  end
  #--------------------------------------------------------------------------
  # Calculate X coordinate for parallax display (Rewrite)
  #--------------------------------------------------------------------------
  def calc_parallax_x(bitmap)
    if bitmap == nil
      return 0
    elsif @parallax_loop_x
      return @parallax_x / 16
    elsif loop_horizontal?
      return 0
    else
      w1 = bitmap.width - Graphics.width    # changed
      w2 = @map.width * 32 - Graphics.width # changed
      if w1 <= 0 or w2 <= 0
        return 0
      else
        return @parallax_x * w1 / w2 / 8
      end
    end
  end
  #--------------------------------------------------------------------------
  # Calculate Y coordinate for parallax display  (Rewrite)
  #--------------------------------------------------------------------------
  def calc_parallax_y(bitmap)
    if bitmap == nil
      return 0
    elsif @parallax_loop_y
      return @parallax_y / 16
    elsif loop_vertical?
      return 0
    else
      h1 = bitmap.height - Graphics.height    # changed
      h2 = @map.height * 32 - Graphics.height # changed
      if h1 <= 0 or h2 <= 0
        return 0
      else
        return @parallax_y * h1 / h2 / 8
      end
    end
  end
  #--------------------------------------------------------------------------
  # Scroll Down (Rewrite)
  #--------------------------------------------------------------------------
  def scroll_down(distance)
    if loop_vertical?
      @display_y += distance
      @display_y %= @map.height * 256
      @parallax_y += distance
    else
      last_y = @display_y
      h = (Graphics.height / 32)                                   # added
      @display_y = [@display_y + distance, (height - h) * 256].min # changed
      @parallax_y += @display_y - last_y
    end
  end
  #--------------------------------------------------------------------------
  # Scroll Right (Rewrite)
  #--------------------------------------------------------------------------
  def scroll_right(distance)
    if loop_horizontal?
      @display_x += distance
      @display_x %= @map.width * 256
      @parallax_x += distance
    else
      last_x = @display_x
      w = (Graphics.width / 32)                                   # added
      @display_x = [@display_x + distance, (width - w) * 256].min # changed
      @parallax_x += @display_x - last_x
    end
  end
end

#==============================================================================
# Game_Player
#==============================================================================

class Game_Player < Game_Character
  #--------------------------------------------------------------------------
  # Initialize (Mod)
  #--------------------------------------------------------------------------
  alias ow_ras_gp_initialize initialize unless $@
  def initialize
    ow_ras_gp_initialize
    @center_x = (Graphics.width / 2 - 16) * 8
    @center_y = (Graphics.height / 2 - 16) * 8
  end
  #--------------------------------------------------------------------------
  # Set Map Display Position to Center of Screen (Rewrite)
  #--------------------------------------------------------------------------
  def center(x, y)
    display_x = x * 256 - @center_x                              # changed
    unless $game_map.loop_horizontal?
      max_x = ($game_map.width - (Graphics.width / 32)) * 256    # changed
      display_x = [0, [display_x, max_x].min].max
    end
    display_y = y * 256 - @center_y                              # changed
    unless $game_map.loop_vertical? 
      max_y = ($game_map.height - (Graphics.height / 32) ) * 256 # changed
      display_y = [0, [display_y, max_y].min].max 
    end
    $game_map.set_display_pos(display_x, display_y)
  end
  #--------------------------------------------------------------------------
  # Update Scroll (Rewrite)
  #--------------------------------------------------------------------------
  def update_scroll(last_real_x, last_real_y)
    ax1 = $game_map.adjust_x(last_real_x)
    ay1 = $game_map.adjust_y(last_real_y)
    ax2 = $game_map.adjust_x(@real_x)
    ay2 = $game_map.adjust_y(@real_y)
    if ay2 > ay1 and ay2 > @center_y    # changed
      $game_map.scroll_down(ay2 - ay1)
    end
    if ax2 < ax1 and ax2 < @center_x    # changed
      $game_map.scroll_left(ax1 - ax2)
    end
    if ax2 > ax1 and ax2 > @center_x    # changed
      $game_map.scroll_right(ax2 - ax1)
    end
    if ay2 < ay1 and ay2 < @center_y    # changed
      $game_map.scroll_up(ay1 - ay2)
    end
  end
end

#==============================================================================
# Sprite_Base
#==============================================================================

class Sprite_Base < Sprite
  #--------------------------------------------------------------------------
  # Start Animation (Mod)
  #--------------------------------------------------------------------------
  alias ow_ras_sb_start_animation start_animation unless $@
  def start_animation(animation, mirror = false)
    ow_ras_sb_start_animation(animation, mirror)
    if @animation.position == 3
      if viewport == nil
        @animation_ox = Graphics.width / 2
        @animation_oy = Graphics.height / 2
      end
    end
  end
end

#==============================================================================
# Sprite_Timer
#==============================================================================

class Sprite_Timer < Sprite
  #--------------------------------------------------------------------------
  # Initialize (Mod)
  #--------------------------------------------------------------------------
  alias ow_ras_st_initialize initialize unless $@
  def initialize(viewport)
    ow_ras_st_initialize(viewport)
    self.x = Graphics.width - self.bitmap.width
  end
end

#==============================================================================
# Spriteset_Map
#==============================================================================

class Spriteset_Map
  #--------------------------------------------------------------------------
  # Create Viewport (Rewrite)
  #--------------------------------------------------------------------------
  def create_viewports
    @viewport1 = Viewport.new(0, 0, Graphics.width, Graphics.height) # changed
    @viewport2 = Viewport.new(0, 0, Graphics.width, Graphics.height) # changed
    @viewport3 = Viewport.new(0, 0, Graphics.width, Graphics.height) # changed
    @viewport2.z = 50
    @viewport3.z = 100
  end
end

#==============================================================================
# Spriteset_Battle
#==============================================================================

class Spriteset_Battle
  #--------------------------------------------------------------------------
  # Create Viewport (Rewrite)
  #--------------------------------------------------------------------------
  def create_viewports
    @viewport1 = Viewport.new(0, 0, Graphics.width, Graphics.height) # changed
    @viewport2 = Viewport.new(0, 0, Graphics.width, Graphics.height) # changed
    @viewport3 = Viewport.new(0, 0, Graphics.width, Graphics.height) # changed
    @viewport2.z = 50
    @viewport3.z = 100
  end
  #--------------------------------------------------------------------------
  # Create Battleback Sprite (Rewrite)
  #--------------------------------------------------------------------------
  def create_battleback
    source = $game_temp.background_bitmap
    bitmap = Bitmap.new(Graphics.width + 96, Graphics.height + 64) # changed
    bitmap.stretch_blt(bitmap.rect, source, source.rect)
    bitmap.radial_blur(90, 12)
    @battleback_sprite = Sprite.new(@viewport1)
    @battleback_sprite.bitmap = bitmap
    @battleback_sprite.ox = (Graphics.width + 96) / 2              # changed
    @battleback_sprite.oy = (Graphics.height + 64) / 2             # changed
    @battleback_sprite.x = Graphics.width / 2                      # changed
    @battleback_sprite.y = (Graphics.height - 64) / 2              # changed
    @battleback_sprite.wave_amp = 8
    @battleback_sprite.wave_length = 240
    @battleback_sprite.wave_speed = 120
  end
  #--------------------------------------------------------------------------
  # Create Battlefloor Sprite (Mod)
  #--------------------------------------------------------------------------
  alias ow_ras_sb_create_battlefloor create_battlefloor unless $@
  def create_battlefloor
    ow_ras_sb_create_battlefloor
    @battlefloor_sprite.x = (Graphics.width - 544) / 2
    @battlefloor_sprite.y = 192 + (Graphics.height - 416) / 2
  end
end

#==============================================================================
# Window_Help
#==============================================================================

class Window_Help < Window_Base
  #--------------------------------------------------------------------------
  # Initialize (Rewrite)
  #--------------------------------------------------------------------------
  def initialize
    super(0, 0, Graphics.width, WLH + 32) # changed
  end
end

#==============================================================================
# Window_MenuStatus
#==============================================================================

class Window_MenuStatus < Window_Selectable
  #--------------------------------------------------------------------------
  # Initialize (Rewrite)
  #--------------------------------------------------------------------------
  def initialize(x, y)
    super(x, y, Graphics.width - 160, Graphics.height) # changed
    @v_size = (Graphics.height - 32) / 4               # added
    refresh
    self.active = false
    self.index = -1
  end
  #--------------------------------------------------------------------------
  # Refresh (Rewrite)
  #--------------------------------------------------------------------------
  def refresh
    self.contents.clear
    @item_max = $game_party.members.size
    for actor in $game_party.members
      y = @v_size > 96 ? (@v_size - 96) / 2 + 2 : 2            # added
      draw_actor_face(actor, 2, actor.index * @v_size + y, 92) # changed
      x = 104
      y = actor.index * @v_size + WLH / 2                      # changed
      y += (@v_size - 96) / 2 if @v_size > 96                  # added
      offset = Graphics.width - 424                            # added
      draw_actor_name(actor, x, y)
      draw_actor_class(actor, x + offset, y)                   # changed
      draw_actor_level(actor, x, y + WLH * 1)
      draw_actor_state(actor, x, y + WLH * 2)
      draw_actor_hp(actor, x + offset, y + WLH * 1)            # changed
      draw_actor_mp(actor, x + offset, y + WLH * 2)            # changed
    end
  end
  #--------------------------------------------------------------------------
  # Update cursor (Rewrite)
  #--------------------------------------------------------------------------
  def update_cursor
    if @index < 0               # No cursor
      self.cursor_rect.empty
    elsif @index < @item_max    # Normal (changed)
      self.cursor_rect.set(0, @index * @v_size, contents.width, @v_size)
    elsif @index >= 100         # Self   (changed)
      self.cursor_rect.set(0, (@index - 100) * @v_size, contents.width, @v_size)
    else                        # All    (changed)
      self.cursor_rect.set(0, 0, contents.width, @item_max * @v_size)
    end
  end
end

#==============================================================================
# Window_SkillStatus
#==============================================================================

class Window_SkillStatus < Window_Base
  #--------------------------------------------------------------------------
  # Initialize (Rewrite)
  #--------------------------------------------------------------------------
  def initialize(x, y, actor)
    super(x, y, Graphics.width, WLH + 32) # chagned
    @actor = actor
    refresh
  end
  #--------------------------------------------------------------------------
  # Refresh (Rewrite)
  #--------------------------------------------------------------------------
  def refresh
    self.contents.clear
    draw_actor_name(@actor, 4, 0)
    draw_actor_level(@actor, 140, 0)
    draw_actor_hp(@actor, Graphics.width - 304, 0) # changed
    draw_actor_mp(@actor, Graphics.width - 152, 0) # changed
  end
end

#==============================================================================
# Window_Equip
#==============================================================================

class Window_Equip < Window_Selectable
  #--------------------------------------------------------------------------
  # Initialize (Rewrite)
  #--------------------------------------------------------------------------
  def initialize(x, y, actor)
    super(x, y, Graphics.width - 208, WLH * 5 + 32) # changed
    @actor = actor
    refresh
    self.index = 0
  end
end

#==============================================================================
# Window_Status
#==============================================================================

class Window_Status < Window_Base
  #--------------------------------------------------------------------------
  # Initialize (Rewrite)
  #--------------------------------------------------------------------------
  def initialize(actor)
    super(0, 0, Graphics.width, Graphics.height) # changed
    @actor = actor
    refresh
  end
  #--------------------------------------------------------------------------
  # Refresh (Rewrite)
  #--------------------------------------------------------------------------
  def refresh
    self.contents.clear
    draw_actor_name(@actor, 4, 0)
    draw_actor_class(@actor, 128, 0)
    draw_actor_face(@actor, 8, 32)
    draw_basic_info(128, 32)
    draw_parameters(32, Graphics.height - 256)                        # changed
    draw_exp_info((Graphics.width / 2) + 16, 32)                      # changed
    draw_equipments((Graphics.width / 2) + 16, Graphics.height - 256) # changed
  end
end

#==============================================================================
# Window_SaveFile
#==============================================================================

class Window_SaveFile < Window_Base
  #--------------------------------------------------------------------------
  # Initialize (Rewrite)
  #--------------------------------------------------------------------------
  def initialize(file_index, filename)
    h = (Graphics.height - 56) / 4
    super(0, 56 + file_index % 4 * h, Graphics.width, h) # changed
    @file_index = file_index
    @filename = filename
    load_gamedata
    refresh
    @selected = false
  end
end

#==============================================================================
# Window_ShopBuy
#==============================================================================

class Window_ShopBuy < Window_Selectable
  #--------------------------------------------------------------------------
  # Initialize (Rewrite)
  #--------------------------------------------------------------------------
  def initialize(x, y)
    super(x, y, 304, Graphics.height - y) # changed
    @shop_goods = $game_temp.shop_goods
    refresh
    self.index = 0
  end
end

#==============================================================================
# Window_ShopNumber
#==============================================================================

class Window_ShopNumber < Window_Base
  #--------------------------------------------------------------------------
  # Initialize (Rewrite)
  #--------------------------------------------------------------------------
  def initialize(x, y)
    super(x, y, 304, Graphics.height - y) # changed
    @item = nil
    @max = 1
    @price = 0
    @number = 1
  end
end

#==============================================================================
# Window_ShopStatus
#==============================================================================

class Window_ShopStatus < Window_Base
  #--------------------------------------------------------------------------
  # Initialize (Rewrite)
  #--------------------------------------------------------------------------
  def initialize(x, y)
    super(x, y, Graphics.width - 304, Graphics.height - y) # changed
    @item = nil
    refresh
  end
end

#==============================================================================
# Window_NameEdit
#==============================================================================

class Window_NameEdit < Window_Base
  #--------------------------------------------------------------------------
  # Initialize
  #--------------------------------------------------------------------------
  def initialize(actor, max_char)
    x = (Graphics.width - 368) / 2  # added
    y = (Graphics.height - 376) / 2 # added
    super(x, y, 368, 128)           # changed
    @actor = actor
    @name = actor.name
    @max_char = max_char
    name_array = @name.split(//)[0...@max_char]
    @name = ""
    for i in 0...name_array.size
      @name += name_array[i]
    end
    @default_name = @name
    @index = name_array.size
    self.active = false
    refresh
    update_cursor
  end
end

#==============================================================================
# Window_NameInput
#==============================================================================

class Window_NameInput < Window_Base
  #--------------------------------------------------------------------------
  # Initialize
  #--------------------------------------------------------------------------
  def initialize(mode = 0)
    x = (Graphics.width - 368) / 2           # added
    y = ((Graphics.height - 376) / 2 ) + 128 # added
    super(x, y, 368, 248)                    # changed
    @mode = mode
    @index = 0
    refresh
    update_cursor
  end
end

#==============================================================================
# Window_NumberInput
#==============================================================================

class Window_NumberInput < Window_Base
  #--------------------------------------------------------------------------
  # Initialize (Rewrite)
  #--------------------------------------------------------------------------
  def initialize
    super(0, 0, Graphics.width, 64) # changed
    @number = 0
    @digits_max = 6
    @index = 0
    self.opacity = 0
    self.active = false
    self.z += 9999
    refresh
    update_cursor
  end
end

#==============================================================================
# Window_Message
#==============================================================================

class Window_Message < Window_Selectable
  #--------------------------------------------------------------------------
  # Initialize (Rewrite)
  #--------------------------------------------------------------------------
  def initialize
    y = $game_temp.in_battle ? (Graphics.height - 128) : 288 # added
    super(0, y, Graphics.width, 128)                         # changed
    self.z = 200
    self.active = false
    self.index = -1
    self.openness = 0
    @opening = false
    @closing = false
    @text = nil
    @contents_x = 0
    @contents_y = 0
    @line_count = 0
    @wait_count = 0
    @background = 0
    @position = 2
    @show_fast = false
    @line_show_fast = false
    @pause_skip = false
    create_gold_window
    create_number_input_window
    create_back_sprite
  end
  #--------------------------------------------------------------------------
  # Create Gold Window (Mod)
  #--------------------------------------------------------------------------
  alias ow_ras_wm_create_gold_window create_gold_window unless $@
  def create_gold_window
    ow_ras_wm_create_gold_window
    @gold_window.x = Graphics.width - 160
  end
  #--------------------------------------------------------------------------
  # Set Window Background and Position (Rewrite)
  #--------------------------------------------------------------------------
  def reset_window
    @background = $game_message.background
    @position = $game_message.position
    if @background == 0
      self.opacity = 255
    else 
      self.opacity = 0
    end
    case @position
    when 0  # Top
      self.y = 0
      @gold_window.y = Graphics.height - 56 # changed
    when 1  # Middle
      self.y = (Graphics.height / 2) - 64   # changed
      @gold_window.y = 0
    when 2  # Bottom
      self.y = Graphics.height - 128        # changed
      @gold_window.y = 0
    end
  end
end

#==============================================================================
# Window_TargetEnemy
#==============================================================================

class Window_TargetEnemy < Window_Command
  #--------------------------------------------------------------------------
  # Initialize (Rewrite)
  #--------------------------------------------------------------------------
  def initialize
    commands = []
    @enemies = []
    for enemy in $game_troop.members
      next unless enemy.exist?
      commands.push(enemy.name)
      @enemies.push(enemy)
    end
    super(Graphics.width - 128, commands, 2, 4) # changed
  end
end

#==============================================================================
# Window_BattleStatus
#==============================================================================

class Window_BattleStatus < Window_Selectable
  #--------------------------------------------------------------------------
  # Initialize (Rewrite)
  #--------------------------------------------------------------------------
  def initialize
    super(0, 0, Graphics.width - 128, 128) # changed
    refresh
    self.active = false
  end
end

#==============================================================================
# Window_DebugLeft
#==============================================================================

class Window_DebugLeft < Window_Selectable
  #--------------------------------------------------------------------------
  # Initialize (Rewrite)
  #--------------------------------------------------------------------------
  def initialize(x, y)
    super(x, y, 176, Graphics.height) # changed
    self.index = 0
    refresh
  end
end

#==============================================================================
# Scene_Title
#==============================================================================

class Scene_Title < Scene_Base
  #--------------------------------------------------------------------------
  # Include (Added)
  #--------------------------------------------------------------------------
  include OW_RaS
  #--------------------------------------------------------------------------
  # Initialize (New)
  #--------------------------------------------------------------------------
  def initialize
    Graphics.resize_screen(WIDTH, HEIGHT)
    Scale.game_window(WIDTH * SCALE, HEIGHT * SCALE)
  end
  #--------------------------------------------------------------------------
  # Create Command Window (Mod)
  #--------------------------------------------------------------------------
  alias ow_ras_st_create_command_window create_command_window unless $@
  def create_command_window
    ow_ras_st_create_command_window
    @command_window.x = (Graphics.width - @command_window.width) / 2
    @command_window.y = Graphics.height - 128
  end
end

#==============================================================================
# Scene_Menu
#==============================================================================

class Scene_Menu < Scene_Base
  #--------------------------------------------------------------------------
  # Start (Mod)
  #--------------------------------------------------------------------------
  alias ow_ras_sm_start start unless $@
  def start
    ow_ras_sm_start
    @gold_window.y = Graphics.height - 56
  end
end

#==============================================================================
# Scene_Item
#==============================================================================

class Scene_Item < Scene_Base
  #--------------------------------------------------------------------------
  # Start (Rewrite)
  #--------------------------------------------------------------------------
  def start
    super
    create_menu_background
    @viewport = Viewport.new(0, 0, Graphics.width, Graphics.height) # changed
    @help_window = Window_Help.new
    @help_window.viewport = @viewport
    h = Graphics.height - 56                                        # added
    @item_window = Window_Item.new(0, 56, Graphics.width, h)        # changed
    @item_window.viewport = @viewport
    @item_window.help_window = @help_window
    @item_window.active = false
    @target_window = Window_MenuStatus.new(0, 0)
    hide_target_window
  end
  #--------------------------------------------------------------------------
  # Show Target Window (Mod)
  #--------------------------------------------------------------------------
  alias ow_ras_si_show_target_window show_target_window unless $@
  def show_target_window(right)
    ow_ras_si_show_target_window(right)
    width_remain = Graphics.width - @target_window.width
    @target_window.x = width_remain if right
    x = right ? 0 : @target_window.width
    @viewport.rect.set(x, 0, width_remain, Graphics.height)
  end
  #--------------------------------------------------------------------------
  # Hide Target Window (Mod)
  #--------------------------------------------------------------------------
  alias ow_ras_si_hide_target_window hide_target_window unless $@
  def hide_target_window
    ow_ras_si_hide_target_window
    @viewport.rect.set(0, 0, Graphics.width, Graphics.height)
  end
end

#==============================================================================
# Scene_Skill
#==============================================================================

class Scene_Skill < Scene_Base
  #--------------------------------------------------------------------------
  # Start (Rewrite)
  #--------------------------------------------------------------------------
  def start
    super
    create_menu_background
    @actor = $game_party.members[@actor_index]
    @viewport = Viewport.new(0, 0, Graphics.width, Graphics.height) # changed
    @help_window = Window_Help.new
    @help_window.viewport = @viewport
    @status_window = Window_SkillStatus.new(0, 56, @actor)
    @status_window.viewport = @viewport
    w = Graphics.width                                              # added
    h = Graphics.height - 112                                       # added
    @skill_window = Window_Skill.new(0, 112, w, h, @actor)          # changed
    @skill_window.viewport = @viewport
    @skill_window.help_window = @help_window
    @target_window = Window_MenuStatus.new(0, 0)
    hide_target_window
  end
  #--------------------------------------------------------------------------
  # Show Target Window (Mod)
  #--------------------------------------------------------------------------
  alias ow_ras_ss_show_target_window show_target_window unless $@
  def show_target_window(right)
    ow_ras_ss_show_target_window(right)
    width_remain = Graphics.width - @target_window.width
    @target_window.x = width_remain if right
    x = right ? 0 : @target_window.width
    @viewport.rect.set(x, 0, width_remain, Graphics.height)
  end
  #--------------------------------------------------------------------------
  # Hide Target Window (Mod)
  #--------------------------------------------------------------------------
  alias ow_ras_ss_hide_target_window hide_target_window unless $@
  def hide_target_window
    ow_ras_ss_hide_target_window
    @viewport.rect.set(0, 0, Graphics.width, Graphics.height)
  end
end

#==============================================================================
# Scene_Equip
#==============================================================================

class Scene_Equip < Scene_Base
  #--------------------------------------------------------------------------
  # Create Item Window (Rewrite)
  #--------------------------------------------------------------------------
  def create_item_windows
    @item_windows = []
    y = 208                   # added
    w = Graphics.width        # added
    h = Graphics.height - 208 # added
    for i in 0...EQUIP_TYPE_MAX
      @item_windows[i] = Window_EquipItem.new(0, y, w, h, @actor, i) # changed
      @item_windows[i].help_window = @help_window
      @item_windows[i].visible = (@equip_index == i)
      @item_windows[i].active = false
      @item_windows[i].index = -1
    end
  end
end

#==============================================================================
# Scene_End
#==============================================================================

class Scene_End < Scene_Base
  #--------------------------------------------------------------------------
  # Create Command Window (Mod)
  #--------------------------------------------------------------------------
  alias ow_ras_se_create_command_window create_command_window unless $@
  def create_command_window
    ow_ras_se_create_command_window
    @command_window.x = (Graphics.width - @command_window.width) / 2
    @command_window.y = (Graphics.height - @command_window.height) / 2
  end
end

#==============================================================================
# Scene_Shop
#==============================================================================

class Scene_Shop < Scene_Base
  #--------------------------------------------------------------------------
  # Start (Rewrite)
  #--------------------------------------------------------------------------
  def start
    super
    create_menu_background
    create_command_window
    @help_window = Window_Help.new
    @gold_window = Window_Gold.new(Graphics.width - 160, @help_window.height)
    h = Graphics.height - @help_window.height * 2
    @dummy_window = Window_Base.new(0, 112, Graphics.width, h)    # changed
    @buy_window = Window_ShopBuy.new(0, 112)
    @buy_window.active = false
    @buy_window.visible = false
    @buy_window.help_window = @help_window
    @sell_window = Window_ShopSell.new(0, 112, Graphics.width, h) # changed
    @sell_window.active = false
    @sell_window.visible = false
    @sell_window.help_window = @help_window
    @number_window = Window_ShopNumber.new(0, 112)
    @number_window.active = false
    @number_window.visible = false
    @status_window = Window_ShopStatus.new(304, 112)
    @status_window.visible = false
  end
  #--------------------------------------------------------------------------
  # Create Command Window (Rewrite)
  #--------------------------------------------------------------------------
  def create_command_window
    s1 = Vocab::ShopBuy
    s2 = Vocab::ShopSell
    s3 = Vocab::ShopCancel
    w = Graphics.width - 160                                 # added
    @command_window = Window_Command.new(w, [s1, s2, s3], 3) # changed
    @command_window.y = 56
    if $game_temp.shop_purchase_only
      @command_window.draw_item(1, false)
    end
  end
end

#==============================================================================
# Scene_Battle
#==============================================================================

class Scene_Battle < Scene_Base
  #--------------------------------------------------------------------------
  # Create Information Display Viewport (Rewrite)
  #--------------------------------------------------------------------------
  def create_info_viewport
    gw = Graphics.width                                 # added
    gh = Graphics.height                                # added
    @info_viewport = Viewport.new(0, gh - 128, gw, 128) # changed
    @info_viewport.z = 100
    @status_window = Window_BattleStatus.new
    @party_command_window = Window_PartyCommand.new
    @actor_command_window = Window_ActorCommand.new
    @status_window.viewport = @info_viewport
    @party_command_window.viewport = @info_viewport
    @actor_command_window.viewport = @info_viewport
    @status_window.x = 128
    @actor_command_window.x = gw                        # changed
    @info_viewport.visible = false
  end
  #--------------------------------------------------------------------------
  # Start Skill Selection (Rewrite)
  #--------------------------------------------------------------------------
  def start_skill_selection
    @help_window = Window_Help.new
    w = Graphics.width                                             # added
    h = Graphics.height - 184                                      # added
    @skill_window = Window_Skill.new(0, 56, w, h, @active_battler) # changed
    @skill_window.help_window = @help_window
    @actor_command_window.active = false
  end
  #--------------------------------------------------------------------------
  # Start Item Selection (Rewrite)
  #--------------------------------------------------------------------------
  def start_item_selection
    @help_window = Window_Help.new
    w = Graphics.width                          # added
    h = Graphics.height - 184                   # added
    @item_window = Window_Item.new(0, 56, w, h) # changed
    @item_window.help_window = @help_window
    @actor_command_window.active = false
  end
end