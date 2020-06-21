#===============================================================================
# PRABS
#-------------------------------------------------------------------------------
# By: PR Coders
#===============================================================================

PRCoders.log_script("ABS", 2.0)

#===============================================================================
# Module Input
#-------------------------------------------------------------------------------
# Credits: PRCoders
#           poccil
#===============================================================================
if PRCoders.check_enabled?("ABS", 2.0)
  
PRCoders.load_script("ABS", 2.0)

module Input
  
  #--------------------------------------------------------------------------
  # * Váriáveis
  #-------------------------------------------------------------------------- 
  
  @keys = Array.new(256)
  @pressed = Array.new(256)
  @repeated = Array.new(256)
  @released = Array.new(256)
  @dir = Array.new(2)
  
  #--------------------------------------------------------------------------
  # * Constantes
  #-------------------------------------------------------------------------- 
  
  Mouse_Left = 1
  Mouse_Right = 2
  Mouse_Middle = 4
  Back = 8
  Tab = 9
  Enter = 13
  SHIFT = Shift = 16
  CTRL = Ctrl = 17
  ALT = Alt = 18
  Pause = 0x13
  CAPS = 0x14
  Esc = 0x1B
  LEFT = 0x25
  UP = 0x26  
  RIGHT = 0x27 
  DOWN = 0x28
  Space = 32
  PageUp = 0x21
  PageDowm = 0x22
  Home = 0x23
  End = 0x24
  Numberkeys = {}
  Numberkeys[0] = 48        # => 0
  Numberkeys[1] = 49        # => 1
  Numberkeys[2] = 50        # => 2
  Numberkeys[3] = 51        # => 3
  Numberkeys[4] = 52        # => 4
  Numberkeys[5] = 53        # => 5
  Numberkeys[6] = 54        # => 6
  Numberkeys[7] = 55        # => 7
  Numberkeys[8] = 56        # => 8
  Numberkeys[9] = 57        # => 9
  Numberpad = {}
  Numberpad[0] = 96
  Numberpad[1] = 97
  Numberpad[2] = 98
  Numberpad[3] = 99
  Numberpad[4] = 100
  Numberpad[5] = 101
  Numberpad[6] = 102
  Numberpad[7] = 103
  Numberpad[8] = 104
  Numberpad[9] = 105
  Letters = {}
  Letters["A"] = 65
  Letters["B"] = 66
  Letters["C"] = 67
  Letters["D"] = 68
  Letters["E"] = 69
  Letters["F"] = 70
  Letters["G"] = 71
  Letters["H"] = 72
  Letters["I"] = 73
  Letters["J"] = 74
  Letters["K"] = 75
  Letters["L"] = 76
  Letters["M"] = 77
  Letters["N"] = 78
  Letters["O"] = 79
  Letters["P"] = 80
  Letters["Q"] = 81
  Letters["R"] = 82
  Letters["S"] = 83
  Letters["T"] = 84
  Letters["U"] = 85
  Letters["V"] = 86
  Letters["W"] = 87
  Letters["X"] = 88
  Letters["Y"] = 89
  Letters["Z"] = 90
  Fkeys = {}
  F1 = Fkeys[1] = 112
  F2 = Fkeys[2] = 113
  F3 = Fkeys[3] = 114
  F4 = Fkeys[4] = 115
  F5 = Fkeys[5] = 116
  F6 = Fkeys[6] = 117
  F7 = Fkeys[7] = 118
  F8 = Fkeys[8] = 119
  F9 = Fkeys[9] = 120
  F10 = Fkeys[10] = 121
  F11 = Fkeys[11] = 122
  F12 = Fkeys[12] = 123
  Collon = 186        # => \ |
  Equal = 187         # => = +
  Comma = 188         # => , <
  Underscore = 189    # => - _
  Dot = 190           # => . >
  Backslash = 191     # => / ?
  Lb = 219
  Rb = 221
  Quote = 222         # => '"
  
  #--------------------------------------------------------------------------
  # * Constantes originais
  #-------------------------------------------------------------------------- 
  
  A = Letters["C"]
  B = [Letters["X"], Esc]
  C = [Letters["Z"], Space, Enter]
  X = Letters["A"]
  Y = Letters["S"]
  Z = Letters["D"]
  L = Letters["Q"]
  R = Letters["W"]
  
  #--------------------------------------------------------------------------
  # * Métodos da DLL
  #-------------------------------------------------------------------------- 
  
  ROUTE = "PRABS.dll" # DLL to C
  #ROUTE = "DLL\\PRABS.dll" # original
  UPDATE = Win32API.new(ROUTE, "UpdateInputArray", "lllll", "")
  ADDKEY = Win32API.new(ROUTE, "InputAddUsedKey", "i", "")

  #--------------------------------------------------------------------------
  # * Adiciona uma tecla para ser atualizada
  #-------------------------------------------------------------------------- 
  
  def self.add_key(key)
    if (key.is_a?(Array))
      for k in key
        self.add_key(k)
      end
      return
    end
    ADDKEY.call(key)
  end
  
  #--------------------------------------------------------------------------
  # * Reseta as teclas atualizadas
  #-------------------------------------------------------------------------- 
  
  def self.clear
    Win32API.new(ROUTE, "ClearUsedKeys", "", "").call()
  end
  
  #--------------------------------------------------------------------------
  # * Reseta as teclas atualizadas
  #-------------------------------------------------------------------------- 
  
  def self.setup_direction_keys(up, down, left, right)
    self.add_key(up)
    self.add_key(down)
    self.add_key(left)
    self.add_key(right)
    Win32API.new(ROUTE, "SetupDirectionKeys", "iiii", "").call(up, down, left, right)
  end
  
  #--------------------------------------------------------------------------
  # * Atualização
  #-------------------------------------------------------------------------- 
  
  def self.update
    UPDATE.call(@keys.__id__, @pressed.__id__, @repeated.__id__, @released.__id__, @dir.__id__)
  end
  
  #--------------------------------------------------------------------------
  # * Trigger?
  #-------------------------------------------------------------------------- 
  
  def self.trigger?(key)
    if (key.is_a?(Array))
      return key.any? { |k| self.trigger?(k) }
    end
    return @keys[key]
  end
  
  #--------------------------------------------------------------------------
  # * Press?
  #-------------------------------------------------------------------------- 
  
  def self.press?(key)
    if (key.is_a?(Array))
      return key.any? { |k| self.press?(k) }
    end
    return @pressed[key]
  end
  
  #--------------------------------------------------------------------------
  # * Repeat?
  #-------------------------------------------------------------------------- 
  
  def self.repeat?(key)
    if (key.is_a?(Array))
      return key.any? { |k| self.repeat?(k) }
    end
    return @repeated[key]
  end
  
  #--------------------------------------------------------------------------
  # * Release?
  #-------------------------------------------------------------------------- 
  
  def self.release?(key)
    if (key.is_a?(Array))
      return key.any? { |k| self.release?(k) }
    end
    return @released[key]
  end
  
  #--------------------------------------------------------------------------
  # * Dir4
  #-------------------------------------------------------------------------- 
  
  def self.dir4
    return @dir[0]
  end

  #--------------------------------------------------------------------------
  # * Dir8
  #-------------------------------------------------------------------------- 
  
  def self.dir8
    return @dir[1]
  end

  self.clear
  
end

# Adicionando as teclas mais utilizadas ao sistema

Input.add_key(Input::DOWN)
Input.add_key(Input::UP)
Input.add_key(Input::LEFT)
Input.add_key(Input::RIGHT)

Input.add_key(Input::A)
Input.add_key(Input::B)
Input.add_key(Input::C)
Input.add_key(Input::X)
Input.add_key(Input::Y)
Input.add_key(Input::Z)
Input.add_key(Input::L)
Input.add_key(Input::R)

Input.add_key(Input::CTRL)
Input.add_key(Input::SHIFT)
Input.add_key(Input::ALT)

Input.setup_direction_keys(Input::UP, Input::DOWN, Input::LEFT, Input::RIGHT)


###############################################################################
############################# PR Coders - AntiLag #############################
###############################################################################
#==============================================================================
# AntiLag do grupo PR Coders.
# Somente copie e use
#==============================================================================
  script_name = "AntiLag"
  version = 1.0
#==============================================================================
# Verifica se pode carregar o script
#==============================================================================

PRCoders.log_script(script_name, version)

if PRCoders.check_enabled?(script_name, version)

PRCoders.load_script(script_name, version)

#==============================================================================
# Script
#==============================================================================

module AntiLag
  
  SPC = Win32API.new("kernel32", "SetPriorityClass", "pi", "i")
  # Roda o jogo em Alta prioridade?
  @@high_priority = true
  # Usa o AntiLag de eventos?
  @@event = true
  
  if @@high_priority
    SPC.call(-1, 0x80)
  else
    SPC.call(-1, 0x20)
  end
  
  @@cache = {}
  
  #--------------------------------------------------------------------------
  # Alta prioridade?
  #--------------------------------------------------------------------------
  
  def self.high_priority?
    return @@high_priority
  end
  
  #--------------------------------------------------------------------------
  # Alta prioridade
  #--------------------------------------------------------------------------
  
  def self.high_priority
    return @@high_priority
  end
  
  #--------------------------------------------------------------------------
  # AntiLag de Evento?
  #--------------------------------------------------------------------------
  
  def self.event?
    return @@event
  end
  
  #--------------------------------------------------------------------------
  # AntiLag de Evento
  #--------------------------------------------------------------------------
  
  def self.event
    return @@event
  end
  
  #--------------------------------------------------------------------------
  # AntiLag de Evento = (true / false)
  #--------------------------------------------------------------------------
  
  def self.event=(valor)
    if valor
      @@event = true
    else
      @@event = false
    end
  end
  
  #--------------------------------------------------------------------------
  # Alta prioridade = (true / false)
  #--------------------------------------------------------------------------
  
  def self.high_priority=(valor)
    return if @@high_priority == valor
    if valor
      @@high_priority = true
      SPC.call(-1, 0x80)
      return
    end
    @@high_priority = false
    SPC.call(-1, 0x20)
  end
  
  #--------------------------------------------------------------------------
  # Largura do Bitmap
  #--------------------------------------------------------------------------
  
  def self.bitmap_width(character_name)
    if @@cache[character_name].nil?
      bitmap = Cache.character(character_name)
      sign = character_name[/^[\!\$]./]
      if sign != nil and sign.include?('$')
        cw = bitmap.width / 3
        ch = bitmap.height / 4
      else
        cw = bitmap.width / 12
        ch = bitmap.height / 8
      end
      @@cache[character_name] = [cw, ch]
    end
    return @@cache[character_name][0]
  end
  
  #--------------------------------------------------------------------------
  # Altura do Bitmap
  #--------------------------------------------------------------------------
  
  def self.bitmap_height(character_name)
    if @@cache[character_name].nil?
      bitmap = Cache.character(character_name)
      sign = character_name[/^[\!\$]./]
      if sign != nil and sign.include?('$')
        cw = bitmap.width / 3
        ch = bitmap.height / 4
      else
        cw = bitmap.width / 12
        ch = bitmap.height / 8
      end
      @@cache[character_name] = [cw, ch]
    end
    return @@cache[character_name][1]
  end
  
  
end

#==============================================================================
# Game_Character
#==============================================================================

class Game_Character
  
  def always_update
  end
  
  #--------------------------------------------------------------------------
  # Verifica se está na tela?
  #--------------------------------------------------------------------------
  
  def in_screen_x?(add_x=0)
    return ($game_map.in_screen_x?(@x, add_x))
  end
  
  #--------------------------------------------------------------------------
  # Verifica se está na tela?
  #--------------------------------------------------------------------------
  
  def in_screen_y?(add_y=0)
    return ($game_map.in_screen_y?(@y, add_y))
  end
  
  #--------------------------------------------------------------------------
  # Verifica se está na tela?
  #--------------------------------------------------------------------------
  
  def in_screen?(add_x=0, add_y=0)
    return false unless in_screen_x?(add_x)
    return false unless in_screen_y?(add_y)
    return true
  end
  
  #--------------------------------------------------------------------------
  # Verifica se colidiu com algum evento?
  #--------------------------------------------------------------------------
  
  def collide_with_screen_characters?(x, y)
    for event in $game_map.screen_events_xy(x, y)
      unless event.through                        
        return true if self.is_a?(Game_Event)         
        return true if event.priority_type == 1   
      end
    end
    if PRCoders.logged_and_loaded?("Catterpillar")
      unless PR_CATTERPILLAR::PARTY_TYPE == 0
        for actor in $game_train_actors.party_actors
          return true if actor.pos_nt?(x, y)
        end
      end
    end
    if @priority_type == 1      
      if PRCoders.logged_and_loaded?("Catterpillar")
        if $game_player.pos_nt?(x, y) and !self.is_a?(Game_Train_Actor)
          return true
        end     
      else
        return true if $game_player.pos_nt?(x, y)
      end
      return true if $game_map.boat.pos_nt?(x, y)   # ?????????
      return true if $game_map.ship.pos_nt?(x, y)   # ?????????
    end
    return false
  end
  
  #--------------------------------------------------------------------------
  # Verifica se é passável?
  #--------------------------------------------------------------------------
  
  def passable?(x, y)
    x = $game_map.round_x(x)
    y = $game_map.round_y(y)
    return false unless $game_map.valid?(x, y)
    return true if (@through or debug_through?)
    return false unless map_passable?(x, y)
    if $game_map.in_screen?(x, y)
      return false if collide_with_screen_characters?(x, y)
    else
      return false if collide_with_characters?(x, y)
    end
    return true                                     
  end

  def jumpable?(x, y)
    x = $game_map.round_x(x)
    y = $game_map.round_y(y)
    tile_id = $game_map.get_tile_id(x, y, 0)
    if tile_id != nil        # タイル ID 取得失敗 : 通行不可
      return true if $game_map.tile_waters?(tile_id)
    end
    for event in $game_map.screen_events_xy(x, y)
      return true if event.jumpable
    end
    return false
  end
  
end

#==============================================================================
# Game_Player
#==============================================================================

class Game_Player < Game_Character
  
  #--------------------------------------------------------------------------
  # Verifica se há eventos no herói
  #--------------------------------------------------------------------------
  
  def check_event_trigger_here(triggers)
    return false if $game_map.interpreter.running?
    result = false
    if PRCoders.logged_and_loaded?("ABS")
      if @here_events.nil?
        @here_events = $game_map.screen_events_xy(@x, @y)
      end
    else
      @here_events = $game_map.screen_events_xy(@x, @y)
    end
    for event in @here_events
      if PRCoders.logged_and_loaded?("ABS")
        next unless event.battler.nil?
      end
      if triggers.include?(event.trigger) and event.priority_type != 1
        event.start
        result = true if event.starting
      end
    end
    return result
  end
  
  #--------------------------------------------------------------------------
  # Verifica se há eventos na frente do herói
  #--------------------------------------------------------------------------
  
  def check_event_trigger_there(triggers)
    return false if $game_map.interpreter.running?
    result = false
    front_x = $game_map.x_with_direction(@x, @direction)
    front_y = $game_map.y_with_direction(@y, @direction)
    if PRCoders.logged_and_loaded?("ABS")
      if @front_events.nil?
        @front_events = $game_map.screen_events_xy(front_x, front_y)
      end
    else
      @front_events = $game_map.screen_events_xy(front_x, front_y)
    end
    for event in @front_events
      if PRCoders.logged_and_loaded?("ABS")
        next unless event.battler.nil?
      end
      if triggers.include?(event.trigger) and event.priority_type == 1
        event.start
        result = true
      end
    end
    if result == false and $game_map.counter?(front_x, front_y)
      front_x = $game_map.x_with_direction(front_x, @direction)
      front_y = $game_map.y_with_direction(front_y, @direction)
      for event in $game_map.screen_events_xy(front_x, front_y)
        if PRCoders.logged_and_loaded?("ABS")
          next unless event.battler.nil?
        end
        if triggers.include?(event.trigger) and event.priority_type == 1
          event.start
          result = true
        end
      end
    end
    return result
  end
  
  #--------------------------------------------------------------------------
  # Verifica se há eventos na posição x, Y
  #--------------------------------------------------------------------------
  
  def check_event_trigger_touch(x, y)
    return false if $game_map.interpreter.running?
    result = false
    if $game_map.in_screen?(x, y)
      events = $game_map.screen_events_xy(x, y)
    else
      events = $game_map.events_xy(x, y)
    end
    for event in events
      if PRCoders.logged_and_loaded?("ABS")
        next unless event.battler.nil?
      end
      if [1,2].include?(event.trigger) and event.priority_type == 1
        event.start
        result = true
      end
    end
    return result
  end

end

#==============================================================================
# Game_Event
#==============================================================================

class Game_Event < Game_Character
  
  #--------------------------------------------------------------------------
  # alias
  #--------------------------------------------------------------------------
  
  alias pr_coders_antilag_game_event_setup setup
  
  #--------------------------------------------------------------------------
  # Na tela?
  #--------------------------------------------------------------------------
  
  def in_screen?(*args)
    return true if @antilag_always_update
    if @large_bitmap
      return super(AntiLag.bitmap_width(@character_name), AntiLag.bitmap_height(@character_name))
    end
    return super
  end
  
  #--------------------------------------------------------------------------
  # Define a nova página do evento
  #--------------------------------------------------------------------------
  
  def setup(new_page)
    pr_coders_antilag_game_event_setup(new_page)
    @large_bitmap = false
    @antilag_always_update = false
    @antilag_always_update |= (not AntiLag.event?)
    @antilag_always_update |= [3, 4].include?(@trigger)
    return if @list.nil?
    for item in @list
      if item.code == 108 or item.code == 408
        case item.parameters[0].downcase
        when "always_update"
          @antilag_always_update |= true
        when "large_bitmap"
          @large_bitmap = true
        end
      end
    end
  end
  
end

#==============================================================================
# Game_Map
#==============================================================================

class Game_Map
  
  attr_reader :screen_events
  attr_reader :screen_enemies
  
  #--------------------------------------------------------------------------
  # alias
  #--------------------------------------------------------------------------
  
  alias pr_coders_antilag_game_map_setup_events setup_events
  
  #--------------------------------------------------------------------------
  # Cria os eventos
  #--------------------------------------------------------------------------
  
  def setup_events
    @screen_events = {}
    @screen_enemies = {}
    pr_coders_antilag_game_map_setup_events
  end
  
  #--------------------------------------------------------------------------
  # Eventos na posição X e Y da tela
  #--------------------------------------------------------------------------
  
  def screen_events_xy(x, y)
    result = []
    for event in @screen_events.values
      result.push(event) if event.pos?(x, y)
    end
    return result
  end
    
  #--------------------------------------------------------------------------
  # Atualiza os Eventos
  #--------------------------------------------------------------------------
  
  def update_events
    @screen_events.clear
    for k, event in @events
      event.always_update
      next unless event.in_screen?
      @screen_events[k] = event
      @screen_enemies[k] = event if event.enemy?
      event.update
    end
    for common_event in @common_events.values
      common_event.update
    end
  end
  
  #--------------------------------------------------------------------------
  # Atualiza os Verículos
  #--------------------------------------------------------------------------
  
  def update_vehicles
    for vehicle in @vehicles
      next unless vehicle.in_screen?
      vehicle.update
    end
  end
  #--------------------------------------------------------------------------
  # Verifica se está na tela (Coordenada X)?
  #--------------------------------------------------------------------------
  
  def in_screen_x?(px, add_x=0)
    ax = px * 256
    min_ax = ax
    max_ax = ax
    if add_x > 0
      min_ax = ax - add_x / 2
      max_ax = ax + add_x / 2
    end
    if self.loop_horizontal?
      if self.display_x > (self.width - 17) * 256
        w = (self.width * 256)
        min_x = (self.display_x - 2 * 256) % w
        max_x = (self.display_x + 19 * 256) % w
        if max_x == 0
          max_x = w
        end
        if min_ax > min_x
          return true
        end
        if max_ax < max_x
          return true
        end
        return false
      end
    end
    return false if (min_ax < self.display_x - 2 * 256)
    return false if (max_ax > self.display_x + 19 * 256)
    return true
  end
  
  #--------------------------------------------------------------------------
  # Verifica se está na tela (Coordenada Y)?
  #--------------------------------------------------------------------------
  
  def in_screen_y?(py, add_y=0)
    ay = py * 256
    min_ay = ay
    max_ay = ay
    if add_y > 0
      min_ay = ay - add_y
    end
    if self.loop_vertical?
      if self.display_y > (self.height - 13) * 256
        h = (self.height * 256)
        min_y = (self.display_y - 2 * 256) % h
        max_y = (self.display_y + 15 * 256) % h
        if max_y == 0
          max_y = h
        end
        if min_ay > min_y
          return true
        end
        if max_ay < max_y
          return true
        end
        return false
      end
    end
    return false if (min_ay < self.display_y - 2 * 256)
    return false if (max_ay > self.display_y + 15 * 256)
    return true
  end
  
  #--------------------------------------------------------------------------
  # Verifica se está na tela?
  #--------------------------------------------------------------------------
  
  def in_screen?(x, y, add_x=0, add_y=0)
    return false unless self.in_screen_x?(x, add_x)
    return false unless self.in_screen_y?(y, add_y)
    return true
  end
  
  #--------------------------------------------------------------------------
  # Verifica os eventos x_y
  #--------------------------------------------------------------------------
  
  def events_xy(x, y)
    result = []
    if in_screen?(x, y)
      for event in $game_map.screen_events.values
        result.push(event) if event.pos?(x, y)
      end
    else
      for event in $game_map.events.values
        result.push(event) if event.pos?(x, y)
      end
    end
    return result
  end
  
end

#==============================================================================
# Spriteset_Map
#==============================================================================

class Spriteset_Map
  
  #--------------------------------------------------------------------------
  # Atualiza os Characters
  #--------------------------------------------------------------------------
  
  def update_characters
    for sprite in @character_sprites
      next if sprite.character.nil?
      next unless sprite.character.in_screen?
      sprite.update
    end
  end

end

#==============================================================================
# Fim da verificação
#==============================================================================

end



module PRABS
  
  module CONFIG
      
    module ANIMATION
        
      DELAY = 2
      DEFAULT_FRAMES = 12
      DEFAULT_DAMAGE_FRAME = 0 
      
      FRAMES = {}
      DAMAGE_FRAME = {}   
    end
    
    module ENEMY
      
      ENEMIES = {}
      ENEMIES_ATTACK = {}
      SKILL_ENEMIES = {}
      COMBO_ENEMIES = {}
      
      def self.get_animation_attack(enemy_id, combo_index)
        anim = ENEMIES[[enemy_id, combo_index]]
        anim ||= ENEMIES[[enemy_id, 0]]
        anim ||= ""
        return anim
      end
      
      def self.get_animation_attack_id(enemy_id, combo_index)
        anim = ENEMIES_ATTACK[[enemy_id, combo_index]]
        anim ||= ENEMIES_ATTACK[[enemy_id, 0]]
        anim ||= 0
        return anim
      end
      
      def self.setup_attack_enemy_animation(enemy_id, combo_index, animation_name, animation_id)
        ENEMIES[[enemy_id, combo_index]] = animation_name.dup
        ENEMIES_ATTACK[[enemy_id, combo_index]] = animation_id
      end
      
      def self.setup_attack_combo_max(enemy_id, combo_max)
        COMBO_ENEMIES[enemy_id] = combo_max
      end
        
      def self.setup_skill_enemy_animation(enemy_id, skill_id, animation_name)
        SKILL_ENEMIES[[enemy_id, skill_id]] = animation_name.dup
      end
        
    end
      
    module BUTTONS
        
      ESQUIVAR = Input::X
      RIGHT_HAND  = Input::Y
      LEFT_HAND   = Input::Z
        
    end
    
    module TYPE
      
      LINHA    = 0
      CRUZ     = 1
      RED      = 2
      QUAD     = 3
      SHOOT    = 4
      
      SI_MESMO = 0
      FRENTE   = 1
      ATRAS    = -1
      
    end
    
    module DATABASE
      
      include PRABS::CONFIG::TYPE
      
      DEFAULT_SKILL = [1, 1]
      SKILLS = []
      
      CATCH_AND_USE_ITEMS = []
      CATCH_ITEM_ANIMATIONS     = []
      DEFAULT_CATCH_ITEM_ANIMATION = 1
      
      DEFAULT_ITEM = [1, 1]
      ITEMS = []
      
      REFLECT_SHIELDS = {}
      SHIELDS = {}
      
      def self.get_skill(skill_id)
        return (SKILLS[skill_id].nil? ? DEFAULT_SKILL : SKILLS[skill_id])
      end
      
      def self.get_item(item_id)
        return (ITEMS[item_id].nil? ? DEFAULT_ITEM : ITEMS[item_id])
      end
      
      def self.get_item_animation(item_id)
        return (CATCH_ITEM_ANIMATIONS[item_id].nil? ? DEFAULT_CATCH_ITEM_ANIMATION : CATCH_ITEM_ANIMATIONS[item_id])
      end
      
      def self.setup_shield(shield_id, animation_name, move = false, reflectable = [])
        REFLECT_SHIELDS[shield_id] = reflectable.dup
        SHIELDS[shield_id] = [animation_name.dup, move]
      end
      
    end
    
    module MESSAGES
      
      MISS = ""
      EVADE = ""
      LEVEL_UP = ""
      EXP_GAIN = ""
      GUARD = ""
      
    end
    
    HOTKEYS = []
    HUD_SWITCH_ID = 1
    HUD_SHOW_VALUES = 1
    HUD_START_ON = true
  
  end
    
  module SEQUENCE
    
    module BUTTONS
      
      FRONT         = 1
      BACK          = 2
      ATTACK        = 3
      
    end
    
    include BUTTONS
    
    SEQUENCES = {}
        
  end
  
  module HERO
    
    SEQUENCES_DATA = {}
    COMBO_DATA = {}
      
    def self.add_sequence(hero_id, weapon_id, combo_index, data)
      key = [hero_id, weapon_id, combo_index]
      data.sort! {|a, b| b[0].size - a[0].size }
      SEQUENCES_DATA[key] = data.dup
    end
    
    def self.add_sequence_default(hero_id, weapon_id, data)
      key = [hero_id, weapon_id, 0]
      data.sort! {|a, b| b[0].size - a[0].size }
      SEQUENCES_DATA[key] = data.dup
    end
    
    def self.set_combo_max(hero_id, weapon_id, valor, abs_wait = 60)
      key = [hero_id, weapon_id]
      COMBO_DATA[key] = [valor, abs_wait]
    end
    
    def self.get_combo_max(hero_id, weapon_id)
      key = [hero_id, weapon_id]
      return (COMBO_DATA[key].nil? ? [1, 60] : COMBO_DATA[key])
    end
    
    def self.get_sequence(hero_id, weapon_id, combo_index)
      key = [hero_id, weapon_id, combo_index]
      data = SEQUENCES_DATA[key]
      data ||= SEQUENCES_DATA[[hero_id, weapon_id, 0]]
      data ||= []
      return data
    end
      
  end
  
end

class Game_Temp
  
  attr_accessor :hud_need_refresh
  
end


#==============================================================================
# ABSAnimation
#------------------------------------------------------------------------------
# Classe que gerencia alguma animação do personagem
#==============================================================================

class ABSAnimation
  
  include PRABS::CONFIG::ANIMATION
  
  #-----------------------------------------------------------------------------
  # - Variáveis de acesso
  #-----------------------------------------------------------------------------
  
  attr_accessor :name
  attr_accessor :frames
  attr_accessor :index
  attr_accessor :active
  attr_accessor :no_image
  
  #-----------------------------------------------------------------------------
  # - Inicialização
  #-----------------------------------------------------------------------------
  
  def initialize
    clear
  end
  
  #-----------------------------------------------------------------------------
  # - Reseta
  #-----------------------------------------------------------------------------
  
  def clear
    @name = ""
    @frames = 0
    @index = 0
    @active = false
    @no_image = false
    @loop = false
    @play = false
    @count = 0
  end
  
  #-----------------------------------------------------------------------------
  # - Define a animação
  #-----------------------------------------------------------------------------
  
  def setup(name, frames, loop = false, play = true)
    @no_image = (name == "")
    @name = name.dup
    @frames = frames
    @index = 0
    @play = play
    @active = true
    unless @play
      @frames = 3
    end
    @loop = loop
    @count = 0
  end
  
  #-----------------------------------------------------------------------------
  # - Atualização
  #-----------------------------------------------------------------------------
  
  def update
    return if (! @active)
    @count += 1
    return if (@count % DELAY) != 0
    if @play
      if @index < @frames
        @index += 1
        if (@index >= @frames)
          if (@loop)
            @index = 0
            return
          end
          clear
        end
      end
    end
  end
  
end

#==============================================================================
# ABSAnimation
#------------------------------------------------------------------------------
# Classe que gerencia alguma animação do personagem
#==============================================================================

class ABSAction
  
  include PRABS::CONFIG::ANIMATION
  
  #-----------------------------------------------------------------------------
  # - Variáveis de acesso
  #-----------------------------------------------------------------------------
  
  attr_accessor :type
  attr_accessor :id
  attr_accessor :target
  
  #-----------------------------------------------------------------------------
  # - Inicialização
  #-----------------------------------------------------------------------------
  
  def initialize
    clear
  end
  
  #-----------------------------------------------------------------------------
  # - Reseta
  #-----------------------------------------------------------------------------
  
  def clear
    @type = 0
    @id = 0
    @target = nil
  end
  
  #-----------------------------------------------------------------------------
  # - Define um ataque
  #-----------------------------------------------------------------------------
  
  def setup_attack(target)
    @type = 1
    @target = target
  end
  
  #-----------------------------------------------------------------------------
  # - Define uma habilidade
  #-----------------------------------------------------------------------------
  
  def setup_skill(id, target)
    @type = 2
    @target = target
    @id = id
  end
  
  #-----------------------------------------------------------------------------
  # - Define uma defesa
  #-----------------------------------------------------------------------------
  
  def setup_guard()
    clear
    @type = 3
  end
    
end

#==============================================================================
# ABSTrigger  
#------------------------------------------------------------------------------
# Classe que gerencia o pressionamento de botões para algum combo
#==============================================================================

class ABSTrigger  
  
  include PRABS::SEQUENCE::BUTTONS
  include PRABS::CONFIG::BUTTONS
  
  VERIFY_SEQUENCES = Win32API.new("PRABS.dll", "VerifyABSSequences", "lliiii", "i")
  
  #-----------------------------------------------------------------------------
  # - Váriaveis de acesso
  #-----------------------------------------------------------------------------
    
  KEY_DELAY = 15
  
  #-----------------------------------------------------------------------------
  # - Inicialização
  #-----------------------------------------------------------------------------
  
  def initialize
    @keys = []
  end
  
  #-----------------------------------------------------------------------------
  # - Verifica as seqüencias por C++
  #-----------------------------------------------------------------------------
  
  def verify_sequences(sequences, left = false)
    return VERIFY_SEQUENCES.call(sequences.__id__, @keys.__id__, ATTACK, LEFT_HAND, RIGHT_HAND, (left ? 1 : 0))
  end
      
  #-----------------------------------------------------------------------------
  # - Limpa
  #-----------------------------------------------------------------------------
  
  def clear
    @keys.clear
  end
  
  #-----------------------------------------------------------------------------
  # - Pega o delay da ultima tecla
  #-----------------------------------------------------------------------------
  
  def get_last_size
    return (@keys.size <= 0 ? 0 : @keys.last[1])
  end
  
  #-----------------------------------------------------------------------------
  # - Atualização
  #-----------------------------------------------------------------------------
  
  def update(direction)
    if @keys.size > 0
      @keys[0][1] -= 1
      while (@keys.size > 0 && @keys[0][1] == 0)
        a = @keys.shift
      end
    end
    case direction
    when 2
      @keys << [BACK, KEY_DELAY - get_last_size] if Input.trigger?(Input::UP)
      @keys << [FRONT, KEY_DELAY - get_last_size] if Input.trigger?(Input::DOWN)
    when 4
      @keys << [BACK, KEY_DELAY - get_last_size] if Input.trigger?(Input::RIGHT)
      @keys << [FRONT, KEY_DELAY - get_last_size] if Input.trigger?(Input::LEFT)
    when 6
      @keys << [BACK, KEY_DELAY - get_last_size] if Input.trigger?(Input::LEFT)
      @keys << [FRONT, KEY_DELAY - get_last_size] if Input.trigger?(Input::RIGHT)
    when 8
      @keys << [BACK, KEY_DELAY - get_last_size] if Input.trigger?(Input::DOWN)
      @keys << [FRONT, KEY_DELAY - get_last_size] if Input.trigger?(Input::UP)
    end
    @keys << [LEFT_HAND, KEY_DELAY - get_last_size] if Input.trigger?(LEFT_HAND)
    @keys << [RIGHT_HAND, KEY_DELAY - get_last_size] if Input.trigger?(RIGHT_HAND)
  end
  
end

#==============================================================================
# ABSHotkeys
#------------------------------------------------------------------------------
# Teclas de atalho do ABS
#==============================================================================

class ABSHotkey
  
  #-----------------------------------------------------------------------------
  # - Inicialização
  #-----------------------------------------------------------------------------
  
  attr_accessor :key
  attr_accessor :type
  attr_accessor :id

  #-----------------------------------------------------------------------------
  # - Inicialização
  #-----------------------------------------------------------------------------
  
  def initialize(key)
    @key = key
    clear
  end
  
  #-----------------------------------------------------------------------------
  # - Limpa a Hotkey
  #-----------------------------------------------------------------------------
  
  def clear
    @type = 0
    @id = 0
  end
  
  def item?(item_id)
    return (@type == 2 && @id == item_id)
  end
  
  
  def skill?(skill_id)
    return (@type == 1 && @id == skill_id)
  end
  
  #-----------------------------------------------------------------------------
  # - Limpa a Hotkey
  #-----------------------------------------------------------------------------
  
  def set_item(item_id)
    @type = 2
    @id = item_id
  end
  
  #-----------------------------------------------------------------------------
  # - Limpa a Hotkey
  #-----------------------------------------------------------------------------
  
  def set_skill(skill_id)
    @type = 1
    @id = skill_id
  end
  
end

#==============================================================================
# ABSHotkeys
#------------------------------------------------------------------------------
# Teclas de atalho do ABS
#==============================================================================

class ABSCombo
  
  #-----------------------------------------------------------------------------
  # - Inicialização
  #-----------------------------------------------------------------------------
  
  attr_accessor :count
  attr_accessor :time
  attr_accessor :cleared

  #-----------------------------------------------------------------------------
  # - Inicialização
  #-----------------------------------------------------------------------------
  
  def initialize
    @data = []
    clear
    @cleared = false
  end
  
  #-----------------------------------------------------------------------------
  # - Limpa a Hotkey
  #-----------------------------------------------------------------------------
  
  def clear
    @count = 1
    @time  = 0
    @cleared = true
    @last_data = @data.dup
    @data.clear
  end
  
  #-----------------------------------------------------------------------------
  # - Limpa a Hotkey
  #-----------------------------------------------------------------------------
  
  def last_hits_number
    n = 0
    for d in @last_data
      n += 1 if (d) 
    end
    @last_data.clear
    return n
  end
  
  #-----------------------------------------------------------------------------
  # - Limpa a Hotkey
  #-----------------------------------------------------------------------------
  
  def update_combo(add, hitted)
    @data[@count] = hitted
    @time = 30 + add
    @count += 1
  end
    
  #-----------------------------------------------------------------------------
  # - Limpa a Hotkey
  #-----------------------------------------------------------------------------
  
  def update
    if (@time > 0)
      @time -= 1
      if (@time <= 0)
        clear
      end
    end
  end
  
end

#==============================================================================
# Map_Animation
#------------------------------------------------------------------------------
# Classe de alguma animação no Mapa
#==============================================================================

class Map_Animation
  
  attr_accessor :x
  attr_accessor :y
  attr_accessor :animation_id
  attr_accessor :animation
  attr_accessor :wait
  attr_accessor :delete
  attr_accessor :created
  attr_accessor :mirror
  attr_accessor :angle
  
  #--------------------------------------------------------------------------
  # ● Inicialização
  #--------------------------------------------------------------------------
      
  def initialize(x, y, animation_id, wait=0)
    @x = x
    @y = y
    @call_animation_id = animation_id
    @animation = $data_animations[@call_animation_id]
    @wait = wait
    @animation_id = 0
    if @wait <= 0
      @animation_id = @call_animation_id 
    end
    @mirror = false
    @angle = 0
    @delete = false
    @created = false
  end
  
  #--------------------------------------------------------------------------
  # ● Posição X
  #--------------------------------------------------------------------------
  
  def screen_x
    return ($game_map.adjust_x(@x * 256) + 8007) / 8 - 1000 + 16
  end
  
  #--------------------------------------------------------------------------
  # ● Posição Y
  #--------------------------------------------------------------------------
  
  def screen_y
    return ($game_map.adjust_y(@y * 256) + 8007) / 8 - 1000 + 32
  end

  #--------------------------------------------------------------------------
  # ● Atualização
  #--------------------------------------------------------------------------
      
  def update
    if @wait > 0
      @wait -= 1
      if @wait <= 0
        @animation_id = @call_animation_id 
      end
    end
  end
  
  #--------------------------------------------------------------------------
  # ● Deleta
  #--------------------------------------------------------------------------
      
  def delete=(valor)
    if valor
      @delete = true
      $game_map.abs_refresh["map_animation"] = true
    else
      @delete = false
    end
  end
  
end

#==============================================================================
# Item_Event
#------------------------------------------------------------------------------
# Classe do evento do item
#==============================================================================

class Item_Event < Game_Character
  
  attr_accessor :icon_index
  attr_accessor :delete
  attr_accessor :created
  
  #--------------------------------------------------------------------------
  # ● Inicialização
  #--------------------------------------------------------------------------
      
  def initialize(item)
    @item = item
    @icon_index = @item.icon_index
    super()
    @delete = false
    @created = false
    @move_speed = -1
    @move_frequency = 1
    @counter = 60 * 10
  end
  
  #--------------------------------------------------------------------------
  # ● Delete
  #--------------------------------------------------------------------------
      
  def delete=(valor)
    if valor
      @delete = true
      $game_map.abs_refresh["item_events"] = true
    else
      @delete = false
    end
  end

  #--------------------------------------------------------------------------
  # ● Ganha o item
  #--------------------------------------------------------------------------
      
  def gain_item
    return if @item.nil?
    $game_party.gain_item(@item, 1)
    if PRABS::CONFIG::DATABASE::CATCH_AND_USE_ITEMS[@item.id]
      $game_party.consume_item(@item)
      $game_temp.common_event_id = @item.common_event_id
      animation = $data_animations[@item.animation_id]
      waiting = 0
      unless animation.nil?
        $game_map.setup_map_animation(@item.animation_id, $game_player.x, $game_player.y, @direction)
        waiting = animation.frame_max
      end
      $game_player.battler.item_effect($game_player.battler, @item)
      $game_player.set_abs_damage($game_player, waiting)
    else
      $game_map.setup_map_animation(PRABS::CONFIG::DATABASE.get_item_animation(@item.id), @x, @y, @direction)
    end
  end
  
  #--------------------------------------------------------------------------
  # ● Atualização
  #--------------------------------------------------------------------------
      
  def update
    return if @delete
    super()
    if self.pos?($game_player.x, $game_player.y)
      gain_item
      self.delete = true
      @counter = 0
      return
    end
    if @counter > 0
      @counter -= 1
      if @counter < 40
        case @counter % 10
        when 0..4
          @opacity = 0
        else
          @opacity = 255
        end
      elsif @counter < 60
        case @counter % 10
        when 0..3
          @opacity = 0
        else
          @opacity = 255
        end
      elsif @counter < 90
        case @counter % 10
        when 0..2
          @opacity = 0
        else
          @opacity = 255
        end
      elsif @counter < 120
        case @counter % 10
        when 0..1
          @opacity = 0
        else
          @opacity = 255
        end
      else
        @opacity = 255
      end
    else
      self.delete = true
    end
  end

end

#==============================================================================
# ABS_Event
#------------------------------------------------------------------------------
# Classe do evento do ABS
#==============================================================================

class ABS_Event < Game_Event
  
  @@fake_shooter = nil
  
  attr_accessor :shooter
  attr_accessor :created
  attr_accessor :delete
  attr_accessor :type
  attr_accessor :type_id
  attr_accessor :wait
  
  #--------------------------------------------------------------------------
  # ● Inicialização
  #--------------------------------------------------------------------------
      
  def self.fake_shooter=(valor)
    @@fake_shooter = valor
  end
  
  #--------------------------------------------------------------------------
  # ● Inicialização
  #--------------------------------------------------------------------------
      
  def initialize(new_map_id, pre_map_id, pre_map_event_id)
    map = load_data(sprintf("Data/Map%03d.rvdata", pre_map_id))
    event = map.events[pre_map_event_id]
    @type = 0
    @type_id = 0
    @created = false
    @delete = false
    @wait = 0
    super(new_map_id, event)
  end

  #--------------------------------------------------------------------------
  # ● Pode puxar?
  #--------------------------------------------------------------------------

  def pushable?
    return (@player_passable || @event_passable)
  end
  
  #--------------------------------------------------------------------------
  # ● Correndo?
  #--------------------------------------------------------------------------

  def abs_through?(character)
    if (character.is_a?(Game_Event))
      return true unless @player_passable
      return true
    end
    return true unless @event_passable
    return true
  end

  #--------------------------------------------------------------------------
  # ● Correndo?
  #--------------------------------------------------------------------------
  
  def dash?
    return @dashing
  end
  
  #--------------------------------------------------------------------------
  # ● Cast Skill
  #--------------------------------------------------------------------------
  
  def cast_skill_area(skill_id, enemies = false, player = false)
    skill = $data_skills[skill_id]
    targets = skill_area(skill, enemies, player)
    for target in targets
      @hitted |= target.suffer_skill(@shooter, skill, 0)
    end
  end
  
  #--------------------------------------------------------------------------
  # ● Cast Skill
  #--------------------------------------------------------------------------
  
  def delete_self
    self.delete = true
  end
  
  #--------------------------------------------------------------------------
  # ● Inimi
  #--------------------------------------------------------------------------
  
  def skill_area(skill, enemies = false, player = false)
    return [] if skill.nil?
    data = PRABS::CONFIG::DATABASE.get_skill(skill.id)
    if (data[2] == PRABS::CONFIG::TYPE::SHOOT)
      event = $game_map.setup_shoot_event(data[0], data[1], self)
      event.type = 0
      event.type_id = skill.id
      return []
    end
    if (data[1] <= 1)
      front_x = $game_map.x_with_direction(@x, @direction, data[0])
      front_y = $game_map.y_with_direction(@y, @direction, data[0])
      if (skill.animation_id < 0)
        animation = $game_map.setup_map_animation(@battler.atk_animation_id, front_x, front_y, @direction)
      else
        animation = $game_map.setup_map_animation(skill.animation_id, front_x, front_y, @direction)
      end
      return get_single_target(skill, front_x, front_y, enemies, player)
    elsif (data[1] > 1)
      front_x = $game_map.x_with_direction(@x, @direction, data[0])
      front_y = $game_map.y_with_direction(@y, @direction, data[0])
      if (skill.animation_id < 0)
        animation = $game_map.setup_map_animation(@battler.atk_animation_id, front_x, front_y, @direction)
      else
        animation = $game_map.setup_map_animation(skill.animation_id, front_x, front_y, @direction)
      end
      return get_multiple_targets(skill, front_x, front_y, data[2], data[1], enemies, player)
    end
  end

  #--------------------------------------------------------------------------
  # ● Retorna uma array de possibilidades de inimigos
  #--------------------------------------------------------------------------
  
  def get_single_target(obj, x, y, enemies, player)
    if (obj.for_opponent?)
      result = []
      if player
        result << $game_player if ($game_player.pos?(x, y))
      end
      if enemies
        if obj.is_a?(RPG::Skill)
          for event in $game_map.screen_events_xy(x, y)
            result << event if event.skill_hittable?
          end
        else
          for event in $game_map.screen_events_xy(x, y)
            result << event if event.item_hittable?
          end
        end
      end
      return result
    end
  end

  #--------------------------------------------------------------------------
  # ● Retorna uma array de possibilidades de inimigos
  #--------------------------------------------------------------------------
  
  def get_multiple_targets(obj, cx, cy, type, raio, enemies, player)
    result = []
    result += get_enemy_battlers(obj, cx, cy, type, raio) if (enemies == true)
    result += get_party_battlers(obj, cx, cy, type, raio) if (player == true)
    return result
  end

  #--------------------------------------------------------------------------
  # ● Delete
  #--------------------------------------------------------------------------
      
  def delete=(valor)
    if valor
      @delete = true
      $game_map.abs_refresh["shoot_events"] = true
    else
      @delete = false
    end
  end
  
  #--------------------------------------------------------------------------
  # Verifica se é passável?
  #--------------------------------------------------------------------------
  
  def map_passable?(x, y)
    if @over_water
      return $game_map.shoot_passable?(x, y)
    end
    return $game_map.passable?(x, y)
  end

  #--------------------------------------------------------------------------
  # ● Verifica as condições
  #--------------------------------------------------------------------------
      
  def clear_abs_starting
    # Lutador
    @battler = nil
    # Aliado
    @hit_enemy = false
    @hit_ally = false
    # Limpa o Tempo de deletar
    @delete_time = -1
    @delete_timer_on = false
    # Deleta ao encostar?
    @delete_on_hit = false
    @delete_on_move_failed = false
    @delete_on_out_of_map = false
    @dashing = false
    @player_passable = false
    @event_passable = false
    @over_water = false
  end

  #--------------------------------------------------------------------------
  # ● Verifica os comentários do Evento
  #--------------------------------------------------------------------------
  
  def refresh_comments
    for item in @list
      next if item.nil?
      if (item.code == 108 || item.code == 408)
        case item.parameters[0].downcase
        when /delete_time[ ]?(\d+)/
          @delete_time = $1.to_i * Graphics.frame_rate
          @delete_timer_on = true
        # Deleta ao Encostar no inimigo
        when /delete_on[ ](.*)/
          check_delete_on($1.split(" "))
        when /deleteon[ ](.*)/
          check_delete_on($1.split(" "))
        when /delete on[ ](.*)/
          check_delete_on($1.split(" "))
        when /player_passable/
          @player_passable = true
        when /event_passable/
          @event_passable = true
        when /over_water/
          @over_water = true
        when /dashing/
          @dashing = true
        end
      end
    end
  end
  
  #--------------------------------------------------------------------------
  # ● Acerta o alvo
  #--------------------------------------------------------------------------
  
  def check_delete_on(args)
    for arg in args
      case arg
      when /hit/
        @delete_on_hit = true
      when /move_failed/
        @delete_on_move_failed = true
      when /out_of_map/
        @delete_on_out_of_map = true
      end
    end
  end
  
  #--------------------------------------------------------------------------
  # ● Acerta o alvo
  #--------------------------------------------------------------------------
  
  def hit_target(s, target)
    if (@type == 0)
      if (target.direction == (10 - @direction))
        if target.player_attacker?
          reflect = PRABS::CONFIG::DATABASE::REFLECT_SHIELDS[target.battler.armor1_id].include?(1)
          reflect |= PRABS::CONFIG::DATABASE::REFLECT_SHIELDS[target.battler.armor1_id].include?(@type_id)
          if (target.shielded && reflect)
            set_direction(10 - @direction)
            @x = (@real_x / 256.0).round
            @y = (@real_y / 256.0).round
            @shooter = target
            return false
          end
        elsif target.reflect_shootable_skills?(@type_id)
          set_direction(10 - @direction)
          @x = (@real_x / 256.0).round
          @y = (@real_y / 256.0).round
          @shooter = target
          return false
        end
      end
    end
    self.delete = true
    return false if s.nil?
    case @type
    when 0
      target.suffer_skill(s, $data_skills[@type_id], 0)
    when 1
      target.suffer_item(s, $data_items[@type_id], 0)
    end
    return true
  end
  
  #--------------------------------------------------------------------------
  # ● Acerta o alvo
  #--------------------------------------------------------------------------
  
  def hit_item(s, target)
    self.delete = true
    return if s.nil?
    target.suffer_item(s, $data_items[@type_id], 0)
  end
  
  #--------------------------------------------------------------------------
  # ● Acerta o alvo
  #--------------------------------------------------------------------------
  
  def hit_skill(s, target)
    self.delete = true
    return if s.nil?
    target.suffer_skill(s, $data_skills[@type_id], 0)
  end
  
  #--------------------------------------------------------------------------
  # ● Acerta o alvo
  #--------------------------------------------------------------------------
  
  def animation_abs_event(s)
    case @type
    when 0
      skill = $data_skills[@type_id]
      return if skill.nil?
      animation = $game_map.setup_map_animation(skill.animation_id, @x, @y, @direction)
    when 1
      item = $data_items[@type_id]
      return if item.nil?
      animation = $game_map.setup_map_animation(item.animation_id, @x, @y, @direction)
    end
  end

  #--------------------------------------------------------------------------
  # ● Atualização
  #--------------------------------------------------------------------------
  
  def update
    return if @delete
    if @wait > 0
      @wait -= 1
      return
    end
    unless self.in_screen?
      self.delete = true
      return 
    end
    if (@delete_timer_on)
      @delete_time -= 1
      if @delete_time <= 0
        self.delete = true
        return
      end
    end
    targets = []
    if (@shooter.is_a?(Game_Event))
      if $game_player.pos?(@x, @y)
        s = (@shooter.nil? ? @@fake_shooter : @shooter)
        if (hit_target(s, $game_player))
          animation_abs_event(s)
        end
        return
      end
    elsif (@type == 0)
      for event in $game_map.get_abs_events.values
        if (event.pos?(@x, @y) && event.skill_hittable?)
          s = (@shooter.nil? ? @@fake_shooter : @shooter)
          hit_skill(s, event)
          animation_abs_event(s)
          return
        end
      end
    elsif (@type == 1)
      for event in $game_map.get_abs_events.values
        if (event.pos?(@x, @y) && event.item_hittable?)
          s = (@shooter.nil? ? @@fake_shooter : @shooter)
          hit_item(s, event)
          animation_abs_event(s)
          return
        end
      end
    end     
    super()
    if @move_failed 
      check_asb_trigger
      if @delete_on_move_failed
        self.delete = true
        return 
      end
    end
    if @delete_on_out_of_map && !self.in_screen?
      self.delete = true
    end
  end
  
  def check_asb_trigger
    fx = $game_map.x_with_direction(@x, @direction)
    fy = $game_map.y_with_direction(@y, @direction)
    if (@shooter.is_a?(Game_Event))
      if $game_player.pos?(fx, fy)
        s = (@shooter.nil? ? @@fake_shooter : @shooter)
        if (hit_target(s, $game_player))
          animation_abs_event(s)
        end
        return
      end
    elsif (@type == 0)
      for event in $game_map.get_abs_events.values
        if (event.pos?(fx, fy) && event.skill_hittable?)
          s = (@shooter.nil? ? @@fake_shooter : @shooter)
          hit_skill(s, event)
          animation_abs_event(s)
          return
        end
      end
    elsif (@type == 1)
      for event in $game_map.get_abs_events.values
        if (event.pos?(fx, fy) && event.item_hittable?)
          s = (@shooter.nil? ? @@fake_shooter : @shooter)
          hit_item(s, event)
          animation_abs_event(s)
          return
        end
      end
    end     
  end
  
end

#==============================================================================
# Game_Temp
#------------------------------------------------------------------------------
# Classe que guarda as váriaveis temporárias
#==============================================================================

class Game_Temp

  #--------------------------------------------------------------------------
  # ● Váriaveis
  #--------------------------------------------------------------------------
  
  attr_accessor :abs_refresh_characters
  attr_accessor :hud_combo_count
  attr_accessor :hotkey_message
  attr_accessor :hotkey_message_counter

  #--------------------------------------------------------------------------
  # ● Alias
  #--------------------------------------------------------------------------
  
  alias pr_abs_gtemp_initialize initialize

  #--------------------------------------------------------------------------
  # ● Inicialização
  #--------------------------------------------------------------------------
  
  def initialize
    @abs_refresh_characters = {}
    # Combo Count
    @hud_combo_count = 0
    @hotkey_message_counter = 0
    @hotkey_message = ""
    pr_abs_gtemp_initialize
  end
  
end

#==============================================================================
# Game_System
#==============================================================================

class Game_System

  #--------------------------------------------------------------------------
  # ● Váriaveis
  #--------------------------------------------------------------------------
  
  attr_accessor :sequence_switches

  #--------------------------------------------------------------------------
  # ● Alias
  #--------------------------------------------------------------------------
  
  alias pr_abs_gsystem_initialize initialize

  #--------------------------------------------------------------------------
  # ● Inicialização
  #--------------------------------------------------------------------------
  
  def initialize
    @sequence_switches = {}
    pr_abs_gsystem_initialize
  end
  
end

#==============================================================================
# Game_SelfSwitches
#------------------------------------------------------------------------------
# Classe que gerencia as switches locais.
# Pode ser acessada utilizando $game_self_switches.
#==============================================================================

class Game_SelfSwitches
  attr_reader :data
end

#==============================================================================
# Game_Battler
#------------------------------------------------------------------------------
# Classe que guarda as váriaveis temporárias
#==============================================================================

class Game_Battler
  
  attr_accessor :unlimited_mp
  
  #--------------------------------------------------------------------------
  # ● Efeito do ataque do ABS
  #--------------------------------------------------------------------------
  
  def abs_attack_effect(attacker, left_handed = false, multiplier = 1)
    clear_action_results
    unless attack_effective?(attacker)
      @skipped = true
      return
    end
    if rand(100) >= calc_hit(attacker)  
      @missed = true
      return
    end
    if rand(100) < calc_eva(attacker)
      @evaded = true
      return
    end
    make_abs_attack_damage_value(attacker, left_handed, multiplier)
    execute_damage(attacker)
    if @hp_damage == 0
      return                                    
    end
    apply_state_changes(attacker)
  end
  
  #--------------------------------------------------------------------------
  # ● Cria o dano do ataque do ABS
  #--------------------------------------------------------------------------
  
  def make_abs_attack_damage_value(attacker, left_handed = false, multiplier = 1)
    damage = attacker.abs_base_atk(left_handed) * 4 - self.def * 2
    damage = 0 if damage < 0      
    damage *= elements_max_rate(attacker.element_set)   
    damage /= 100
    if damage == 0                                  
      damage = rand(2)                              
    elsif damage > 0                                
      @critical = (rand(100) < attacker.cri)        
      @critical = false if prevent_critical         
      damage *= 3 if @critical                      
    end
    damage = apply_variance(damage, 20)             
    damage = apply_guard(damage)  
    damage *= multiplier
    @hp_damage = damage                             
  end
  
  #--------------------------------------------------------------------------
  # ● Base do ataque ABS
  #--------------------------------------------------------------------------
 
  def abs_base_atk(lef_handed = false)
    return self.base_atk
  end
  #--------------------------------------------------------------------------
  # ● アイテムの適用可能判定
  #     user : アイテムの使用者
  #     item : アイテム
  #--------------------------------------------------------------------------
  
  def item_effective?(user, item)
    if item.for_dead_friend? != dead?
      return false
    end
    if (not $game_temp.in_battle and !$scene.is_a?(Scene_Map) and item.for_friend?)
      return item_test(user, item)
    end
    return true
  end
  
  #--------------------------------------------------------------------------
  # ● Habilidade é usada
  #--------------------------------------------------------------------------
  
  def used_skill(skill)
  end
  
  #--------------------------------------------------------------------------
  # ● Unlimited MP
  #--------------------------------------------------------------------------
  
  def calc_mp_cost(skill)
    if @unlimited_mp
      return 0
    elsif half_mp_cost
      return skill.mp_cost / 2
    else
      return skill.mp_cost
    end
  end
  
  #--------------------------------------------------------------------------
  # ● Pode Usar a Habilidade
  #--------------------------------------------------------------------------
  
  def abs_skill_can_use?(skill, force = false)
    return false unless skill.is_a?(RPG::Skill)
    return false unless movable?
    return false if silent? and skill.spi_f > 0
    return false if calc_mp_cost(skill) > mp
    return skill.battle_ok?
  end

  
end

#==============================================================================
# Game_Actor
#------------------------------------------------------------------------------
# Classe que guarda as váriaveis temporárias
#==============================================================================

class Game_Actor < Game_Battler
  
  #--------------------------------------------------------------------------
  # ● Pode Usar a Habilidade
  #--------------------------------------------------------------------------
  
  def abs_skill_can_use?(skill, force = false)
    unless force
      return false unless skill_learn?(skill)
    end
    return super(skill)
  end

  def abs_equips(left_handed = false)
    result = []
    result << (left_handed ? $data_weapons[@armor1_id] : $data_weapons[@weapon_id])
    result += armors
  end
  
  def abs_base_atk(left_handed = false)
    n = actor.parameters[2, @level]
    for item in abs_equips(left_handed).compact do n += item.atk end
    return n
  end
  
  #--------------------------------------------------------------------------
  # ● Retorna o necessário de experiencia para esse level
  #--------------------------------------------------------------------------
  
  def this_level_exp
    return (@exp_list[@level + 1] - @exp_list[@level])
  end
  
  #--------------------------------------------------------------------------
  # ● Retorna o necessário de experiencia para esse level
  #--------------------------------------------------------------------------
  
  def now_level_exp
    return (@exp - @exp_list[@level])
  end

end
#==============================================================================
# ABS_Target
#------------------------------------------------------------------------------
# Superclasse ABS_Target
#==============================================================================

class ABS_Target
  attr_accessor :distance
  attr_accessor :character
  def initialize(game_character, distance)
    @character = game_character
    @distance = distance
  end
end
#==============================================================================
# ABS_Targets
#------------------------------------------------------------------------------
# Superclasse ABS_Targets
#==============================================================================

class ABS_Targets
  def initialize
    @targets = []
  end
  
  def [](target_id)
    return @targets[target_id]
  end
  
  def push(target)
    @targets.push(target)
  end
  
  def get_closest
    @targets = @targets.sort_by { |target| target.distance }
    return @targets[0]
  end
end
#==============================================================================
# Game_Character
#------------------------------------------------------------------------------
# Superclasse para as classe Game_Player e Game_Event
#==============================================================================

class Game_Character
  
  include PRABS::CONFIG::ANIMATION
  
  INSIDE_CHECK = Win32API.new("PRABS.dll", "InsideType", "iiiiiii", "i")
  
  #--------------------------------------------------------------------------
  # ● Váriáveis de acessos
  #--------------------------------------------------------------------------
  
  attr_accessor :pre_dead
  attr_accessor :abs_animation
  attr_accessor :abs_action
  attr_accessor :battler
  attr_accessor :collapse
  attr_accessor :appear
  attr_accessor :clear_sprite
  attr_accessor :white_flash
  attr_accessor :blink
  attr_accessor :shielded
  attr_accessor :ch
  attr_accessor :cw
  attr_accessor :hud_balloon_id
  attr_accessor :shielded
  attr_accessor :hudded_ballon
  attr_accessor :last_action_type
  attr_accessor :last_action
  attr_accessor :attacked_by
  attr_accessor :permanent_balloon_id

  #--------------------------------------------------------------------------
  # ● Alias
  #--------------------------------------------------------------------------
  
  alias pr_abs_game_character_initialize initialize
  alias pr_abs_game_character_update update
  
  #--------------------------------------------------------------------------
  # ● Inicialização
  #--------------------------------------------------------------------------
  
  def initialize
    @pre_dead = false
    @abs_animation = ABSAnimation.new()
    @abs_wait = 0
    @wait_for_real_dead = 0
    @battler = nil
    @collapse = false
    @appear = false
    @white_flash = false
    @clear_sprite = false
    @blink = false
    @shielded = false
    @ch = 0
    @cw = 0
    @hud_balloon_id = 0
    #====
    @hudded_ballon = false
    @hudded_ballon_x = -1
    @hudded_ballon_y = -1
    @last_action_type = 0
    @last_action = 0
    @no_damage = false
    @attacked_by = nil
    pr_abs_game_character_initialize

    @abs_target = ABS_Target.new(nil, 99)
    @permanent_balloon_id = 0
  end
  
  def get_dist(character)
    dx = (distance_x_from_char(character)).abs
    dy = (distance_y_from_char(character)).abs
    if (dx > dy)
      return (dy * 1.6) + (dx - dy)
    else
      return (dx * 1.6) + (dy - dx)
    end
  end
  
  def player_attacker?
    return false
  end
  #--------------------------------------------------------------------------
  # ● Distancia X
  #--------------------------------------------------------------------------
  
  def distance_x_from_char(char)
    return distance_x_from_target(char.x)
  end

  def distance_x_from_target(x)
    sx = @x - x
    if $game_map.loop_horizontal?         # 横にループしているとき
      if sx.abs > $game_map.width / 2     # 絶対値がマップの半分より大きい？
        sx -= $game_map.width             # マップの幅を引く
      end
    end
    return sx
  end
  
  #--------------------------------------------------------------------------
  # ● Distancia Y
  #--------------------------------------------------------------------------
 
  def distance_y_from_char(char)
    return distance_y_from_target(char.y)
  end

  def distance_y_from_target(y)
    sy = @y - y
    if $game_map.loop_vertical?           # 縦にループしているとき
      if sy.abs > $game_map.height / 2    # 絶対値がマップの半分より大きい？
        sy -= $game_map.height            # マップの高さを引く
      end
    end
    return sy
  end

  #--------------------------------------------------------------------------
  # ● Move em direção ao Character
  #--------------------------------------------------------------------------
  
  def walkto(sx, sy, force_movement = false)
    if sx.abs > sy.abs                  # 横の距離のほうが長い
      sx > 0 ? move_left : move_right   # 左右方向を優先
      if @move_failed
        if sy != 0
          sy > 0 ? move_up : move_down
          if @move_failed && force_movement
            abs_random_movement
            @move_failed = true
          end
        elsif force_movement
          abs_random_movement
          @move_failed = true
        end
      end
    else                                # 縦の距離のほうが長いか等しい
      sy > 0 ? move_up : move_down      # 上下方向を優先
      if @move_failed 
        if sx != 0
          sx > 0 ? move_left : move_right
          if @move_failed && force_movement
            abs_random_movement
            @move_failed = true
          end
        elsif force_movement
          abs_random_movement
          @move_failed = true
        end
      end
    end
  end

  def move_toward_character(char, force_movement = false)
    sx = distance_x_from_char(char)
    sy = distance_y_from_char(char)
    if sx != 0 or sy != 0
      walkto(sx, sy, force_movement)
    end
  end

  def abs_random_movement
    if rand(2) == 0
      rand(2) == 0 ? move_left(false) : move_right(false)
    else
      rand(2) == 0 ? move_up(false) : move_down(false)
    end
  end
  
  def dead?
    return false if @battler.nil?
    return @battler.dead?
  end
  
  def setup_hudded_ballon
    @hudded_ballon = true
    @hudded_ballon_x = @x
    @hudded_ballon_y = @y
  end
  
  #--------------------------------------------------------------------------
  # ● Método que ocorrerá ao mudar de mapa
  #--------------------------------------------------------------------------
  
  def unsetup(new_map_id)
  end

  #--------------------------------------------------------------------------
  # ● Atualização dos métodos que sempre devem ocorrer
  #--------------------------------------------------------------------------
  
  def always_update
    if (@pre_dead)
      @wait_for_real_dead -= 1 if (@wait_for_real_dead > 0)
      set_dead if @wait_for_real_dead <= 0
    end
  end
  
  #--------------------------------------------------------------------------
  # ● Atuaalização
  #--------------------------------------------------------------------------
  
  def update
    @abs_animation.update if (@abs_animation != nil)
    if @hudded_ballon
      if !self.pos?(@hudded_ballon_x, @hudded_ballon_y)
        @hudded_ballon = false
        $game_player.refresh_hud_balloon
      end
    end
    pr_abs_game_character_update
  end
  
  #--------------------------------------------------------------------------
  # ● Animando o ABS?
  #--------------------------------------------------------------------------
  
  def abs_animating?
    return (@abs_animation != nil && @abs_animation.active)
  end
  
  #--------------------------------------------------------------------------
  # ● Setup
  #--------------------------------------------------------------------------
  
  def setup_animation(animation_name, loop = false, play = true)
    if animation_name != ""
      real_name = @character_name + "/" + animation_name
      frames = (FRAMES[real_name].nil? ? DEFAULT_FRAMES : FRAMES[real_name])
      @abs_animation.setup(real_name, frames, loop, play)
    else
      @abs_animation.setup("", DEFAULT_FRAMES, loop, play)
    end
    return frames
  end
  
  #--------------------------------------------------------------------------
  # ● Setup
  #--------------------------------------------------------------------------
  
  def setup_animation_real(real_name)
    frames = (FRAMES[real_name].nil? ? DEFAULT_FRAMES : FRAMES[real_name])
    @abs_animation.setup(real_name, frames)
    return frames
  end
  
  #--------------------------------------------------------------------------
  # ● Ataque é valido?
  #--------------------------------------------------------------------------
  
  def valid_attack?(target)
    return false if target.nil?
    return false if target.battler.nil?
    return false if @battler.nil?
    return true
  end
  
  #--------------------------------------------------------------------------
  # ● Método chamado quando se mata alguem
  #--------------------------------------------------------------------------
  
  def killed_enemy(char)
  end
  
  #--------------------------------------------------------------------------
  # ● Verifica alguma condição pra dano no ABS
  #--------------------------------------------------------------------------
  
  def check_abs_damage(attacker)
  end
  
  #--------------------------------------------------------------------------
  # ● Define o dano do ABS
  #--------------------------------------------------------------------------
  
  def set_abs_damage(attacker, adelay)
    delay = adelay
    if (@battler.missed || @battler.skipped)
      set_message(PRABS::CONFIG::MESSAGES::MISS, delay) unless @no_damage
      return
    elsif (@battler.evaded)
      set_message(PRABS::CONFIG::MESSAGES::EVADE, delay) unless @no_damage
      return
    end
    if (@battler.hp_damage == 0 and @shielded)
      set_message(PRABS::CONFIG::MESSAGES::GUARD, delay) unless @no_damage
      return
    end
    unless (@no_damage==true)
      if (@battler.hp_damage != 0)
        set_damage(@battler.hp_damage, @battler.critical, delay)
        delay += 20
      end      
      if (@battler.mp_damage != 0)
        set_mp_damage(@battler.mp_damage, @battler.critical, delay) 
      end
    end
    check_abs_damage(attacker)
    if @battler.dead?
      attacker.killed_enemy(self)
      set_pre_dead
    elsif @battler.hp_damage > 0
      @white_flash = true
    end
  end
  
  #--------------------------------------------------------------------------
  # ● Reflete as habilidades?
  #--------------------------------------------------------------------------
  
  def reflect_shootable_skills?(skill_id)
    return false
  end
  
  #--------------------------------------------------------------------------
  # ● Sofre o ataque
  #--------------------------------------------------------------------------
  
  def suffer_attack(attacker, delay, direction = 0)
    return false if @battler.nil? || attacker.battler.nil?
    if @shielded
      multiplier = (((10 - @direction) == direction) ? 0 : 1)
      @battler.abs_attack_effect(attacker.battler, false, multiplier)
      set_abs_damage(attacker, delay)
    else
      @battler.abs_attack_effect(attacker.battler)
      set_abs_damage(attacker, delay)
    end
    @attacked_by = attacker
  end
  
  #--------------------------------------------------------------------------
  # ● Ataca
  #--------------------------------------------------------------------------
  
  def attack(target, delay)
    target.suffer_attack(self, delay, @direction)
  end
  
  #--------------------------------------------------------------------------
  # ● Sofre a Habilidade
  #--------------------------------------------------------------------------
  
  def suffer_abs_event_skill(user, skill, delay)
    return false if @battler.nil? || user.battler.nil?
    @battler.skill_effect(user.battler, skill)
    set_abs_damage(user, delay)
  end
  
  #--------------------------------------------------------------------------
  # ● Sofre a Habilidade
  #--------------------------------------------------------------------------
  
  def suffer_skill(user, skill, delay)
    return false if @battler.nil? || user.battler.nil?
    @battler.skill_effect(user.battler, skill)
    set_abs_damage(user, delay)
  end
  
  #--------------------------------------------------------------------------
  # ● Usa a Habilidade
  #--------------------------------------------------------------------------
  
  def skill(target, skill, delay)
    target.suffer_skill(self, skill, delay)
  end
  
  #--------------------------------------------------------------------------
  # ● Sofre o item
  #--------------------------------------------------------------------------
  
  def suffer_item(user, item, delay = 0)
    return false if @battler.nil? || user.battler.nil?
    @battler.item_effect(user.battler, item)
    set_abs_damage(user, delay)
  end
  
  #--------------------------------------------------------------------------
  # ● Usa o item
  #--------------------------------------------------------------------------
  
  def item(target, item, delay = 0)
    target.suffer_item(self, item, delay)
  end
  
  #--------------------------------------------------------------------------
  # ● Inimigo de batalha 
  #--------------------------------------------------------------------------
  
  def battler_enemy?(enemy)
    return (enemy.is_a?(Game_Player))
  end
  
  #--------------------------------------------------------------------------
  # ● Retorna uma array de possibilidades de inimigos
  #--------------------------------------------------------------------------
  
  def get_single_target(obj, x, y)
    if (obj.for_opponent?)
      if (self.is_a?(Game_Event))
        return ($game_player.pos?(x, y) ? [$game_player] : [])
      end
      result = []
      if obj.is_a?(RPG::Skill)
        for event in $game_map.screen_events_xy(x, y)
          result << event if event.skill_hittable?
        end
      else
        for event in $game_map.screen_events_xy(x, y)
          result << event if event.item_hittable?
        end
      end
      return result
    end
  end

  #--------------------------------------------------------------------------
  # ● Retorna uma array de possibilidades de inimigos
  #--------------------------------------------------------------------------
  
  def get_multiple_targets(obj, cx, cy, type, raio)
    if (obj.for_opponent?)
      if (self.is_a?(Game_Event))
        return get_party_battlers(obj, cx, cy, type, raio)
      end
      return get_enemy_battlers(obj, cx, cy, type, raio)
    elsif (obj.for_friend?)
      if (self.is_a?(Game_Event))
        return get_party_battlers(obj, cx, cy, type, raio)
      end
      return get_enemy_battlers(obj, cx, cy, type, raio)
    end
  end
  
  #--------------------------------------------------------------------------
  # ● Retorna uma array de possibilidades de inimigos
  #--------------------------------------------------------------------------
  
  def get_party_battlers(obj, cx, cy, type, raio)
    return ($game_player.inside_type?(cx, cy, type, raio, @direction) ? [$game_player] : [])
  end
  
  #--------------------------------------------------------------------------
  # ● Retorna uma array de possibilidades de inimigos
  #--------------------------------------------------------------------------
  
  def get_enemy_battlers(obj, cx, cy, type, raio)
    result = []
    if obj.is_a?(RPG::Skill)
      for event in $game_map.get_abs_events.values
        if event.inside_type?(cx, cy, type, raio, @direction)
          result << event if event.skill_hittable?
        end
      end
    else
      for event in $game_map.get_abs_events.values
        if event.inside_type?(cx, cy, type, raio, @direction)
          result << event if event.item_hittable?
        end
      end
    end
    return result
  end
  
  #--------------------------------------------------------------------------
  # ● Inimi
  #--------------------------------------------------------------------------
  
  def skill_area(skill, *args)
    return [] if skill.nil?
    data = PRABS::CONFIG::DATABASE.get_skill(skill.id)
    if (data[2] == PRABS::CONFIG::TYPE::SHOOT)
      event = $game_map.setup_shoot_event(data[0], data[1], self)
      event.type = 0
      event.type_id = skill.id
      return []
    end
    if (data[1] <= 1)
      front_x = $game_map.x_with_direction(@x, @direction, data[0])
      front_y = $game_map.y_with_direction(@y, @direction, data[0])
      if (skill.animation_id < 0)
        animation = $game_map.setup_map_animation(@battler.atk_animation_id, front_x, front_y, @direction)
      else
        animation = $game_map.setup_map_animation(skill.animation_id, front_x, front_y, @direction)
      end
      return get_single_target(skill, front_x, front_y)
    elsif (data[1] > 1)
      front_x = $game_map.x_with_direction(@x, @direction, data[0])
      front_y = $game_map.y_with_direction(@y, @direction, data[0])
      if (skill.animation_id < 0)
        animation = $game_map.setup_map_animation(@battler.atk_animation_id, front_x, front_y, @direction)
      else
        animation = $game_map.setup_map_animation(skill.animation_id, front_x, front_y, @direction)
      end
      return get_multiple_targets(skill, front_x, front_y, data[2], data[1])
    end
  end
  
  #--------------------------------------------------------------------------
  # ● Inimi
  #--------------------------------------------------------------------------
  
  def item_area(item)
    return [] if item.nil?
    data = PRABS::CONFIG::DATABASE.get_item(item.id)
    if (data[2] == SHOOT)
      event = $game_map.setup_shoot_event(data[0], data[1], self)
      event.type = 1
      event.type_id = item.id
      return []
    end
    if (data[1] <= 1)
      front_x = $game_map.x_with_direction(@x, @direction, data[0])
      front_y = $game_map.y_with_direction(@y, @direction, data[0])
      animation = $game_map.setup_map_animation(item.animation_id, front_x, front_y, @direction)
      return get_single_target(item, front_x, front_y)
    elsif (data[1] > 1)
      front_x = $game_map.x_with_direction(@x, @direction, data[0])
      front_y = $game_map.y_with_direction(@y, @direction, data[0])
      animation = $game_map.setup_map_animation(item.animation_id, front_x, front_y, @direction)
      return get_multiple_targets(item, front_x, front_y, data[2], data[1])
    end
  end
    
  #--------------------------------------------------------------------------
  # ● É inimigo?
  #--------------------------------------------------------------------------
  
  def enemy?
    return false
  end
    
  #--------------------------------------------------------------------------
  # ● Está dentro do Tipo?
  #--------------------------------------------------------------------------
  
  def inside_type?(cx, cy, type, raio, direction)
    return (INSIDE_CHECK.call(@x, @y, cx, cy, type, raio, direction) == 1)
  end
    
  #--------------------------------------------------------------------------
  # ● Verifica se está morto
  #--------------------------------------------------------------------------
  
  def set_pre_dead
    @pre_dead = true
    @wait_for_real_dead = 48
    @collapse = true
  end
    
  #--------------------------------------------------------------------------
  # ● Verifica se está morto
  #--------------------------------------------------------------------------
  
  def set_dead
    @pre_dead = false
  end
    
  #--------------------------------------------------------------------------
  # ● Acertável pelo Herói?
  #--------------------------------------------------------------------------
  
  def weapon_hittable?
    return false
  end

  #--------------------------------------------------------------------------
  # ● Acertável pelo Herói?
  #--------------------------------------------------------------------------
  
  def item_hittable?
    return false
  end
  
  #--------------------------------------------------------------------------
  # ● Acertável pelo Herói?
  #--------------------------------------------------------------------------
  
  def skill_hittable?
    return false
  end
  
  #--------------------------------------------------------------------------
  # ● Método chamado ao trocar de Scene
  #--------------------------------------------------------------------------
  
  def scene_unsetup
    if @pre_dead
      set_dead
      return
    end
  end
  
  #--------------------------------------------------------------------------
  # Através?
  #--------------------------------------------------------------------------
  
  def abs_through?(character)
    return @through
  end
  
  #--------------------------------------------------------------------------
  # Verifica se colidiu com algum evento?
  #--------------------------------------------------------------------------
  
  def collide_with_screen_characters?(x, y)    
    for event in $game_map.screen_events_xy(x, y, true)
      unless event.abs_through?(self)
        next if (event.character_name == "" && event.tile_id <= 0)
        return true if self.is_a?(Game_Event)
        return true if event.priority_type == 1   
      end
    end
    # For Followers
    for char in $game_party.followers
      unless char.battler.nil?
        return true if char.pos?(x, y) && !(self.is_a?(Game_Player) || self.is_a?(Game_Follower))
      end
    end
    if @priority_type == 1 && !self.is_a?(Game_Follower)
      unless $game_player.abs_through?(self)      
        return true if $game_player.pos_nt?(x, y)
      end
      return true if $game_map.boat.pos_nt?(x, y)   # ?????????
      return true if $game_map.ship.pos_nt?(x, y)   # ?????????
    end
    return false
  end
  
  #--------------------------------------------------------------------------
  # Verifica se colidiu com algum evento?
  #--------------------------------------------------------------------------
  
  def collide_with_characters?(x, y)
    for event in $game_map.events_xy(x, y, true)
      unless event.abs_through?(self)                     
        next if (event.character_name == "" && event.tile_id <= 0)
        return true if self.is_a?(Game_Event)     
        return true if event.priority_type == 1   
      end
    end
    # For Followers
    for char in $game_party.followers
      unless char.battler.nil?
        return true if char.pos?(x, y) && !(self.is_a?(Game_Player) || self.is_a?(Game_Follower))
      end
    end
    if @priority_type == 1
      unless $game_player.abs_through?(self)      
        return true if $game_player.pos_nt?(x, y)
      end
      return true if $game_map.boat.pos_nt?(x, y)   # ?????????
      return true if $game_map.ship.pos_nt?(x, y)   # ?????????
    end
    return false
  end
    
end

#==============================================================================
# Game_Event
#------------------------------------------------------------------------------
# Classe que controla os eventos do jogo
#==============================================================================

class Game_Event < Game_Character

  attr_reader :jumpable
  
  #--------------------------------------------------------------------------
  # ● Alias
  #--------------------------------------------------------------------------
      
  alias pr_abs_game_event_initialize initialize
  alias pr_abs_game_event_conditions_met? conditions_met?
  alias pr_abs_game_event_setup setup
  alias pr_abs_game_event_update update
  alias pr_abs_game_event_update_self_movement update_self_movement
    
  #--------------------------------------------------------------------------
  # ● Inicialização
  #--------------------------------------------------------------------------
      
  def initialize(map_id, event)
    @auto_wait = 0
    clear_abs_starting
    pr_abs_game_event_initialize(map_id, event)
  end
  
  #--------------------------------------------------------------------------
  # ● Método que ocorrerá ao mudar de mapa
  #--------------------------------------------------------------------------
  
  def unsetup(new_map_id)
    if @respawn_map
      respawn
    end
  end
  
  #--------------------------------------------------------------------------
  # ● Habilidade do ABS
  #--------------------------------------------------------------------------

  def abs_skill(skill_id, delay = 0, animation = true)
    if (use_skill($data_skills[skill_id], delay, animation))
      data = PRABS::CONFIG::DATABASE.get_skill(skill_id)
      if data[2] != PRABS::CONFIG::TYPE::SHOOT
        front_x = $game_map.x_with_direction(@x, @direction, data[0])
        front_y = $game_map.y_with_direction(@y, @direction, data[0])
        animation = $game_map.setup_map_animation($data_skills[skill_id].animation_id, front_x, front_y, @direction)
      end
    end
  end
  
  #--------------------------------------------------------------------------
  # ● Item
  #--------------------------------------------------------------------------

  def use_item(item, delay = 0, animation = true)
    @last_action_type = 2
    @last_action = item
    return false if item.nil?
    return false if @battler.nil?
    if $game_party.item_number(item) <= 0
      Sound.play_buzzer
      return false
    end
    $game_party.lose_item(item, 1)
    data = PRABS::CONFIG::DATABASE.get_item(item.id)
    setup_animation(data[3].nil? ? "" : data[3]) if animation
    if (data[2] == PRABS::CONFIG::TYPE::SHOOT)
      event = $game_map.setup_shoot_event(data[0], data[1], self, delay)
      event.type = 1
      event.type_id = item.id
      return true
    end
    targets = []
    if (item.for_user? || item.for_friend?)
      self.suffer_item(self, item, delay)
    elsif item.for_opponent?
      targets = item_area(item)
      for target in targets
        @hitted |= target.suffer_item(self, item, delay)
      end
    end
    return true
  end

  #--------------------------------------------------------------------------
  # ● Habilidade
  #--------------------------------------------------------------------------

  def use_skill(skill, delay = 0, animation = true)
    @last_action_type = 1
    @last_action = skill
    return false if skill.nil?
    return false if @battler.nil?
    if !@fake_enemy
      @battler.unlimited_mp = @unlimited_mp
      $game_temp.in_battle = true
      unless (@battler.abs_skill_can_use?(skill))
        $game_temp.in_battle = false
        Sound.play_buzzer
        return false
      end
      $game_temp.in_battle = false
      @battler.mp -= skill.mp_cost 
    end
    data = PRABS::CONFIG::DATABASE.get_skill(skill.id)
    a_name = data[3].nil? ? "" : data[3]
    setup_animation(data[3].nil? ? "" : data[3]) if animation
    @battler.used_skill(skill)
    if (data[2] == PRABS::CONFIG::TYPE::SHOOT)
      event = $game_map.setup_shoot_event(data[0], data[1], self, delay)
      event.type = 0
      event.type_id = skill.id
      return true
    end
    targets = []
    if (skill.for_user? || skill.for_friend?)
      self.suffer_skill(self, skill, delay)
    elsif skill.for_opponent?
      targets = skill_area(skill)
      for target in targets
        @hitted |= target.suffer_skill(self, skill, delay)
      end
    end
    return true
  end

  #--------------------------------------------------------------------------
  # ● 
  #--------------------------------------------------------------------------
      
  def always_update
    super()
    return unless $game_map.sec_passed
    if (@respawn_time > 0)
      @respawn_time -= 1
      if (@respawn_time <= 0)
        respawn
      end
    end
  end
  
  #--------------------------------------------------------------------------
  # ● Verifica as condições
  #--------------------------------------------------------------------------
      
  def conditions_met?(page)
    unless page.list.nil?
      unless page.list[0].nil?
        if page.list[0].code == 108
          parameter = page.list[0].parameters[0].upcase
          key = [@map_id, @id, ""]
          case parameter
          when /^SS[ ]?(.*)/
            conditions = $1.split(" ")
            for c in conditions
              key[2] = c
              return false unless $game_self_switches[key]
            end
          when /^SSOR[ ]?(.*)/
            conditions = $1.split(" ")
            retorna = true
            for c in conditions
              key[2] = c
              if $game_self_switches[key]
                retorna = false
                break
              end
            end
            return false if retorna
          end
        end
      end
    end
    pr_abs_game_event_conditions_met?(page)
  end
  
  #--------------------------------------------------------------------------
  # ● Define a página
  #--------------------------------------------------------------------------
  
  def setup(new_page)
    pr_abs_game_event_setup(new_page)
    clear_abs_starting
    unless @page.nil?
      setup_abs
    end
  end
  
  #--------------------------------------------------------------------------
  # ● Define a página
  #--------------------------------------------------------------------------
  
  def clear_abs_starting
    @battler = nil
    @enemy_id = 0
    @enemy = false
    @clear_sprite = true
    # Acertável?
    @weapon_hittable = false
    @item_hittable = false
    @skill_hittable = false
    # Pre morto?
    @pre_dead = false
    # Respawm
    @respawn_time = 0
    @respawn_map = false
    # Movimento Automático
    @automove = false
    @autoattack = false
    @autoskill = false
    @enemy_combo = [false, 0, 1]
    @player_on_sight = false
    @combo_max = 1
    @automove_sight = 5
    @random_respawn = false
    # Recuperação de MP
    @unlimited_mp = false
    @recover_mp = 0
    @recover_mp_delay = @original_mp_delay = 1
    @recover_hp = 0
    @recover_hp_delay = @original_hp_delay = 1
    # Invencibilidades
    @skill_invencible = {}
    @weapon_invencible = {}
    # Reflecção
    @reflect_shootable_skills = {}
    # Reflecção
    @dead_switches = []
    @dead_variables = []
    # ID DO BALÃO
    @hud_balloon_id = 0
    # No_Damage
    @no_damage = false
    @fake_enemy = false
    # Jumpable
    @jumpable = false
    @permanent_balloon_id = 0
  end
  
  #--------------------------------------------------------------------------
  # ● Atualiza os comentários
  #--------------------------------------------------------------------------
  
  def refresh_comments
    for item in @list
      if (item.code == 108 || item.code == 408)
        case item.parameters[0].downcase
        when /fake_enemy[ ]?(\d+)/
          @battler = Game_Enemy.new(0, $1.to_i)
          @enemy_id = $1.to_i
          @fake_enemy = true
          @enemy = false
        when /enemy[ ]?(\d+)/
          @battler = Game_Enemy.new(0, $1.to_i)
          @enemy_id = $1.to_i
          @enemy = true
        when /die_switch[ ]?(.*)/
          data = $1.split(" ")
          for wid in data
            @dead_switches << wid.to_i unless @dead_switches.include?(wid.to_i)
          end
        when /die_add_var[ ]?(.*)/
          data = $1.split(" ")
          for wid in data
            @dead_variables << wid.to_i
          end
        when /whittable/
          @weapon_hittable = true
        when /ihittable/
          @item_hittable = true
        when /shittable/
          @skill_hittable = true
        when /weapon_hittable/
          @weapon_hittable = true
        when /item_hittable/
          @item_hittable = true
        when /skill_hittable/
          @skill_hittable = true
        when /hittable/
          @weapon_hittable = true
          @item_hittable = true
          @skill_hittable = true
        when /automove_sight[ ]?(\d+)/
          @automove_sight = [1, $1.to_i].max
        when /automove/
          @automove = true
        when /autoattack/
          @autoattack = true
        when /autoskill/
          @autoskill = true
        when /combo_max[ ]?(\d+)/
          @combo_max = $1.to_i
        when /respawn_time[ ]?(\d+)/
          @respawn_time = $1.to_i
        when /respawn_map/
          @respawn_map = true
        when /random_respawn/
          @random_respawn = true
        when /no_damage/
          @no_damage = true
        when /unlimited_mp/
          @unlimited_mp = true
        when /reflect_shootable_skills[ ](.*)/
          data = $1.split(" ")
          for wid in data
            @reflect_shootable_skills[wid.to_i] = true
          end
        when /all_weapons_invencible/
          for i in 1...$data_weapons.size
            @weapon_invencible[i] = true
          end
        when /all_skills_invencible/
          for i in 1...$data_skills.size
            @skill_invencible[i] = true
          end
        when /weapon_invencible[ ]?(.*)/
          data = $1.split(" ")
          if data.include?("0")
            for i in 1...$data_weapons.size
              @weapon_invencible[i] = true
            end
          else
            for wid in data
              @weapon_invencible[wid.to_i] = true
            end
          end
        when /skill_invencible[ ]?(.*)/
          data = $1.split(" ")
          if data.include?("0")
            for i in 1...$data_skills.size
              @skill_invencible[i] = true
            end
          else
            for wid in data
              @skill_invencible[wid.to_i] = true
            end
          end
        when /kill_weapon[ ]?(.*)/
          data = $1.split(" ")
          for wid in data
            @weapon_invencible[wid.to_i] = false
          end
        when /kill_skill[ ]?(.*)/
          data = $1.split(" ")
          for wid in data
            @skill_invencible[wid.to_i] = false
          end
        when /recover_mp[ ]?(\d+)[ ](\d+)/
          @recover_mp = $1.to_i
          @recover_mp_delay = @original_mp_delay = $2.to_i
        when /recover_hp[ ]?(\d+)[ ](\d+)/
          @recover_hp = $1.to_i
          @recover_hp_delay = @original_hp_delay = $2.to_i
        when /hud_balloon[ ]?(\d+)/
          @hud_balloon_id = $1.to_i
        when /map_balloon[ ]?(\d+)/
          @balloon_id = @permanent_balloon_id = $1.to_i
        when /jumpable/
          @jumpable = true
        end
      end
    end
  end
  
  #--------------------------------------------------------------------------
  # ● Sofre o ataque
  #--------------------------------------------------------------------------
  
  def suffer_attack(attacker, delay, left_handed = false)
    if (@battler.nil?)
      if @weapon_hittable
        $game_self_switches[[@map_id, @id, "HIT"]] = true
        $game_self_switches[[@map_id, @id, "WHIT"]] = true
        $game_self_switches[[@map_id, @id, "IHIT_ID"]] = (left_handed ? attacker.battler.armor1_id : attacker.battler.weapon_id)
        self.refresh
        self.start
      end
      return false
    end
    return false if attacker.battler.nil?
    if (attacker.player_attacker?)
      weapon_id = (left_handed ? attacker.battler.armor1_id : attacker.battler.weapon_id)
      if (@weapon_invencible[weapon_id] == true)
        if (PRABS::CONFIG::MESSAGES::WEAPON_IMMUNE != "")
          set_message(PRABS::CONFIG::MESSAGES::WEAPON_IMMUNE, delay)
        end
        return false
      end
    end
    if @shielded
      multiplier = (((10 - @direction) == direction) ? 0 : 1)
      @battler.abs_attack_effect(attacker.battler, false, multiplier)
      effective = (@battler.hp_damage > 0)
    else
      @battler.abs_attack_effect(attacker.battler)
      effective = (@battler.hp_damage > 0)
    end
    set_abs_damage(attacker, delay)
    return effective
  end
  
  #--------------------------------------------------------------------------
  # ● Reflete as habilidades atiráveis?
  #--------------------------------------------------------------------------
  
  def reflect_shootable_skills?(skill_id)
    return ((@reflect_shootable_skills[skill_id] == true) || (@reflect_shootable_skills[0] == true))
  end
  
  #--------------------------------------------------------------------------
  # ● Sofre o ataque
  #--------------------------------------------------------------------------
  
  def suffer_skill(user, skill, delay)
    if @battler.nil?
      if @skill_hittable
        $game_self_switches[[@map_id, @id, "HIT"]] = true
        $game_self_switches[[@map_id, @id, "SHIT"]] = true
        $game_self_switches[[@map_id, @id, "SHIT_ID"]] = skill.id
        self.refresh
        self.start
      end
      return false
    end
    return false if user.battler.nil?
    if (@skill_invencible[skill.id] == true)
      if (PRABS::CONFIG::MESSAGES::SKILL_IMMUNE != "")
        set_message(PRABS::CONFIG::MESSAGES::SKILL_IMMUNE, delay)
      end
      return false
    end
    @battler.skill_effect(user.battler, skill)
    effective = (@battler.hp_damage > 0)
    set_abs_damage(user, delay)
    return effective
  end

  #--------------------------------------------------------------------------
  # ● Sofre o ataque
  #--------------------------------------------------------------------------
  
  def suffer_item(user, item, delay)
    if @battler.nil?
      if (@item_hittable)
        $game_self_switches[[@map_id, @id, "IHIT"]] = true
        $game_self_switches[[@map_id, @id, "IHIT_ID"]] = item.id
        self.refresh
        self.start
      end
      return false
    end
    return false if user.battler.nil?
    @battler.item_effect(user.battler, item)
    effective = (@battler.hp_damage > 0)
    set_abs_damage(user, delay)
    return effective
  end

  #--------------------------------------------------------------------------
  # ● Define o ABS
  #--------------------------------------------------------------------------
  
  def setup_abs
    refresh_comments
  end
  
  #--------------------------------------------------------------------------
  # ● É inimigo?
  #--------------------------------------------------------------------------
  
  def enemy?
    return (@enemy && @battler != nil)
  end
  
  #--------------------------------------------------------------------------
  # ● Verifica se está morto
  #--------------------------------------------------------------------------
  
  def set_dead
    super()
    @battler = nil
    $game_self_switches[[@map_id, @id, "DEAD"]] = true
    if (@dead_variables.size > 0 || @dead_switches.size > 0)
      for variable in @dead_variables
        $game_variables[variable] += 1
      end
      for switch in @dead_switches
        $game_switches[switch] = true
      end
      $game_map.need_refresh = true
    else
      self.refresh
    end
  end
  
  #--------------------------------------------------------------------------
  # ● Verifica se está morto
  #--------------------------------------------------------------------------
  
  def set_pre_dead
    super()
  end
  
  #--------------------------------------------------------------------------
  # ● Renascer
  #--------------------------------------------------------------------------
  
  def respawn
    $game_self_switches[[@map_id, @id, "DEAD"]] = false
    self.refresh
    @appear = true
    if (@random_respawn)
      new_x = rand($game_map.width)
      new_y = rand($game_map.height)
      while (!passable?(new_x, new_y))
        new_x = rand($game_map.width)
        new_y = rand($game_map.height)
      end
      self.moveto(new_x, new_y)
    end
  end
  
  #--------------------------------------------------------------------------
  # ● Acertável pelo Herói?
  #--------------------------------------------------------------------------
  
  def weapon_hittable?
    return (@weapon_hittable || self.enemy?)
  end

  #--------------------------------------------------------------------------
  # ● Acertável pelo Herói?
  #--------------------------------------------------------------------------
  
  def item_hittable?
    return (@item_hittable || self.enemy?)
  end
  
  #--------------------------------------------------------------------------
  # ● Acertável pelo Herói?
  #--------------------------------------------------------------------------
  
  def skill_hittable?
    return (@skill_hittable || self.enemy?)
  end
  
  #--------------------------------------------------------------------------
  # ● Atualização
  #--------------------------------------------------------------------------
  
  def update
    pr_abs_game_event_update
    if self.enemy?
      update_abs
    end
  end
  
  #--------------------------------------------------------------------------
  # ● Ataca o jogador
  #--------------------------------------------------------------------------
  
  def target_attack(target, combo_index)
    return if target.battler.nil?
    animation_name = PRABS::CONFIG::ENEMY.get_animation_attack(@enemy_id, combo_index)
    $game_map.setup_map_animation(PRABS::CONFIG::ENEMY.get_animation_attack_id(@enemy_id, combo_index), target.x, target.y, @direction)
    real_name = ""
    if animation_name != ""
      real_name = @character_name + "/" + animation_name
    else
      real_name = @character_name
    end
    frames = (FRAMES[real_name].nil? ? DEFAULT_FRAMES : FRAMES[real_name])
    @abs_animation.setup(real_name, frames)
    attack(target, (DAMAGE_FRAME[real_name].nil? ? DEFAULT_DAMAGE_FRAME : DAMAGE_FRAME[real_name]))
  end
  
  #--------------------------------------------------------------------------
  # ● Atualização do ABS
  #--------------------------------------------------------------------------
  
  def update_abs
    unless @battler.dead?
      if (@recover_mp > 0)
        if (@recover_mp_delay > 0)
          @recover_mp_delay -= 1
          if (@recover_mp_delay <= 0)
            @recover_mp_delay = @original_mp_delay
            @battler.mp += @recover_mp
          end
        end
      end
      if (@recover_hp > 0)
        if (@recover_hp_delay > 0)
          @recover_hp_delay -= 1
          if (@recover_hp_delay <= 0)
            @recover_hp_delay = @original_hp_delay
            @battler.hp += @recover_hp
          end
        end
      end
    end
    update_get_abs_target
    return if @abs_target.character.nil?
    if (@autoattack && @enemy_combo[0])
      if (@enemy_combo[1] > 0)
        @enemy_combo[1] -= 1
        return
      end
      dx = (@x - @abs_target.character.x).abs
      dy = (@y - @abs_target.character.y).abs
      if dx <= 1 && dy <= 1
        target_attack(@abs_target.character, @enemy_combo[2])
        if (rand(@combo_max * 2) <= (@combo_max - @enemy_combo[2] + 1) && @enemy_combo[2] < @combo_max)
          @enemy_combo[1] = rand(10) + 10
          @enemy_combo[2] += 1
        else
          @enemy_combo = [false, 0, 1]
        end
        @abs_wait = 40 + (@enemy_combo[2] * 15)
      end
      return
    end
    if @abs_wait > 0
      @abs_wait -= 1
      return
    end
    return if self.moving?
    if @auto_wait > 0
      @auto_wait -= 1
    elsif @autoattack_type == 1
      update_autoattack
      @autoattack_type = 0
      return
    elsif @autoattack_type == 2
      update_autoskill
      @autoattack_type = 0
      return
    else
      if (@autoattack && @autoskill)
        prob = rand(200)
        @autoattack_type = ((prob < 100) ? 1 : 2)
      elsif @autoattack
        @autoattack_type = 1
      elsif @autoskill
        @autoattack_type = 2
      end
    end
    if @automove
      update_automove
    end
  end
  
  #--------------------------------------------------------------------------
  # ● Auto Attack
  #--------------------------------------------------------------------------
  
  def update_autoattack
    if @player_on_sight
      use_autoattack(@abs_target.character)
    end
  end
  
  #--------------------------------------------------------------------------
  # ● Autotattack
  #--------------------------------------------------------------------------
  
  def use_autoattack(char)       
    dx = (@x - char.x).abs
    dy = (@y - char.y).abs
    if dx <= 1 && dy <= 1
      target_attack(char, @enemy_combo[2])
      @abs_wait = 40
      if (rand(@combo_max * 2) <= @combo_max)
        @enemy_combo = [true, rand(10) + 10, 2]
      else
        @enemy_combo = [false, 0, 1]
      end
      @auto_wait = 40
    end
  end
  
  #--------------------------------------------------------------------------
  # ● Get ABS Target
  #--------------------------------------------------------------------------
  
  def update_get_abs_target
    begin
      abs_targets = ABS_Targets.new
      abs_targets.push(ABS_Target.new($game_player, get_dist($game_player)))
      $game_party.followers.each do |char|
        if char.battler != nil
          abs_targets.push(ABS_Target.new(char, get_dist(char)))
        end
      end
      @abs_target = abs_targets.get_closest
    rescue
      @abs_target = ABS_Target.new($game_player, get_dist($game_player))
    end
  end
  
  #--------------------------------------------------------------------------
  # ● Atualização da Movimentação automática
  #--------------------------------------------------------------------------
  
  def update_automove
    if @player_on_sight
      move_toward_character(@abs_target.character)
    end
    @player_on_sight = (@abs_target.distance <= @automove_sight)
  end
  
  #--------------------------------------------------------------------------
  # ● Atualização da Habilidade
  #--------------------------------------------------------------------------
  
  def update_autoskill
    skills = []
    prob = rand(10)
    for action in @battler.enemy.actions
      next unless @battler.conditions_met?(action)
      if action.kind == 1
        if (prob < action.rating)
          times = (action.rating - prob)
          for i in 0...times
            skills.push(action.skill_id)
          end
        end
      end
    end
    return if skills.size <= 0
    skill = $data_skills[skills[rand(skills.size)]]
    return if skill.nil?
    if (skill.for_user? || skill.for_friend?)
      self.suffer_skill(self, skill, delay)
    elsif skill.for_opponent?
      targets = skill_area(skill)
      for target in targets
        target.suffer_skill(self, skill, delay)
      end
    end
    @auto_wait = 60
    @abs_wait = 40
  end
  
  #--------------------------------------------------------------------------
  # ● Atualização do Movimento
  #--------------------------------------------------------------------------
  
  def update_self_movement
    return if @player_on_sight
    pr_abs_game_event_update_self_movement
  end
  
  #--------------------------------------------------------------------------
  # ● Método chamado ao trocar de Scene
  #--------------------------------------------------------------------------
  
  def scene_unsetup
    super()
  end
  
end

#==============================================================================
# Game_Party
#==============================================================================

class Game_Party < Game_Unit
  
  def update
  end
  
end

#==============================================================================
# Game_Character
#------------------------------------------------------------------------------
# Superclasse para as classe Game_Player e Game_Event
#==============================================================================

class Game_Player < Game_Character
  
  include PRABS::CONFIG::BUTTONS
  include PRABS::CONFIG::ANIMATION
  
  WALK_DELAY = 5
  
  #--------------------------------------------------------------------------
  # ● Alias
  #--------------------------------------------------------------------------
  
  alias pr_abs_game_player_initialize initialize
  alias pr_abs_game_player_movable? movable?
  alias pr_abs_game_player_refresh refresh
  alias pr_abs_game_player_update update
  
  #--------------------------------------------------------------------------
  # ● Teclas de atalho
  #--------------------------------------------------------------------------
  
  attr_reader   :hotkeys
  
  #--------------------------------------------------------------------------
  # ● Inicialização
  #--------------------------------------------------------------------------
  
  def initialize
    @abs_animation = ABSAnimation.new()
    @abs_action    = ABSAction.new()
    @abs_trigger   = ABSTrigger.new()
    @abs_stopped   = false
    @triggered     = [0, 0]
    @abs_stopped   = false
    @shielded      = false
    @hotkeys       = []
    @jumping_count = []
    @last_jump_timer = 0
    @combo         = ABSCombo.new
    for key in PRABS::CONFIG::HOTKEYS
      next if key.nil?
      Input.add_key(key)
      @hotkeys.push(ABSHotkey.new(key))
    end
    pr_abs_game_player_initialize
  end
  
  def player_attacker?
    return true
  end
  
  #--------------------------------------------------------------------------
  # ● Redefine o Battler
  #--------------------------------------------------------------------------
  
  def refresh
    if ($game_party.members.size <= 0)
      @battler = nil
    else
      @battler = $game_party.members[0]
    end
    refresh_hud_balloon
    pr_abs_game_player_refresh
  end
  
  #--------------------------------------------------------------------------
  # ● Atualização
  #--------------------------------------------------------------------------
  
  def update
    @here_events = nil
    @front_events = nil
    if (@pre_dead)
      @wait_for_real_dead -= 1 if (@wait_for_real_dead > 0)
      set_dead if @wait_for_real_dead <= 0
      return
    end
    update_abs
    pr_abs_game_player_update
  end
  
  #--------------------------------------------------------------------------
  # ● Pulo pelo abs
  #--------------------------------------------------------------------------
  def abs_jump(x_plus, y_plus)
    if x_plus.abs > y_plus.abs            
      x_plus < 0 ? turn_left : turn_right
    elsif x_plus.abs > y_plus.abs         
      y_plus < 0 ? turn_up : turn_down
    end
    
    # if (@direction == 6) || (@direction == 4)
    #   @angle_target = -360 * x_plus
    #   @angle_duration = 24
    # end
    
    if jumpable?(@x + x_plus, @y + y_plus)
      x_plus *= 2
      y_plus *= 2
    end

    if passable?(@x + x_plus, @y + y_plus)
      @x += x_plus
      @y += y_plus
      $game_party.update_move(5, x_plus, y_plus)
      distance = 1# Math.sqrt(x_plus * x_plus + y_plus * y_plus).round
      @jump_peak = 10 + distance - @move_speed
    else
      @jump_peak = 10 - @move_speed
    end
    @jump_count = @jump_peak * 2
    @stop_count = 0
    straighten
  end

  #--------------------------------------------------------------------------
  # ● Movimenta o personagem
  #--------------------------------------------------------------------------

  def move_by_input
    if Input.press?(ESQUIVAR)
      if @last_jump_timer > 0
        @last_jump_timer -= 1
      elsif @jumping_count.size < 2
        if Input.trigger?(Input::UP)
          @jumping_count.push(8)
        elsif Input.trigger?(Input::LEFT)
          @jumping_count.push(4)
        elsif Input.trigger?(Input::RIGHT)
          @jumping_count.push(6)
        elsif Input.trigger?(Input::DOWN)
          @jumping_count.push(2)
        end
      end
    end
    if Input.trigger?(JUMP)
      case Input.dir4
        when 2
          abs_jump(0, 1)
        when 4
          abs_jump(-1, 0) 
        when 6
          abs_jump(1, 0)
        when 8
          abs_jump(0, -1)
        end
    end
    if !jumping?
      if @jumping_count.size > 0
        move = @jumping_count.shift
        case move
        when 2
          abs_jump(0, 1)
        when 4
          abs_jump(-1, 0) 
        when 6
          abs_jump(1, 0)
        when 8
          abs_jump(0, -1)
        end
        @last_jump_timer = 7
        return
      end
    end
    return unless movable?
    return if $game_map.interpreter.running?
    return if @abs_stopped
    if Input.trigger?(Input::UP)
      @triggered = [8, WALK_DELAY]
      turn_up
      refresh_hud_balloon
    elsif Input.trigger?(Input::LEFT)
      @triggered = [4, WALK_DELAY]
      turn_left
      refresh_hud_balloon
    elsif Input.trigger?(Input::RIGHT)
      @triggered = [6, WALK_DELAY]
      turn_right
      refresh_hud_balloon
    elsif Input.trigger?(Input::DOWN)
      @triggered = [2, WALK_DELAY]
      turn_down
      refresh_hud_balloon
    end
    if @triggered[1] > 0
      @triggered[1] -= 1
      if (@triggered[1] <=0 )
        if (@triggered[0]==Input.dir4)
          move_by_direction(@triggered[0])
        end
        @triggered = [0, 0]
      end
      return
    else
      move_by_direction(Input.dir4)
    end
  end

  #--------------------------------------------------------------------------
  # ● Movimenta o personagem
  #--------------------------------------------------------------------------

  def move_by_direction(direction)
    case direction
    when 2;  move_down
    when 4;  move_left
    when 6;  move_right
    when 8;  move_up
    end
  end
  
  #--------------------------------------------------------------------------
  # ● Atualiza o ABS
  #--------------------------------------------------------------------------

  def update_abs
    return if @battler.nil?
    return if $game_map.interpreter.running?
    if @abs_wait > 0
      @abs_wait -= 1
      return
    end
    @combo.update
    update_trigger
    update_hotkeys
  end

  #--------------------------------------------------------------------------
  # ● Atualiza o ABS
  #--------------------------------------------------------------------------

  def update_hotkeys
    for hotkey in @hotkeys
      next if hotkey.type <= 0
      if Input.trigger?(hotkey.key)
        if (hotkey.type == 1)
          use_skill($data_skills[hotkey.id])
          break
        end
        use_item($data_items[hotkey.id])
        break
      end
    end
  end
  
  #--------------------------------------------------------------------------
  # ● Item
  #--------------------------------------------------------------------------

  def use_item(item, delay = 0, animation = true)
    @last_action_type = 2
    @last_action = item
    return false if item.nil?
    if $game_party.item_number(item) <= 0
      Sound.play_buzzer
      return false
    end
    $game_party.lose_item(item, 1)
    data = PRABS::CONFIG::DATABASE.get_item(item.id)
    setup_animation(data[3].nil? ? "" : data[3]) if animation
    if (data[2] == PRABS::CONFIG::TYPE::SHOOT)
      event = $game_map.setup_shoot_event(data[0], data[1], self, delay)
      event.type = 1
      event.type_id = item.id
      return true
    end
    targets = []
    if (item.for_user? || item.for_friend?)
      self.suffer_item(self, item, delay)
    elsif item.for_opponent?
      targets = item_area(item)
      for target in targets
        @hitted |= target.suffer_item(self, item, delay)
      end
    end
    return true
  end

  #--------------------------------------------------------------------------
  # ● Item
  #--------------------------------------------------------------------------

  def use_skill(skill, delay = 0, animation = true)
    @last_action_type = 1
    @last_action = skill
    return false if skill.nil?
    $game_temp.in_battle = true
    unless @battler.abs_skill_can_use?(skill, true)
      $game_temp.in_battle = false
      Sound.play_buzzer
      return false
    end
    $game_temp.in_battle = false
    @battler.mp -= skill.mp_cost
    data = PRABS::CONFIG::DATABASE.get_skill(skill.id)
    a_name = data[3].nil? ? "" : data[3]
    setup_animation(data[3].nil? ? "" : data[3]) if animation
    @battler.used_skill(skill)
    if (data[2] == PRABS::CONFIG::TYPE::SHOOT)
      if (data[4] != nil && data[4].size >= 2)
        if ($game_party.item_number($data_items[data[4][0]]) < data[4][1])
          Sound.play_buzzer
          return false
        end
        if (data[4][2] == true)
          $game_party.lose_item($data_items[data[4][0]], 1)
        end
      end
      if (data[5] != nil)
        $game_map.setup_map_animation(data[5], @x, @y, @direction)
      end
      event = $game_map.setup_shoot_event(data[0], data[1], self, delay)
      event.type = 0
      event.type_id = skill.id
      return true
    end
    targets = []
    if (skill.for_user? || skill.for_friend?)
      self.suffer_skill(self, skill, delay)
    elsif skill.for_opponent?
      targets = skill_area(skill)
      for target in targets
        @hitted |= target.suffer_skill(self, skill, delay)
      end
    end
    return true
  end

  #--------------------------------------------------------------------------
  # ● Atualiza as teclas
  #--------------------------------------------------------------------------

  def update_trigger
    @abs_trigger.update(@direction)
    update_left_hand
    update_right_hand
  end

  #--------------------------------------------------------------------------
  # ● Animação do escudo
  #--------------------------------------------------------------------------

  def setup_animation_shield(name, loop, play = true)
    return if name == ""
    setup_animation(name, loop, play)
  end
  
  #--------------------------------------------------------------------------
  # ● Pode se mecher?
  #--------------------------------------------------------------------------
  
  def movable?
    return false if (@abs_stopped == true)
    return pr_abs_game_player_movable?
  end

  #--------------------------------------------------------------------------
  # ● Atualiza as teclas
  #--------------------------------------------------------------------------

  def update_left_hand
    if (!(@battler.two_swords_style) && @battler.armor1_id > 0)
      if Input.press?(LEFT_HAND)
        unless @shielded
          if (data = PRABS::CONFIG::DATABASE::SHIELDS[@battler.armor1_id])
            @abs_stopped = (data[1] == true)
            setup_animation_shield(data[0], @abs_stopped, @abs_stopped)
            @direction_fix = true # @abs_stopped
          end
        end
        @shielded = true
        if (!@abs_stopped && @shielded)
          @abs_animation.index = @pattern
        end
      elsif @shielded
        @shielded = false
        @abs_stopped = false
        @direction_fix = false
        @abs_animation.clear
      end
      return
    end
    if @shielded
      @shielded = false
      @abs_stopped = false
      @abs_animation.clear
    end
    return unless @battler.two_swords_style
    data = PRABS::HERO.get_sequence(@battler.id, @battler.armor1_id, @combo.count)
    return if data.nil?
    return if data.size <= 0
    index = @abs_trigger.verify_sequences(data, true)
    return if index < 0
    @abs_trigger.clear
    cast_sequence(data[index], true)
    @combo.update_combo(@abs_wait, @hitted)
    @abs_wait += data[index][3] if data[index][3]
    combo_data = PRABS::HERO.get_combo_max(@battler.id, @battler.weapon_id) 
    if (@combo.count > combo_data[0] || data[index][4])
      @combo.clear
      @abs_wait = combo_data[1]
      @abs_wait ||= 0
    end
  end

  #--------------------------------------------------------------------------
  # ● Atualiza as teclas
  #--------------------------------------------------------------------------

  def update_right_hand
    data = PRABS::HERO.get_sequence(@battler.id, @battler.weapon_id, @combo.count)
    return if data.nil?
    return if data.size <= 0
    index = @abs_trigger.verify_sequences(data)
    return if index < 0
    @abs_trigger.clear
    cast_sequence(data[index])
    @combo.update_combo(@abs_wait, @hitted)
    combo_data = PRABS::HERO.get_combo_max(@battler.id, @battler.weapon_id) 
    if (@combo.count > combo_data[0] || data[index][4])
      @combo.clear
      @abs_wait = combo_data[1]
      @abs_wait ||= 0
    end
  end
  
  #--------------------------------------------------------------------------
  # ● Ataque da mão esquerda
  #--------------------------------------------------------------------------

  def cast_sequence(sequence, left_handed = false)
    if sequence[5].is_a?(String)
      return false unless ($game_system.sequence_switches[sequence[5]] == true)
    end
    @last_action_type = 0
    @last_action = (left_handed ? 1 : 0)
    delay = (DAMAGE_FRAME[sequence[2]].nil? ? DEFAULT_DAMAGE_FRAME : DAMAGE_FRAME[sequence[2]]) * DELAY
    @hitted = false
    if (sequence[1] == 0)
      @abs_wait = setup_animation(sequence[2])
      @abs_wait ||= 0
      front_x = $game_map.x_with_direction(@x, @direction)
      front_y = $game_map.y_with_direction(@y, @direction)
      $game_map.setup_map_animation((left_handed ? @battler.atk_animation_id2 : @battler.atk_animation_id), front_x, front_y, @direction)
      for event in $game_map.screen_events_xy(front_x, front_y)
        @hitted |= event.suffer_attack(self, delay, left_handed) if event.weapon_hittable?
      end
      return
    elsif (sequence[1] < 0)
      if (use_item($data_items[sequence[1]], delay, false))
        @abs_wait = setup_animation(sequence[2])
        @abs_wait ||= 0
        return true
      end
      return false
    end
    if (use_skill($data_skills[sequence[1]], delay, false))
      @abs_wait = setup_animation(sequence[2])
      @abs_wait ||= 0
      return true
    end
    return false
  end
      
  #--------------------------------------------------------------------------
  # ● Player não é inimigo
  #--------------------------------------------------------------------------
  
  def enemy?
    return false
  end
  
  #--------------------------------------------------------------------------
  # ● Define como morto
  #--------------------------------------------------------------------------
  
  def set_dead
    super()
    if $game_party.abs_all_dead?
      $game_temp.next_scene = "gameover"
    else
      $game_party.switch_to_next_member
    end
  end
  
  #--------------------------------------------------------------------------
  # ● Define como morto
  #--------------------------------------------------------------------------
  
  def set_pre_dead
    super()
  end
  
  #--------------------------------------------------------------------------
  # ● Método chamado quando se mata alguem
  #--------------------------------------------------------------------------
  
  def killed_enemy(char)
    if char.battler.is_a?(Game_Enemy)
      last_level = @battler.level
      for actor in $game_party.existing_members
        actor.gain_exp(char.battler.exp, false)
      end
      set_message(PRABS::CONFIG::MESSAGES::EXP_GAIN.gsub("[#VALOR]", char.battler.exp.to_s), 30, Color.new(255, 255, 255), nil, "FF_Sprite_Damage", [@cw / 2, @ch + 16], true)
      if last_level != @battler.level
        set_message(PRABS::CONFIG::MESSAGES::LEVEL_UP.gsub("[#LEVEL]", (@battler.level - last_level).to_s), 75, Color.new(255, 255, 255), nil, "FF_Sprite_Damage", [@cw / 2, @ch + 16], true)
      end
      $game_map.setup_item_events(char)
    end      
  end
  
  #--------------------------------------------------------------------------
  # ● Método chamado ao trocar de Scene
  #--------------------------------------------------------------------------
  
  def scene_unsetup
    super()
  end
  
  #--------------------------------------------------------------------------
  # ● 下に移動
  #     turn_ok : その場での向き変更を許可
  #--------------------------------------------------------------------------
  
  def move_down(turn_ok = true)
    super
    refresh_hud_balloon
  end
  #--------------------------------------------------------------------------
  # ● 左に移動
  #     turn_ok : その場での向き変更を許可
  #--------------------------------------------------------------------------
  def move_left(turn_ok = true)
    super
    refresh_hud_balloon
  end
  #--------------------------------------------------------------------------
  # ● 右に移動
  #     turn_ok : その場での向き変更を許可
  #--------------------------------------------------------------------------
  
  def move_right(turn_ok = true)
    super
    refresh_hud_balloon
  end
  
  #--------------------------------------------------------------------------
  # ● 上に移動
  #     turn_ok : その場での向き変更を許可
  #--------------------------------------------------------------------------
  
  def move_up(turn_ok = true)
    super
    refresh_hud_balloon
  end
  
  def refresh_hud_balloon
    fx = $game_map.x_with_direction(@x, @direction)
    fy = $game_map.y_with_direction(@y, @direction)
    @hud_balloon_id = 0
    for event in $game_map.screen_events_xy(fx, fy)
      if event.hud_balloon_id > 0
        @hud_balloon_id = event.hud_balloon_id
        event.setup_hudded_ballon
        break
      end
    end
  end
  
end

#==============================================================================
# Game_Map
#------------------------------------------------------------------------------
# Classe que lida com tudo relacionado ao mapa do jogo
#==============================================================================

class Game_Map
  
  #--------------------------------------------------------------------------
  # ● Váriaveis
  #--------------------------------------------------------------------------
      
  attr_accessor :abs_refresh
  attr_reader   :map_animations
  attr_reader   :item_events
  attr_reader   :shoot_events
  attr_reader   :sec_passed
  
  #--------------------------------------------------------------------------
  # ● Alias
  #--------------------------------------------------------------------------
      
  alias pr_abs_gmap_setup setup
  alias pr_abs_gmap_update update
  alias pr_abs_game_map_screen_events_xy screen_events_xy
  alias pr_abs_game_map_events_xy events_xy
  
  #--------------------------------------------------------------------------
  # ● Definição
  #--------------------------------------------------------------------------
      
  def setup(map_id)
    if @events != nil
      for event in @events.values
        event.unsetup(map_id)
      end
    end
    pr_abs_gmap_setup(map_id)
    @map_animations = []
    @item_events = []
    @shoot_events = []
    @abs_refresh = {}
    @refresh_map_animation = false
    @refresh_item_events = false
    @sec_passed = false
  end
  
  #--------------------------------------------------------------------------
  # ● Define as novas animações
  #--------------------------------------------------------------------------
      
  def setup_map_animation(animation_id, x, y, direction = 2, wait=0)
    return nil if $data_animations[animation_id].nil?
    animation = Map_Animation.new(x, y, animation_id, wait)
    if $data_animations[animation_id].name.include?("[turn]")
      case direction
      when 2
        animation.angle = 0
      when 4
        animation.angle = 270
      when 6
        animation.angle = 90
      when 8
        animation.angle = 180
      end
    end
    animation.mirror = false
    @map_animations.push(animation)
    $game_temp.abs_refresh_characters["animation"] = true
    return animation
  end
  
  #--------------------------------------------------------------------------
  # ● Atualiza as animações do Mapa
  #--------------------------------------------------------------------------
      
  def refresh_map_animations
    ids = []
    nc = false
    for i in 0...@map_animations.size
      if @map_animations[i].nil?
        nc = true
        next
      end
      if @map_animations[i].delete
        ids.push(i)
      end
    end
    for i in ids
      @map_animations[i] = nil
      nc = true
    end
    if nc
      @map_animations.compact!
    end
  end
  
  #--------------------------------------------------------------------------
  # ● Define as novas animações
  #--------------------------------------------------------------------------
      
  def setup_shoot_event(pre_map_id, pre_map_event_id, shooter, wait = 0)
    return nil if pre_map_event_id < 0
    return nil if pre_map_id < 0
    event = ABS_Event.new(@map_id, pre_map_id, pre_map_event_id)
    event.shooter = shooter
    event.set_direction(shooter.direction)
    front_x = $game_map.x_with_direction(shooter.x, shooter.direction)
    front_y = $game_map.y_with_direction(shooter.y, shooter.direction)
    if event.passable?(front_x, front_y)
      event.moveto(front_x, front_y)
    else
      event.moveto(shooter.x, shooter.y)
    end
    event.wait = wait
    @shoot_events.push(event)
    event.refresh
    $game_temp.abs_refresh_characters["shoot"] = true
    return event
  end
  
  #--------------------------------------------------------------------------
  # ● Atualiza as animações do Mapa
  #--------------------------------------------------------------------------
      
  def refresh_shoot_events
    ids = []
    nc = false
    for i in 0...@shoot_events.size
      if @shoot_events[i].nil?
        nc = true
        next
      end
      if @shoot_events[i].delete
        ids.push(i)
      end
    end
    for i in ids
      @shoot_events[i] = nil
      nc = true
    end
    if nc
      @shoot_events.compact!
    end
  end
    
  #--------------------------------------------------------------------------
  # ● Define os eventos dos items
  #--------------------------------------------------------------------------
      
  def setup_item_events(char)
    drop_items = []
    enemy = char.battler
    if PRCoders.logged_and_loaded?("ManyItems")
      items = enemy.drop_items
      items += [enemy.drop_item1, enemy.drop_item2]
    else
      items = [enemy.drop_item1, enemy.drop_item2]
    end
    for di in items
      next if di.kind == 0
      next if rand(di.denominator) != 0
      if di.kind == 1
        drop_items.push($data_items[di.item_id])
      elsif di.kind == 2
        drop_items.push($data_weapons[di.weapon_id])
      elsif di.kind == 3
        drop_items.push($data_armors[di.armor_id])
      end
    end
    ai = 1
    passable_places = []
    cb = false
    while (passable_places.size < drop_items.size)
      n = (ai - 1) / 2
      data = []
      for i in -n..n
        data.push(i)
      end
      data.sort! {|a, b|
        case rand(13)
        when 0...5
          ax = rand(a) - rand(b)
        when 5...10
          ax = rand(b) - rand(a)
        when 10
          ax = 1
        when 11
          ax = -1
        else
          ax = 0
        end
        ax
      }
      for x in data
        for y in data
          next if passable_places.include?([char.x + x, char.y + y])
          if $game_map.passable?(char.x + x, char.y + y)
            passable_places.push([char.x + x, char.y + y])
            if passable_places.size >= drop_items.size
              cb = true
              break
            end
          end
        end
        break if cb
      end
      ai += 2
    end
    for item in drop_items
      next if item.nil?
      item_char = Item_Event.new(item)
      item_char.moveto(char.x, char.y)
      add_x, add_y = passable_places.slice!(rand(passable_places.size))
      item_char.jump(add_x - char.x, add_y - char.y)
      @item_events.push(item_char)
      $game_temp.abs_refresh_characters["item"] = true
    end
  end
  
  #--------------------------------------------------------------------------
  # ● Atualiza as animações do Mapa
  #--------------------------------------------------------------------------
      
  def refresh_item_events
    ids = []
    nc = false
    for i in 0...@item_events.size
      if @item_events[i].nil?
        nc = true
        next
      end
      if @item_events[i].delete
        ids.push(i)
      end
    end
    for i in ids
      @item_events[i] = nil
      nc = true
    end
    if nc
      @item_events.compact!
    end
  end
  
  #--------------------------------------------------------------------------
  # ● Atualização
  #--------------------------------------------------------------------------
      
  def update
    update_abs_array(@map_animations, "map_animation")
    update_abs_array(@item_events, "item_events")
    update_abs_array(@shoot_events, "shoot_events")
    if @abs_refresh["map_animation"]
      @abs_refresh["map_animation"] = false
      refresh_map_animations
    end
    if @abs_refresh["item_events"]
      @abs_refresh["item_events"] = false
      refresh_item_events
    end
    if @abs_refresh["shoot_events"]
      @abs_refresh["shoot_events"] = false
      refresh_shoot_events
    end
    @sec_passed = ((Graphics.frame_count % Graphics.frame_rate) == 0)
    pr_abs_gmap_update
  end
  
  #--------------------------------------------------------------------------
  # ● Atualiza uma array
  #--------------------------------------------------------------------------
      
  def update_abs_array(array, key)
    for char in array
      next if char.nil?
      char.update
      if char.delete
        @abs_refresh[key] = true
      end
    end
  end
  
  #--------------------------------------------------------------------------
  # ● Pega os eventos
  #--------------------------------------------------------------------------
      
  def get_abs_events
    if PRCoders.logged_and_loaded?("AntiLag")
      return @screen_events
    end
    return @events
  end
  
  #--------------------------------------------------------------------------
  # ● 特定の方向に 1 マスずらした X 座標の計算
  #     x         : X 座標
  #     direction : 方向 (2,4,6,8)
  #--------------------------------------------------------------------------
  
  def x_with_direction(x, direction, n = 1)
    return round_x(x + (direction == 6 ? 1 : direction == 4 ? -1 : 0) * n)
  end
  
  #--------------------------------------------------------------------------
  # ● 特定の方向に 1 マスずらした Y 座標の計算
  #     y         : Y 座標
  #     direction : 方向 (2,4,6,8)
  #--------------------------------------------------------------------------
  
  def y_with_direction(y, direction, n = 1)
    return round_y(y + (direction == 2 ? 1 : direction == 8 ? -1 : 0) * n)
  end


  #--------------------------------------------------------------------------
  # Eventos na posição X e Y da tela
  #--------------------------------------------------------------------------
  
  def screen_events_xy(x, y, shoot_events_check = false)
    result = pr_abs_game_map_screen_events_xy(x, y)
    if shoot_events_check
      for event in @shoot_events
        result.push(event) if event.pos?(x, y) && event.pushable?
      end
    end
    return result
  end
  
  #--------------------------------------------------------------------------
  # Eventos na posição X e Y da tela
  #--------------------------------------------------------------------------
  
  def events_xy(x, y, shoot_events_check = false)
    result = pr_abs_game_map_events_xy(x, y)
    if shoot_events_check
      for event in @shoot_events
        result.push(event) if event.pos?(x, y) && event.pushable?
      end
    end
    return result
  end
  
  #--------------------------------------------------------------------------
  # ● Tile de água?
  #--------------------------------------------------------------------------
  
  def tile_waters?(tile_id)
    return false if (tile_id < 2048 || tile_id >= 2768)
    return true if tile_id >= 2048 && tile_id < 2096
    return true if tile_id >= 2240 && tile_id < 2288
    return true if tile_id >= 2336 && tile_id < 2384
    return true if tile_id >= 2432 && tile_id < 2480
    return true if tile_id >= 2528 && tile_id < 2576
    return true if tile_id >= 2624 && tile_id < 2672
    return true if tile_id >= 2720 && tile_id < 2768
    return false
  end
  
  #--------------------------------------------------------------------------
  # ● Passável?
  #--------------------------------------------------------------------------
  
  def shoot_passable?(x, y, flag = 0x01)
    for event in events_xy(x, y)            # 座標が一致するイベントを調べる
      next if event.tile_id == 0            # グラフィックがタイルではない
      next if event.priority_type > 0       # [通常キャラの下] ではない
      next if event.through                 # すり抜け状態
      pass = @passages[event.tile_id]       # 通行属性を取得
      next if pass & 0x10 == 0x10           # [☆] : 通行に影響しない
      return true if pass & flag == 0x00    # [○] : 通行可
      return false if pass & flag == flag   # [×] : 通行不可
    end
    for i in [2, 1, 0]                      # レイヤーの上から順に調べる
      tile_id = get_tile_id(x, y, i)
      return false if tile_id == nil        # タイル ID 取得失敗 : 通行不可
      return true if tile_waters?(tile_id)
      pass = @passages[tile_id]             # 通行属性を取得
      next if pass & 0x10 == 0x10           # [☆] : 通行に影響しない
      return true if pass & flag == 0x00    # [○] : 通行可
      return false if pass & flag == flag   # [×] : 通行不可
    end
    return false                            # 通行不可
  end

  def get_tile_id(x, y, z)
    return @map.data[x, y, z]               # タイル ID を取得
  end

end



class Game_Interpreter
  
  def reset_hit
    $game_self_switches[[@map_id, @event_id, "SHIT"]] = false
    $game_self_switches[[@map_id, @event_id, "WHIT"]] = false
    $game_self_switches[[@map_id, @event_id, "IHIT"]] = false
    $game_self_switches[[@map_id, @event_id, "SHIT_ID"]] = 0
    $game_self_switches[[@map_id, @event_id, "WHIT_ID"]] = 0
    $game_self_switches[[@map_id, @event_id, "IHIT_ID"]] = 0
    if @event_id > 0
      $game_map.events[@event_id].refresh
    end
  end

  def reset_balloon
    $game_map.events[@event_id].permanent_balloon_id = 0
  end
  
  def hit_weapon?(weapon_id)
    return ($game_self_switches.data[[@map_id, @event_id, "WHIT_ID"]] == weapon_id)
  end
  
  def hit_item?(item_id)
    return ($game_self_switches.data[[@map_id, @event_id, "IHIT_ID"]] == item_id)
  end
  
  def hit_skill?(skill_id)
    return ($game_self_switches.data[[@map_id, @event_id, "SHIT_ID"]] == skill_id)
  end
  
  def learn_sequence(name)
    $game_system.sequence_switches[name] = true
  end
  
  def forget_sequence(name)
    $game_system.sequence_switches[name] = false
  end
  
end


#==============================================================================
# Sprite_Character
#------------------------------------------------------------------------------
# Classe que gerencia os gráficos de personagens a serem exibidos.
# Esta classe está vinculada à classe Game_Character, que a monitora e
# automaticamente muda o status do sprite.
#==============================================================================

class Sprite_Character < Sprite_Base
  
  #--------------------------------------------------------------------------
  # ● Constantes
  #--------------------------------------------------------------------------
  
  WHITEN    = 1
  BLINK     = 2
  APPEAR    = 3
  DISAPPEAR = 4
  COLLAPSE  = 5
  
  #--------------------------------------------------------------------------
  # Alias
  #--------------------------------------------------------------------------
  
  alias pr_abs_sprite_character_initialize initialize
  alias pr_abs_sprite_character_update update 
  alias pr_abs_sprite_character_update_bitmap update_bitmap 
  alias pr_abs_sprite_character_update_src_rect update_src_rect
  
  #--------------------------------------------------------------------------
  # ● Inicialização
  #--------------------------------------------------------------------------
 
  def initialize(viewport, character = nil)
    @effect_type = 0
    @effect_duration = 0
    @force_refresh = false
    @cw = 0
    @ch = 0
    pr_abs_sprite_character_initialize(viewport, character)
    @need_base_update = false
  end
  
  #--------------------------------------------------------------------------
  # Atualização
  #--------------------------------------------------------------------------
  
  def update
    ids = []
    for i in 0...@pr_messages.size
      sprite = @pr_messages[i]
      next if sprite.nil?
      sprite.update
      if sprite.duration <= 0
        sprite.dispose
        ids.push(i)
      end
    end
    unless ids.size<= 0
      for i in ids
        @pr_messages[i] = nil
      end
      @pr_messages.compact!
    end
    pr_abs_sprite_character_update
    setup_new_effect
    update_effect
    self.visible = (!@character.transparent and !@character.dead?) if @effect_duration <= 0
  end

  #--------------------------------------------------------------------------
  # Atualização do bitmap
  #--------------------------------------------------------------------------
  
  def update_bitmap
    if @character.abs_animating?
      if @character.abs_animation.no_image
        return
      end
      if @character_name != @character.abs_animation.name
        @character_name = @character.abs_animation.name
        self.bitmap = Cache.character(@character_name)
        @cw = bitmap.width / @character.abs_animation.frames
        @ch = bitmap.height / 4
        self.ox = @cw / 2
        self.oy = @ch
      end
      return
    end
    if @tile_id != @character.tile_id or
       @character_name != @character.character_name or
       @character_index != @character.character_index
      @tile_id = @character.tile_id
      @character_name = @character.character_name
      @character_index = @character.character_index
      if @tile_id > 0
        sx = (@tile_id / 128 % 2 * 8 + @tile_id % 8) * 32;
        sy = @tile_id % 256 / 8 % 16 * 32;
        self.bitmap = tileset_bitmap(@tile_id)
        self.src_rect.set(sx, sy, 32, 32)
        self.ox = 16
        self.oy = 32
        @character.ch = 32
        @character.cw = 32
      else
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
        self.oy = @ch
        @character.cw = @cw
        @character.ch = @ch
      end
    end
  end
  
  #--------------------------------------------------------------------------
  # Atualização de bitmap retangular
  #--------------------------------------------------------------------------
  
  def update_src_rect
    if @character.abs_animating?
      if @character.abs_animation.no_image
        index = @character.character_index
        pattern = (@character.shielded ? (character.pattern < 3 ? @character.pattern : 1) : 0)
        sx = (index % 4 * 3 + pattern) * @cw
        sy = (index / 4 * 4 + (@character.direction - 2) / 2) * @ch
      else
        pattern = (@character.shielded ? (character.pattern < 3 ? @character.pattern : 1) : @character.abs_animation.index)
        sx = (@cw * pattern)
        sy = (@character.direction - 2) / 2 * @ch
      end
      self.src_rect.set(sx, sy, @cw, @ch)
      return
    end
    pr_abs_sprite_character_update_src_rect
  end
  
  #--------------------------------------------------------------------------
  # ● Define o novo efeito
  #--------------------------------------------------------------------------
 
  def setup_new_effect
    if @character.white_flash
      @effect_type = WHITEN
      @effect_duration = 16
      @character.white_flash = false
    end
    if @character.blink
      @effect_type = BLINK
      @effect_duration = 20
      @character.blink = false
    end
    if @character.collapse
      @effect_type = COLLAPSE
      @effect_duration = 48
      @character.collapse = false
    end
    if @character.appear
      @effect_type = APPEAR
      @effect_duration = 16
      @character.appear = false
    end
    if @character.clear_sprite
      self.blend_type = 0
      self.color.set(0, 0, 0, 0)
      @effect_duration = 0
      @effect_type = 0
      @character.clear_sprite = false
    end
  end
  
  #--------------------------------------------------------------------------
  # ● Atualiza o efeito
  #--------------------------------------------------------------------------
 
  def update_effect
    if @effect_duration > 0
      @effect_duration -= 1
      case @effect_type
      when WHITEN
        update_whiten
      when BLINK
        update_blink
      when APPEAR
        update_appear
      when DISAPPEAR
        update_disappear
      when COLLAPSE
        update_collapse
      end
    end
  end
  
  #--------------------------------------------------------------------------
  # ● Flash em branco
  #--------------------------------------------------------------------------
 
  def update_whiten
    self.blend_type = 0
    self.color.set(255, 255, 255, 128)
    self.opacity = 255
    self.color.alpha = 128 - (16 - @effect_duration) * 10
  end
  
  #--------------------------------------------------------------------------
  # ● Pisca
  #--------------------------------------------------------------------------
  
  def update_blink
    self.blend_type = 0
    self.color.set(0, 0, 0, 0)
    self.opacity = 255
    self.visible = (@effect_duration % 10 < 5)
  end
  
  #--------------------------------------------------------------------------
  # ● Aparece
  #--------------------------------------------------------------------------
  
  def update_appear
    self.blend_type = 0
    self.color.set(0, 0, 0, 0)
    self.opacity = (16 - @effect_duration) * 16
  end
  
  #--------------------------------------------------------------------------
  # ● Desaparece
  #--------------------------------------------------------------------------
  
  def update_disappear
    self.blend_type = 0
    self.color.set(0, 0, 0, 0)
    self.opacity = 256 - (32 - @effect_duration) * 10
  end
  
  #--------------------------------------------------------------------------
  # ● Colapso
  #--------------------------------------------------------------------------
  
  def update_collapse
    self.blend_type = 1
    self.color.set(255, 128, 128, 128)
    self.opacity = 256 - (48 - @effect_duration) * 6
  end
  
  
end

#==============================================================================
# ABS_Sprite_Animation 
#------------------------------------------------------------------------------
# Animação
#==============================================================================

class ABS_Sprite_Animation < Sprite_Base

  #--------------------------------------------------------------------------
  # ● inicialização
  #--------------------------------------------------------------------------
  
  def initialize(map_animation, viewport=nil)
    super(viewport)
    @map_animation = map_animation
    self.x = @map_animation.screen_x
    self.y = @map_animation.screen_y
    self.ox = 16
    self.oy = 16
    if @map_animation.animation_id != 0
      start_animation(@map_animation.animation, @map_animation.mirror, @map_animation.angle)
      @map_animation.animation_id = 0
    end
  end

  #--------------------------------------------------------------------------
  # ● Atualização
  #--------------------------------------------------------------------------
  
  def update
    return if self.disposed?
    if @map_animation.animation_id != 0
      start_animation(@map_animation.animation, @map_animation.mirror, @map_animation.angle)
      @map_animation.animation_id = 0
    end
    super()
    self.x = @map_animation.screen_x
    self.y = @map_animation.screen_y
    unless animation?
      @map_animation.delete = true
      self.dispose
    end      
  end

  #--------------------------------------------------------------------------
  # ● Deleta a animação
  #--------------------------------------------------------------------------
  
  def dispose_animation
    @animation_angle = 0
    if @animation_bitmap1 != nil
      @@_reference_count[@animation_bitmap1] -= 1
      if @@_reference_count[@animation_bitmap1] == 0
        @animation_bitmap1.dispose
      end
    end
    if @animation_bitmap2 != nil
      @@_reference_count[@animation_bitmap2] -= 1
      if @@_reference_count[@animation_bitmap2] == 0
        @animation_bitmap2.dispose
      end
    end
    if @animation_sprites != nil
      for sprite in @animation_sprites
        sprite.dispose
      end
      @animation_sprites = nil
      @animation = nil
    end
    @animation_bitmap2 = nil
    @animation_bitmap1 = nil
  end

  #--------------------------------------------------------------------------
  # ● アニメーションの開始
  #--------------------------------------------------------------------------
  
  def start_animation(animation, mirror = false, angle=0)
    dispose_animation
    @animation_angle = angle
    @animation = animation
    return if @animation == nil
    @animation_mirror = mirror
    @animation_duration = @animation.frame_max * 4 + 1
    load_animation_bitmap
    @animation_sprites = []
    if @animation.position != 3 or not @@animations.include?(animation)
      if @use_sprite
        for i in 0..15
          sprite = ::Sprite.new(viewport)
          sprite.visible = false
          sprite.angle = @animation_angle
          @animation_sprites.push(sprite)
        end
        unless @@animations.include?(animation)
          @@animations.push(animation)
        end
      end
    end
    if @animation.position == 3
      if viewport == nil
        @animation_ox = 544 / 2
        @animation_oy = 416 / 2
      else
        @animation_ox = viewport.rect.width / 2
        @animation_oy = viewport.rect.height / 2
      end
    else
      @animation_ox = x - ox + width / 2
      @animation_oy = y - oy + height / 2
      if @animation.position == 0
        @animation_oy -= height / 2
      elsif @animation.position == 2
        @animation_oy += height / 2
      end
    end
  end
  
  #--------------------------------------------------------------------------
  # ● アニメーションスプライトの設定
  #     frame : フレームデータ (RPG::Animation::Frame)
  #--------------------------------------------------------------------------
  
  def animation_set_sprites(frame)
    cell_data = frame.cell_data
    if @animation.position != 3
      @animation_ox = self.x - self.ox + self.width / 2
      @animation_oy = self.y - self.oy + self.height / 2
      if @animation.position == 0
        @animation_oy -= height / 2
      elsif @animation.position == 2
        @animation_oy += height / 2
      end
    end
    for i in 0..15
      sprite = @animation_sprites[i]
      next if sprite == nil
      pattern = cell_data[i, 0]
      if pattern == nil or pattern == -1
        sprite.visible = false
        next
      end
      if pattern < 100
        sprite.bitmap = @animation_bitmap1
      else
        sprite.bitmap = @animation_bitmap2
      end
      sprite.visible = true
      sprite.src_rect.set(pattern % 5 * 192,
        pattern % 100 / 5 * 192, 192, 192)
      if @animation_mirror
        sprite.x = @animation_ox - cell_data[i, 1]
        sprite.y = @animation_oy - cell_data[i, 2]
        sprite.angle = (360 - cell_data[i, 4]) + @animation_angle
        sprite.mirror = (cell_data[i, 5] == 0)
      else
        sprite.x = @animation_ox + cell_data[i, 1]
        sprite.y = @animation_oy + cell_data[i, 2]
        sprite.angle = cell_data[i, 4] + @animation_angle
        sprite.mirror = (cell_data[i, 5] == 1)
      end
      sprite.z = self.z + 300
      sprite.ox = 96
      sprite.oy = 96
      sprite.zoom_x = cell_data[i, 3] / 100.0
      sprite.zoom_y = cell_data[i, 3] / 100.0
      sprite.opacity = cell_data[i, 6] * self.opacity / 255.0
      sprite.blend_type = cell_data[i, 7]
    end
  end
  
end
#==============================================================================
# ■ Sprite_Character
#------------------------------------------------------------------------------
# 　Classe do evento atirável
#==============================================================================

class Sprite_Character_Shoot < Sprite_Base
  #--------------------------------------------------------------------------
  # ● 定数
  #--------------------------------------------------------------------------
  BALLOON_WAIT = 12                  # フキダシ最終フレームのウェイト時間
  
  #--------------------------------------------------------------------------
  # ● 公開インスタンス変数
  #--------------------------------------------------------------------------
  
  attr_accessor :character
  
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #     viewport  : ビューポート
  #     character : キャラクター (Game_Character)
  #--------------------------------------------------------------------------
  
  def initialize(viewport, character = nil)
    super(viewport)
    @character = character
    @balloon_duration = 0
    update
  end
  
  #--------------------------------------------------------------------------
  # ● 解放
  #--------------------------------------------------------------------------

  def dispose
    dispose_balloon
    super
  end
  
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  
  def update
    return if self.disposed?
    if @character.nil?
      self.dispose
      return
    end
    if @character.delete
      self.dispose
      return
    end
    super
    update_bitmap
    self.visible = (!@character.transparent && (@character.wait <= 0))
    update_src_rect
    self.x = @character.screen_x
    self.y = @character.screen_y
    self.z = @character.screen_z
    self.opacity = @character.opacity
    self.blend_type = @character.blend_type
    self.bush_depth = @character.bush_depth
    update_balloon
    if @character.animation_id != 0
      animation = $data_animations[@character.animation_id]
      start_animation(animation)
      @character.animation_id = 0
    end
    if @character.balloon_id != 0
      @balloon_id = @character.balloon_id
      start_balloon
      @character.balloon_id = 0
    end
  end
  
  #--------------------------------------------------------------------------
  # ● 指定されたタイルが含まれるタイルセット画像の取得
  #     tile_id : タイル ID
  #--------------------------------------------------------------------------
 
  def tileset_bitmap(tile_id)
    set_number = tile_id / 256
    return Cache.system("TileB") if set_number == 0
    return Cache.system("TileC") if set_number == 1
    return Cache.system("TileD") if set_number == 2
    return Cache.system("TileE") if set_number == 3
    return nil
  end
  
  #--------------------------------------------------------------------------
  # ● 転送元ビットマップの更新
  #--------------------------------------------------------------------------
 
  def update_bitmap
    if @tile_id != @character.tile_id or
       @character_name != @character.character_name or
       @character_index != @character.character_index
      @tile_id = @character.tile_id
      @character_name = @character.character_name
      @character_index = @character.character_index
      if @tile_id > 0
        sx = (@tile_id / 128 % 2 * 8 + @tile_id % 8) * 32;
        sy = @tile_id % 256 / 8 % 16 * 32;
        self.bitmap = tileset_bitmap(@tile_id)
        self.src_rect.set(sx, sy, 32, 32)
        self.ox = 16
        self.oy = 32
        @character.ch = 32
        @character.cw = 32
      else
        self.bitmap = Cache.character(@character_name)
        sign = @character_name[/^[\!\$]./]
        if sign != nil and sign.include?('$')
          @cw = bitmap.width / 3
          @ch = bitmap.height / 4
        else
          @cw = bitmap.width / 12
          @ch = bitmap.height / 8
        end
        @character.ch = @ch
        @character.cw = @cw
        self.ox = @cw / 2
        self.oy = @ch
      end
    end
  end
  
  #--------------------------------------------------------------------------
  # ● 転送元矩形の更新
  #--------------------------------------------------------------------------
  
  def update_src_rect
    if @tile_id == 0
      index = @character.character_index
      pattern = @character.pattern < 3 ? @character.pattern : 1
      sx = (index % 4 * 3 + pattern) * @cw
      sy = (index / 4 * 4 + (@character.direction - 2) / 2) * @ch
      self.src_rect.set(sx, sy, @cw, @ch)
    end
  end
  
  #--------------------------------------------------------------------------
  # ● フキダシアイコン表示の開始
  #--------------------------------------------------------------------------
 
  def start_balloon
    dispose_balloon
    @balloon_duration = 8 * 8 + BALLOON_WAIT
    @balloon_sprite = ::Sprite.new(viewport)
    @balloon_sprite.bitmap = Cache.system("Balloon")
    @balloon_sprite.ox = 16
    @balloon_sprite.oy = 32
    update_balloon
  end
  
  #--------------------------------------------------------------------------
  # ● フキダシアイコンの更新
  #--------------------------------------------------------------------------
 
  def update_balloon
    if @balloon_duration > 0
      @balloon_duration -= 1
      if @balloon_duration == 0
        dispose_balloon
      else
        @balloon_sprite.x = x
        @balloon_sprite.y = y - height
        @balloon_sprite.z = z + 200
        if @balloon_duration < BALLOON_WAIT
          sx = 7 * 32
        else
          sx = (7 - (@balloon_duration - BALLOON_WAIT) / 8) * 32
        end
        sy = (@balloon_id - 1) * 32
        @balloon_sprite.src_rect.set(sx, sy, 32, 32)
      end
    end
  end
  
  #--------------------------------------------------------------------------
  # ● フキダシアイコンの解放
  #--------------------------------------------------------------------------
 
  def dispose_balloon
    if @balloon_sprite != nil
      @balloon_sprite.dispose
      @balloon_sprite = nil
    end
  end
  
end

#==============================================================================
# Sprite_Item_Event
#------------------------------------------------------------------------------
# Sprite do ícone
#==============================================================================

class Sprite_Item_Event < Sprite_Base
  
  def initialize(viewport, item_event)
    super(viewport)
    @item_event = item_event
    self.bitmap = Cache.system("IconSet")
    self.ox = 12
    self.oy = 24
    update
  end
  
  def update
    return if self.disposed?
    if @item_event.nil?
      self.dispose
      return
    end
    if @item_event.delete
      self.dispose
      return
    end
    super()
    self.x = @item_event.screen_x
    self.y = @item_event.screen_y
    self.z = @item_event.screen_z - 1
    self.opacity = @item_event.opacity
    update_item_event
  end
  
  def update_item_event
    if @icon_index != @item_event.icon_index
      @icon_index = @item_event.icon_index
      self.src_rect.set(@icon_index % 16 * 24, @icon_index / 16 * 24, 24, 24)
    end
  end
  
end
#==============================================================================
# ■ Spriteset_Map
#==============================================================================

class Spriteset_Map
    
  #--------------------------------------------------------------------------
  # ● Alias
  #--------------------------------------------------------------------------
      
  alias pr_abs_spriteset_map_create_pictures create_pictures
  alias pr_abs_spriteset_map_dispose dispose
  alias pr_abs_spriteset_map_update update
  
  def create_pictures
    create_abs_animation_characters
    create_abs_shoot_characters
    create_item_sprites
    pr_abs_spriteset_map_create_pictures
  end

  #--------------------------------------------------------------------------
  # ● Dispose
  #--------------------------------------------------------------------------
 
  def dispose
    pr_abs_spriteset_map_dispose
    dispose_abs_animation_characters
    dispose_abs_shoot_characters
    dispose_item_sprites
  end
  
  #--------------------------------------------------------------------------
  # ● Cria as animações
  #--------------------------------------------------------------------------
  
  def create_abs_animation_characters
    @map_animations = []
    for character in $game_map.map_animations
      character.created = true
      @map_animations.push(ABS_Sprite_Animation.new(character, @viewport1))
    end
  end
  
  #--------------------------------------------------------------------------
  # ● Cria as animações
  #--------------------------------------------------------------------------
  
  def refresh_abs_animation_characters
    for character in $game_map.map_animations
      next if character.nil?
      next if character.created
      character.created = true
      @map_animations.push(ABS_Sprite_Animation.new(character, @viewport1))
    end
  end
  
  #--------------------------------------------------------------------------
  # ● Atualiza as Animações
  #--------------------------------------------------------------------------
  
  def update_abs_animation_characters
    if $game_temp.abs_refresh_characters["animation"]
      refresh_abs_animation_characters
      $game_temp.abs_refresh_characters["animation"] = false
    end
    ids = []
    nc = false
    for i in 0...@map_animations.size
      if @map_animations[i].nil?
        nc = true
        next
      end
      @map_animations[i].update
      if @map_animations[i].disposed?
        ids.push(i)
      end
    end
    for i in ids
      @map_animations[i] = nil
      nc = true
    end
    if nc
      @map_animations.compact!
    end
  end
  
  #--------------------------------------------------------------------------
  # ● Deleta as Animações
  #--------------------------------------------------------------------------
  
  def dispose_abs_animation_characters
    for sprite in @map_animations
      sprite.dispose
    end
  end
  
  #--------------------------------------------------------------------------
  # ● Cria os eventos atiráveis
  #--------------------------------------------------------------------------
  
  def create_abs_shoot_characters
    @shoot_events = []
    for character in $game_map.shoot_events
      character.created = true
      @shoot_events.push(Sprite_Character_Shoot.new(@viewport1, character))
    end
  end
  
  #--------------------------------------------------------------------------
  # ● Cria os eventos atiráveis
  #--------------------------------------------------------------------------
  
  def refresh_abs_shoot_characters
    for character in $game_map.shoot_events
      next if character.nil?
      next if character.created
      character.created = true
      @shoot_events.push(Sprite_Character_Shoot.new(@viewport1, character))
    end
  end
  
  #--------------------------------------------------------------------------
  # ● Atualiza  os eventos atiráveis
  #--------------------------------------------------------------------------
  
  def update_abs_shoot_characters
    if $game_temp.abs_refresh_characters["shoot"]
      refresh_abs_shoot_characters
      $game_temp.abs_refresh_characters["shoot"] = false
    end
    ids = []
    nc = false
    for i in 0...@shoot_events.size
      if @shoot_events[i].nil?
        nc = true
        next
      end
      @shoot_events[i].update
      if @shoot_events[i].disposed?
        ids.push(i)
      end
    end
    for i in ids
      @shoot_events[i] = nil
      nc = true
    end
    if nc
      @shoot_events.compact!
    end
  end
  
  #--------------------------------------------------------------------------
  # ● Deleta  os eventos atiráveis
  #--------------------------------------------------------------------------
  
  def dispose_abs_shoot_characters
    for sprite in @shoot_events
      sprite.dispose
    end
  end
  
  #--------------------------------------------------------------------------
  # ● Cria os sprites de Item
  #--------------------------------------------------------------------------
  
  def create_item_sprites
    @item_sprites = []
    for item_char in $game_map.item_events
      item_char.created = true
      @item_sprites.push(Sprite_Item_Event.new(@viewport1, item_char))
    end
  end
  
  #--------------------------------------------------------------------------
  # ● Deleta os 
  #--------------------------------------------------------------------------
  
  def refresh_item_sprites
    for item_char in $game_map.item_events
      next if item_char.nil?
      next if item_char.created
      item_char.created = true
      @item_sprites.push(Sprite_Item_Event.new(@viewport1, item_char))
    end
  end
  
  #--------------------------------------------------------------------------
  # ● Deleta as Animações
  #--------------------------------------------------------------------------
  
  def dispose_item_sprites
    for sprite in @item_sprites
      sprite.dispose
    end
  end
  
  #--------------------------------------------------------------------------
  # ● Atualiza as Animações
  #--------------------------------------------------------------------------
  
  def update_item_sprites
    if $game_temp.abs_refresh_characters["item"]
      refresh_item_sprites
      $game_temp.abs_refresh_characters["item"] = false
    end
    ids = []
    nc = false
    for i in 0...@item_sprites.size
      if @item_sprites[i].nil?
        nc = true
        next
      end
      @item_sprites[i].update
      if @item_sprites[i].disposed?
        ids.push(i)
      end
    end
    for i in ids
      @item_sprites[i] = nil
      nc = true
    end
    if nc
      @item_sprites.compact!
    end
  end

  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  
  def update
    pr_abs_spriteset_map_update
    update_abs_animation_characters
    update_item_sprites
    update_abs_shoot_characters
  end

end
#==============================================================================
# ■ Scene_Map
#==============================================================================

class Scene_Map < Scene_Base
  
  alias prabs_scmap_update_scene_change update_scene_change
  
  def update_scene_change
    return if ($game_party.abs_all_dead? && $game_temp.next_scene != "gameover")
    prabs_scmap_update_scene_change
  end

end

end
