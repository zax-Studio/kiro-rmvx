=begin
#==============================================================================
# ** Prexus - Party Manager (v1.1c)
#------------------------------------------------------------------------------
#  This is a Party Management system, created by Prexus. It allows you to
#  change your party makeup, out of a reserve of characters. It also allows you
#  to lock characters, making them mandatory, and make characters unavailable.
#
#  See thread at RMXP.org for instructions:
#  http://www.rmxp.org/forums/index.php?topic=42685.msg402326#msg402326
#
#  - Changelog (v1.1c)
#    * Fixed a graphical error in the party reserves window
#
#  - (v1.1b)
#    * Fixed a bug with the draw_item_name method, added the width parameter
#  - (v1.1)
#    * Added functionality to see player's equipment (press the A button)
#    $data_actors[ID].found = true                      Tìm thấy 1 hero
#    $data_actors[ID].unavailable = true                Lock 1 hero
#    $game_party.members[0].actor.required = true       Lock Leader
#    $scene = Scene_Party.new                           Call Menu P-Changer          
# 
#
#
#
#==============================================================================

module RPG
  class Actor
    def setup
      @found = false
      @unavailable = false
      @required = false
    end
    attr_accessor :found
    attr_accessor :unavailable
    attr_accessor :required
  end
end

class Game_Actors
  attr_reader :data
  alias prex_party_g_actors_initialize initialize
  def initialize
    prex_party_g_actors_initialize
    $data_actors.each do |actor|
      actor.setup if actor
      @data[actor.id] = Game_Actor.new(actor.id) if actor
    end
  end
end

class Scene_File < Scene_Base
  alias prex_party_s_file_write_save_data write_save_data
  alias prex_party_s_file_read_save_data read_save_data
  def write_save_data(file)
    prex_party_s_file_write_save_data(file)
    Marshal.dump($data_actors, file)
  end
  def read_save_data(file)
    prex_party_s_file_read_save_data(file)
    $data_actors = Marshal.load(file)
  end
end

class Scene_Title < Scene_Base
  alias prex_party_s_title_command_new_game command_new_game
  def command_new_game
    prex_party_s_title_command_new_game
    $game_party.members.each {|s| s.actor.found = true if s}
  end
end

class Window_Base < Window
  def draw_item_name(item, x, y, enabled = true, width = 172)
    if item != nil
      draw_icon(item.icon_index, x, y, enabled)
      self.contents.font.color = normal_color
      self.contents.font.color.alpha = enabled ? 255 : 128
      self.contents.draw_text(x + 24, y, width, WLH, item.name)
    end
  end
end

class Scene_Party < Scene_Base
  def start
    super
    create_menu_background
    create_windows
  end
  def create_windows
    @member_window = Window_CurrentMember.new
    @party_window = Window_CurrentParty.new
    @party_window.active = true
    @selectable_window = Window_SelectMember.new
  end
  def update_windows
    @member_window.update
    @party_window.update
    @selectable_window.update
    if @party_window.active
      @member_window.set_member(@party_window.member)
    elsif @selectable_window.active
      @member_window.set_member(@selectable_window.member)
    end
  end
  def terminate
    super
    @member_window.dispose
    @party_window.dispose
    @selectable_window.dispose
  end
  def update
    super
    update_windows
    update_input
  end
  def update_input
    if Input.trigger?(Input::A)
      if @member_window.mode == 1
        @member_window.set_mode(0)
      elsif @member_window.mode == 0
        @member_window.set_mode(1)
      end
    end
    if @party_window.active
      if Input.trigger?(Input::B)
        Sound.play_cancel
        $scene = Scene_Map.new
      elsif Input.trigger?(Input::C)
        member = @party_window.member
        if member != nil
          if member.actor.unavailable or member.actor.required
            Sound.play_buzzer
            return
          end
        end
        Sound.play_decision
        @party_window.active = false
        @selectable_window.active = true
        @selectable_window.index = 0
      end
    elsif @selectable_window.active
      if Input.trigger?(Input::B)
        Sound.play_cancel
        @selectable_window.index = -1
        @selectable_window.active = false
        @party_window.active = true
      elsif Input.trigger?(Input::C)
        member = @selectable_window.member
        if member != nil
          if member.actor.unavailable
            Sound.play_buzzer
            return
          end
        end
        Sound.play_decision
        $game_party.remove_actor(@party_window.member.id) if @party_window.member != nil
        $game_party.add_actor(@selectable_window.member.id) if @selectable_window.member != nil
        @selectable_window.refresh
        @party_window.refresh
        @selectable_window.index = -1
        @selectable_window.active = false
        @party_window.active = true
      end
    end
  end
end

class Window_CurrentMember < Window_Base
  attr_reader :mode
  
  def initialize(member = nil, mode = 0)
    super(304, 80, 192, 256)
    create_contents
    @member = member
    @mode = 0
    refresh
  end
  
  def member
    return @member
  end
  
  def set_member(member)
    old_member = @member
    @member = member
    refresh if old_member != @member
  end
  
  def set_mode(mode)
    @mode = mode if [0, 1].include?(mode)
    refresh
  end
  
  def refresh
    self.contents.clear
    return unless @member
    x, y = 0, 0
    self.draw_actor_face(@member, x, y, 86)
    self.draw_actor_name(@member, x + 52, y)
    self.draw_actor_class(@member, x + 52, y + WLH)
    self.draw_actor_level(@member, x, y + WLH*2)
    case @mode
    when 0
      self.draw_icon(142, self.contents.width - 24, y + WLH*2)
      self.contents.draw_text(x, y + WLH*2, self.contents.width - 12, WLH, 'Equipar', 2)
      self.draw_actor_hp(@member, x, y + WLH*3, 160)
      self.draw_actor_mp(@member, x, y + WLH*4, 160)
      self.draw_actor_parameter(@member, x, y + WLH*5, 0)
      self.draw_actor_parameter(@member, x, y + WLH*6, 1)
      self.draw_actor_parameter(@member, x, y + WLH*7, 2)
      self.draw_actor_parameter(@member, x, y + WLH*8, 3)
    when 1
      self.draw_icon(143, self.contents.width - 24, y + WLH*2)
      self.contents.draw_text(x, y + WLH*2, self.contents.width - 12, WLH, 'Stado', 2)
      for i in 0...@member.equips.size
        item = @member.equips[i]
        self.draw_item_name(item, x, y + WLH*(3+i), true, self.contents.width - 24)
      end
    end
  end
end

class Window_CurrentParty < Window_Selectable
  def initialize
    super(48, 80, 256, 128)
    @item_max = 4
    @column_max = @item_max
    create_contents
    self.index = 0
    refresh
  end
  def member
    return $game_party.members[self.index]
  end
  def refresh
    for i in 0...@item_max
      rect = item_rect(i)
      self.contents.clear_rect(rect)
    end
    for i in 0...$game_party.members.size
      rect = item_rect(i)
      bitmap = Cache.character($game_party.members[i].character_name)
      sign = $game_party.members[i].character_name[/^[\!\$]./]
      if sign != nil and sign.include?('$')
        cw = bitmap.width / 3
        ch = bitmap.height / 4
      else
        cw = bitmap.width / 12
        ch = bitmap.height / 8
      end
      n = $game_party.members[i].character_index
      src_rect = Rect.new((n%4*3+1)*cw, (n/4*4)*ch, cw, ch)
      if $game_party.members[i].actor.unavailable
        self.contents.blt(rect.x, rect.y, bitmap, src_rect, 128)
      else
        self.contents.blt(rect.x, rect.y, bitmap, src_rect, 255)
      end
      if $game_party.members[i].actor.required
        lock_bitmap = Cache.system("No se puede cambiar")
        self.contents.blt(rect.x + rect.width - lock_bitmap.width,
                          rect.y + rect.height - lock_bitmap.height,
                          lock_bitmap, lock_bitmap.rect)
      end
    end
  end
  def item_rect(index)
    rect = Rect.new(0, 0, 0, 0)
    rect.width = (contents.width + @spacing) / @column_max - @spacing
    rect.height = 50
    rect.x = index % @column_max * (rect.width + @spacing)
    rect.y = index / @column_max * 50
    return rect
  end
end

class Window_SelectMember < Window_Selectable
  def initialize
    super(48, 144, 256, 192)
    calculate_actors
    @item_max = @actors.size + 2
    @column_max = 4
    self.index = -1
    self.active = false
    refresh
  end
  def calculate_actors
    @actors = []
    for a in $game_actors.data
      @actors << a if a != nil and a.actor.found and !$game_party.members.include?(a)
    end
  end
  def member
    return @actors[self.index]
  end
  def refresh
    self.contents.clear
    calculate_actors
    @item_max = @actors.size + 2
    for i in 0...@actors.size
      rect = item_rect(i)
      bitmap = Cache.character(@actors[i].character_name)
      sign = @actors[i].character_name[/^[\!\$]./]
      if sign != nil and sign.include?('$')
        cw = bitmap.width / 3
        ch = bitmap.height / 4
      else
        cw = bitmap.width / 12
        ch = bitmap.height / 8
      end
      n = @actors[i].character_index
      src_rect = Rect.new((n%4*3+1)*cw, (n/4*4)*ch, cw, ch)
      if @actors[i].actor.unavailable
        self.contents.blt(rect.x, rect.y, bitmap, src_rect, 128)
      else
        self.contents.blt(rect.x, rect.y, bitmap, src_rect, 255)
      end
      if @actors[i].actor.required
        lock_bitmap = Cache.system("Locked")
        self.contents.blt(rect.x + rect.width - lock_bitmap.width,
                          rect.y + rect.height - lock_bitmap.height,
                          lock_bitmap, lock_bitmap.rect)
      end
    end
  end
  def item_rect(index)
    rect = Rect.new(0, 0, 0, 0)
    rect.width = (contents.width + @spacing) / @column_max - @spacing
    rect.height = 50
    rect.x = index % @column_max * (rect.width + @spacing)
    rect.y = index / @column_max * 32
    return rect
  end
end
=end