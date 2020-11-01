#===============================================================================
# HUD para o ABS
#===============================================================================

module PRABS
  module HUD
    ARROWS_ITEM_ID = 35
  end
end

class Game_System
  
  attr_accessor :hud_started
  
  alias pr_abs_hud_gsystem_initialize initialize
  
  def initialize
    @hud_started = false
    pr_abs_hud_gsystem_initialize
  end
  
end

class SpriteHotkeyIcon < Sprite
  
  #-----------------------------------------------------------------------------
  # Inicialização
  #-----------------------------------------------------------------------------

  def initialize(hotkey, viewport=nil)
    super(viewport)
    @hotkey = hotkey
    case @hotkey.type
    when 1
      @icon_index = $data_skills[@hotkey.id].icon_index
    when 2
      @icon_index = $data_items[@hotkey.id].icon_index
    else
      @icon_index = 0
    end
    self.bitmap = Bitmap.new(27, 27)
    self.bitmap.font.size = 12
    refresh
  end
  
  #-----------------------------------------------------------------------------
  # Atualiza
  #-----------------------------------------------------------------------------

  def refresh
    self.bitmap.clear
    self.bitmap.blt(1, 1, Cache.system("IconSet"), Rect.new(@icon_index % 16 * 24, @icon_index / 16 * 24, 24, 24))
    case @hotkey.type
    when 2
      @item_number = $game_party.item_number($data_items[@hotkey.id])
      text = @item_number.to_s
      size = self.bitmap.text_size(text)
      size.x = 27 - size.width
      size.y = 27 - size.height
      self.bitmap.draw_text(size, text, 1)
    end
  end
  
  #-----------------------------------------------------------------------------
  # Atualiza
  #-----------------------------------------------------------------------------

  def dispose
    self.bitmap.dispose
    super()
  end
  
  #-----------------------------------------------------------------------------
  # Atualiza
  #-----------------------------------------------------------------------------

  def update
    if $game_player.battler.nil?
      self.tone.set(0, 0, 0, -168)
      self.opacity = 200
      return
    end
    return unless self.visible
    case @hotkey.type
    when 1
      if ($game_player.battler.calc_mp_cost($data_skills[@hotkey.id]) > $game_player.battler.mp)
        self.tone.set(0, 0, 0, -168)
        self.opacity = 200
      else
        self.tone.set(0, 0, 0, 0)
        self.opacity = 255
      end
    when 2
      if (@item_number != $game_party.item_number($data_items[@hotkey.id]))
        refresh
      end
      if (@item_number <= 0)
        self.tone.set(0, 0, 0, -168)
        self.opacity = 200
      else
        self.tone.set(0, 0, 0, 0)
        self.opacity = 255
      end
    else
      self.tone.set(0, 0, 0, 0)
      self.opacity = 255
    end
  end
  
end

#===============================================================================
# HUD para o ABS
#===============================================================================

class SpriteEquipHotkey < Sprite

  attr_accessor :countable

  #-----------------------------------------------------------------------------
  # Inicialização
  #-----------------------------------------------------------------------------

  def initialize(viewport = nil, countable = false)
    super(viewport)
    @countable = countable
    self.bitmap = Bitmap.new(27, 27)
    self.bitmap.font.size = 12
    @icon_index = 0
    refresh
  end
  
  #-----------------------------------------------------------------------------
  # Index do ícone
  #-----------------------------------------------------------------------------

  def icon_index=(valor)
    return if (@icon_index == valor)
    @icon_index = valor
    refresh
  end
  
  #-----------------------------------------------------------------------------
  # Atualiza
  #-----------------------------------------------------------------------------

  def refresh
    self.bitmap.clear
    return if (@icon_index < 0)
    self.bitmap.blt(1, 1, Cache.system("IconSet"), Rect.new(@icon_index % 16 * 24, @icon_index / 16 * 24, 24, 24))
  end
  
  #-----------------------------------------------------------------------------
  # Atualiza
  #-----------------------------------------------------------------------------

  def dispose
    self.bitmap.dispose
    super()
  end
  
  #-----------------------------------------------------------------------------
  # Atualiza
  #-----------------------------------------------------------------------------

  def update
    if (@countable)
      item_number = $game_party.item_number($data_items[PRABS::HUD::ARROWS_ITEM_ID])
      text = item_number.to_s
      size = self.bitmap.text_size(text)
      size.x = 27 - size.width
      size.y = 27 - size.height
      self.bitmap.draw_text(size, text, 1)
    end
  end
  
end

#===============================================================================
# HUD para o ABS
#===============================================================================

class SpriteHotkeys < Sprite

  BOWS = [4, 11, 17, 24]
  
  #-----------------------------------------------------------------------------
  # Inicialização
  #-----------------------------------------------------------------------------

  def initialize(viewport=nil)
    super(viewport)
    self.bitmap = Cache.load_bitmap("Graphics/HUD/", "HotKeys")
    @icons = []
    for i in 0...$game_player.hotkeys.size
      hotkey = $game_player.hotkeys[i]
      sprite = SpriteHotkeyIcon.new(hotkey, viewport)
      @icons.push(sprite)
    end
    @weapon_icons = [SpriteEquipHotkey.new(viewport), SpriteEquipHotkey.new(viewport)]
    self.x = self.x
    self.y = self.y
    self.z = self.z
  end
  
  #-----------------------------------------------------------------------------
  # Visible
  #-----------------------------------------------------------------------------

  def visible=(valor)
    super
    for sprite in @icons + @weapon_icons
      sprite.visible = self.visible
    end
  end
  
  #-----------------------------------------------------------------------------
  # Valor da posição X
  #-----------------------------------------------------------------------------

  def x=(valor)
    super(valor)
    for i in 0...@icons.size
      @icons[i].x = self.x + 88 + 30 * i
    end
    for i in 0...@weapon_icons.size
      @weapon_icons[i].x = self.x + 14 + 30 * i
    end
  end
  
  #-----------------------------------------------------------------------------
  # Valor da posição Y
  #-----------------------------------------------------------------------------

  def y=(valor)
    super(valor)
    for i in 0...@icons.size
      @icons[i].y = self.y + 5
    end
    for i in 0...@weapon_icons.size
      @weapon_icons[i].y = self.y + 5
    end
  end
  
  #-----------------------------------------------------------------------------
  # Valor da posição Y
  #-----------------------------------------------------------------------------

  def opacity=(valor)
    super(valor)
    for i in 0...@icons.size
      @icons[i].opacity = self.opacity
    end
    for i in 0...@weapon_icons.size
      @weapon_icons[i].opacity = self.opacity
    end
  end
  
  #-----------------------------------------------------------------------------
  # Valor da posição Z
  #-----------------------------------------------------------------------------

  def z=(valor)
    super(valor)
    for i in 0...@icons.size
      @icons[i].z = self.z + 1
    end
    for i in 0...@weapon_icons.size
      @weapon_icons[i].z = self.z + 1
    end
  end
  
  #-----------------------------------------------------------------------------
  # Deleta
  #-----------------------------------------------------------------------------

  def dispose
    self.bitmap.dispose
    for sprite in @icons + @weapon_icons
      sprite.dispose
    end
    super()
  end
  
  #-----------------------------------------------------------------------------
  # Deleta
  #-----------------------------------------------------------------------------

  def update
    for icon in @icons
      icon.update
    end
    @weapon_icons[0].icon_index = ($data_weapons[$game_party.members[0].weapon_id].nil? ? -1 : $data_weapons[$game_party.members[0].weapon_id].icon_index)
    if (!BOWS.index($game_party.members[0].weapon_id).nil?) # if it's one of the bows, display arrows
      @weapon_icons[1].countable = true
      @weapon_icons[1].icon_index = $data_items[PRABS::HUD::ARROWS_ITEM_ID].icon_index
      @weapon_icons[1].update
    elsif ($game_party.members[0].two_swords_style)
      @weapon_icons[1].countable = false
      @weapon_icons[1].icon_index = ($data_weapons[$game_party.members[0].armor1_id].nil? ? -1 : $data_weapons[$game_party.members[0].armor1_id].icon_index)
    else
      @weapon_icons[1].countable = false
      @weapon_icons[1].icon_index = ($data_armors[$game_party.members[0].armor1_id].nil? ? -1 : $data_armors[$game_party.members[0].armor1_id].icon_index)
    end
  end
  
end

#==============================================================================
# Sprite_Character_HUD
#==============================================================================

class Sprite_Character_HUD < Sprite_Base
  
  #--------------------------------------------------------------------------
  # ● Animação de Balão
  #--------------------------------------------------------------------------
  
  BALLOON_WAIT = 12                  
  
  #--------------------------------------------------------------------------
  # ● Váriaveis
  #--------------------------------------------------------------------------
  
  attr_accessor :character
  
  #--------------------------------------------------------------------------
  # ● Inicialização
  #--------------------------------------------------------------------------
  
  def initialize(viewport, character = nil)
    super(viewport)
    @character = character
    @balloon_duration = 0
    @balloon_id = 0
    update
  end
  
  #--------------------------------------------------------------------------
  # ● Deleta o Character
  #--------------------------------------------------------------------------

  def dispose
    dispose_balloon
    super
  end
  
  #--------------------------------------------------------------------------
  # ● Atualização
  #--------------------------------------------------------------------------
  
  def update
    return if self.disposed?
    return if @character.nil?
    super
    update_bitmap
    self.visible = (!@character.transparent)
    update_src_rect
    self.opacity = @character.opacity
    self.blend_type = @character.blend_type
    update_balloon
  end
  
  #--------------------------------------------------------------------------
  # ● Atualiza o Bitmap
  #--------------------------------------------------------------------------
 
  def update_bitmap
    if @tile_id != @character.tile_id or
       @character_name != @character.character_name or
       @character_index != @character.character_index
      @tile_id = @character.tile_id
      @character_name = @character.character_name
      @character_index = @character.character_index
      self.bitmap = Cache.character(@character_name)
      sign = @character_name[/^[\!\$]./]
      if sign != nil and sign.include?('$')
        @cw = bitmap.width / 3
        @ch = bitmap.height / 4
      else
        @cw = bitmap.width / 12
        @ch = bitmap.height / 8
      end
      self.ox = @cw / 2
      self.oy = @ch / 2
    end
  end
  
  #--------------------------------------------------------------------------
  # ● Atualiza o Recorte
  #--------------------------------------------------------------------------
  
  def update_src_rect
    if @tile_id == 0
      index = @character.character_index
      pattern = @character.pattern < 3 ? @character.pattern : 1
      sx = (index % 4 * 3 + pattern) * @cw
      sy = (index / 4 * 4) * @ch
      self.src_rect.set(sx, sy, @cw, @ch)
    end
  end
  
  #--------------------------------------------------------------------------
  # ● Inicia o balão
  #--------------------------------------------------------------------------
 
  def start_balloon
    dispose_balloon
    @balloon_duration = 8 * 8 + BALLOON_WAIT
    @balloon_sprite = ::Sprite.new(viewport)
    @balloon_sprite.bitmap = Cache.system("HUDBalloon")
    @balloon_sprite.ox = 16
    @balloon_sprite.oy = 32
    update_balloon
  end
  
  #--------------------------------------------------------------------------
  # ● Atualiza o balão
  #--------------------------------------------------------------------------
 
  def reset_balloon
    @balloon_duration = 8 * 8 + BALLOON_WAIT
    update_balloon
  end
  
  #--------------------------------------------------------------------------
  # ● Atualiza o balão
  #--------------------------------------------------------------------------
 
  def visible=(valor)
    super
    if (@balloon_sprite != nil)
      @balloon_sprite.visible = self.visible
    end
  end
  
  #--------------------------------------------------------------------------
  # ● Oopacidade
  #--------------------------------------------------------------------------
 
  def opacity=(valor)
    super
    if (@balloon_sprite != nil)
      @balloon_sprite.opacity = valor
    end
  end
  
  #--------------------------------------------------------------------------
  # ● Atualiza o balão
  #--------------------------------------------------------------------------
 
  def update_balloon
    if (@character.hud_balloon_id > 0)
      @balloon_id = @character.hud_balloon_id
      if @balloon_duration <= 0
        start_balloon
      end
    elsif @balloon_id > 0
      dispose_balloon
    end
    if @balloon_duration > 0
      @balloon_duration -= 1
      if @balloon_duration == 0
        if (@character.hud_balloon_id > 0)
          reset_balloon
        else
          dispose_balloon
          return
        end
      end
      @balloon_sprite.x = self.x + 4
      @balloon_sprite.y = self.y - 8
      @balloon_sprite.z = self.z + 200
      if @balloon_duration < BALLOON_WAIT
        sx = 7 * 32
      else
        sx = (7 - (@balloon_duration - BALLOON_WAIT) / 8) * 32
      end
      sy = (@balloon_id - 1) * 32
      @balloon_sprite.src_rect.set(sx, sy, 32, 32)
    end
  end
  
  #--------------------------------------------------------------------------
  # ● Deleta o Balão
  #--------------------------------------------------------------------------
 
  def dispose_balloon
    @balloon_duration = 0
    if @balloon_sprite != nil
      @balloon_sprite.dispose
      @balloon_sprite = nil
    end
  end
  
end

#==============================================================================
# SpriteHUDBar
#==============================================================================

class SpriteHUDBar < Sprite
  
  attr_accessor :add_y
  
  def initialize(name, viewport=nil)
    super(viewport)
    self.bitmap = Cache.load_bitmap("Graphics/HUD/", name)
    @sprite = Sprite.new(viewport)
    @sprite.bitmap = Bitmap.new(self.bitmap.width, 8)
    @sprite.bitmap.font.size = 10
    @sprite.bitmap.font.color = Color.new(0, 0, 0)
    @sprite.bitmap.font.shadow = false
    @valor = 0
    @max_valor = 0
    @target_valor = 0
    @target_max_valor = 0
    @add_y = -4
    @speed = 10
  end
  
  def visible=(valor)
    super
    @sprite.visible = self.visible
  end
  
  def x=(valor)
    super
    @sprite.x = self.x
  end
  
  def y=(valor)
    super
    @sprite.y = self.y + @add_y
  end
  
  def z=(valor)
    super
    @sprite.z = self.z + 1
  end
  
  def opacity=(valor)
    super
    @sprite.opacity = valor
  end
  
  def dispose
    @sprite.bitmap.dispose
    @sprite.dispose
    self.bitmap.dispose
    super()
  end
  
  def refresh
    w = (self.bitmap.width * @valor) / @max_valor
    self.src_rect.set(0, 0, w, self.bitmap.height)
    @sprite.bitmap.clear
    @sprite.bitmap.draw_text(@sprite.bitmap.rect, "#{@valor} / #{@max_valor}")
  end
  
  def reset_valor(valor, max_valor)
    @valor = valor
    @max_valor = max_valor
    @target_valor = valor
    @target_max_valor = max_valor
    refresh
  end
  
  def refresh_valor(valor, max_valor)
    @target_valor = valor
    @target_max_valor = max_valor
    if (@valor != @target_valor || @target_max_valor != !max_valor)
      @valor = valor
      @max_valor = max_valor
      refresh
    end
  end

  def set_valor(valor, max_valor)
    @target_valor = valor
    @target_max_valor = max_valor
  end
  
  def valor=(valor)
    @target_valor = valor
  end
  
  def max_valor=(valor)
    @target_max_valor = valor
  end
  
  def update
    @sprite.visible = ($game_switches[PRABS::CONFIG::HUD_SHOW_VALUES] && self.visible)
    need_refresh = false
    if (@target_valor != @valor)
      need_refresh = true
      if (@target_valor > @valor)
        @valor = [@valor + @speed, @target_valor].min
      elsif (@target_valor < @valor)
        @valor = [@valor - @speed, @target_valor].max
      end
    end
    if (@target_max_valor != @max_valor)
      need_refresh = true
      if (@target_max_valor > @max_valor)
        @max_valor = [@max_valor + @speed, @target_max_valor].min
      elsif (@target_max_valor < @max_valor)
        @max_valor = [@max_valor - @speed, @target_max_valor].max
      end
    end    
    refresh if need_refresh
  end
  
end

#==============================================================================
# Sprite_Character_HUD
#==============================================================================

class SpriteHUD
  
  ACTOR_FACES = {}
  ACTOR_FACES[1] = "Hero"
  
  attr_reader :visible
  attr_reader :opacity
  
  #-----------------------------------------------------------------------------
  # Inicialização
  #-----------------------------------------------------------------------------

  def initialize(viewport=nil)
    @viewport = viewport
    @back = Sprite.new(@viewport)
    @texts = Sprite.new(@viewport)
    @character = Sprite_Character_HUD.new(@viewport, nil)
    
    @hotkeys = SpriteHotkeys.new(@viewport)
    
    @hp_bar = SpriteHUDBar.new("bar_hp", @viewport)
    @mp_bar = SpriteHUDBar.new("bar_mp", @viewport)
    @exp_bar = SpriteHUDBar.new("bar_exp", @viewport)
    @hp_bar.add_y = -1
    @mp_bar.add_y = -1
    
    @back.bitmap = Cache.load_bitmap("Graphics/HUD/", "hud")
    @hotkeys.x = @back.bitmap.width + 12
    @hotkeys.y = 8
    @texts.bitmap = Bitmap.new(@back.bitmap.width, @back.bitmap.height)
    @texts.bitmap.font.size = 10
    @texts.bitmap.font.color = Color.new(0, 0, 0)
    @texts.bitmap.font.shadow = false
    
    self.x = 0
    self.y = 0
    self.z = 0
    @opacity = 0
    if !$game_system.hud_started
      if PRABS::CONFIG::HUD_START_ON
        self.visible = true
        self.opacity = 255
        $game_switches[PRABS::CONFIG::HUD_SWITCH_ID] = true
      else
        self.visible = false
        self.opacity = 0
        $game_switches[PRABS::CONFIG::HUD_SWITCH_ID] = false
      end
    end    
    $game_system.hud_started = true
    refresh
  end
  
  def yield_sprites
    yield @back
    yield @texts
    yield @hp_bar
    yield @mp_bar
    yield @exp_bar
    yield @character
    yield @hotkeys
  end
  
  #-----------------------------------------------------------------------------
  # Visibilidade?
  #-----------------------------------------------------------------------------

  def visible=(valor)
    @visible = (valor == true)
    yield_sprites {|s| s.visible = @visible }
  end
  
  #-----------------------------------------------------------------------------
  # Visibilidade?
  #-----------------------------------------------------------------------------

  def opacity=(valor)
    @opacity = [[valor, 0].max, 255].min
    yield_sprites {|s| s.opacity = valor }
  end
  
  #-----------------------------------------------------------------------------
  # Posição X
  #-----------------------------------------------------------------------------

  def x=(valor)
    @x = valor
    @back.x = @x
    @texts.x = @x
    @hp_bar.x = @x + 38
    @mp_bar.x = @x + 38
    @exp_bar.x = @x + 38
    @character.x = @x + 19
  end    
  
  #-----------------------------------------------------------------------------
  # Posição Y
  #-----------------------------------------------------------------------------

  def y=(valor)
    @y = valor
    @back.y = @y
    @texts.y = @y
    @hp_bar.y = @y + 26
    @mp_bar.y = @y + 38
    @exp_bar.y = @y + 17
    @character.y = @y + 25
  end    
  
  #-----------------------------------------------------------------------------
  # Posição Z
  #-----------------------------------------------------------------------------

  def z=(valor)
    @z = valor
    @back.z = @z
    @texts.z = @z + 1
    @hp_bar.z = @z + 1
    @mp_bar.z = @z + 1
    @exp_bar.z = @z + 1
    @character.z = @z + 1
  end    
    
  #-----------------------------------------------------------------------------
  # Atualiza
  #-----------------------------------------------------------------------------

  def refresh
    @actor = $game_party.members[0]
    @character.character = $game_player
    @hp_bar.reset_valor($game_party.members[0].hp, $game_party.members[0].maxhp)
    @mp_bar.reset_valor($game_party.members[0].mp, $game_party.members[0].maxmp)
    refresh_texts
    update
  end
  
  #-----------------------------------------------------------------------------
  # Atualiza os textos
  #-----------------------------------------------------------------------------

  def refresh_texts
    @level = $game_party.members[0].level
    @name = $game_party.members[0].name

    @texts.bitmap.clear
    @texts.bitmap.draw_text(39, 4, 72, 9, @name, 0)
    @texts.bitmap.draw_text(39, 4, 72, 9, "Lvl: #{@level}", 2)
  end
  
  #-----------------------------------------------------------------------------
  # Atualização
  #-----------------------------------------------------------------------------

  def update
    if (!$game_switches[PRABS::CONFIG::HUD_SWITCH_ID])
      if self.visible
        self.opacity -= 26
        self.visible = false if self.opacity <= 0
      end          
      return
    elsif (self.opacity < 255)
      self.opacity += 26
      self.visible = true
    end
    if @level != $game_party.members[0].level || @name != $game_party.members[0].name
      refresh_texts
    end
    @character.update
    @hotkeys.update
    @hp_bar.set_valor($game_party.members[0].hp, $game_party.members[0].maxhp)
    @mp_bar.set_valor($game_party.members[0].mp, $game_party.members[0].maxmp)
    @exp_bar.refresh_valor($game_party.members[0].now_level_exp, $game_party.members[0].this_level_exp)
    @hp_bar.update
    @mp_bar.update
    @exp_bar.update
  end
  
  def dispose
    @texts.bitmap.dispose
    yield_sprites {|s| s.dispose }
  end
  
  def setup_y
    self.y = 8
    self.x = 8
  end
    
end
