################################################################################
########################  PR - Damage_System  ##################################
################################################################################
#
# WARNING!!!!
# Texts here are not valid, check in 
# Config - Texts 

#==============================================================================
# Adiciona o sistema de Dano
#==============================================================================
  script_name = "Damage_System"
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

module PR_DAMAGE
  
  # Classe Padrão da Mensagem
  # Há 2 tipos de danos:
  # - FF_Sprite_Damage
  # - PR_Sprite_Message_Default
  DEFAULT_MESSAGE = "PR_Sprite_Message_Default"
  
  # Classe Padrão do Dano
  # Há 2 tipos de danos:
  # - FF_Sprite_Damage
  # - PR_Sprite_Message_Default
  DEFAULT_DAMAGE = "PR_Sprite_Message_Default"
  
  # Classe Padrão do Dano de MP
  # Há 2 tipos de danos:
  # - FF_Sprite_Damage
  # - PR_Sprite_Message_Default
  DEFAULT_MP_DAMAGE = "PR_Sprite_Message_Default"
  
  # Dano Normal
  DAMAGE_COLOR = Color.new(255, 255, 255)
  # Dano de Cura
  DAMAGE_HEAL_COLOR = Color.new(176, 255, 144)
  # Dano Crítico
  DAMAGE_CRITICAL_COLOR = Color.new(255, 255, 255)
  
  # Dano de MP
  MP_DAMAGE_COLOR = Color.new(255, 255, 255)
  # Dano de MP (Cura)
  MP_DAMAGE_HEAL_COLOR = Color.new(176, 255, 144)
  # Dano de MP (Crítico)
  MP_DAMAGE_CRITICAL_COLOR = Color.new(255, 255, 255)
  
  # Texto crítico
  CRITICAL_TEXT = "Crítico"
  # Cor do Crítico
  CRITICAL_TEXT_COLOR = Color.new(170, 0, 0)
  
  def self.get_hp_damage(sprite, value, critical=false, duration=0)
    if value < 0
      text = PR_DAMAGE::HP_HEAL_TEXT.dup
      color1 = color2 = PR_DAMAGE::DAMAGE_HEAL_COLOR
    elsif critical
      text = PR_DAMAGE::HP_CRITICAL_TEXT.dup
      color1 = PR_DAMAGE::DAMAGE_CRITICAL_COLOR
      color2 = PR_DAMAGE::CRITICAL_TEXT_COLOR
    else
      text = PR_DAMAGE::HP_TEXT.dup
      color1 = color2 = PR_DAMAGE::DAMAGE_COLOR
    end    
    text.gsub!("[#VALOR]", value.abs.to_s)
    text.gsub!("[#HP]", Vocab.hp)
    sprite.setup_text(1, text, color1)
    if critical and value.abs > 0
      sprite.setup_text(0, PR_DAMAGE::CRITICAL_TEXT, color2)
    end
    sprite.setup_duration(duration)
  end
  
  def self.get_mp_damage(sprite, value, critical=false, duration=0)
    if value < 0
      text = PR_DAMAGE::MP_HEAL_TEXT.dup
      color1 = color2 = PR_DAMAGE::MP_DAMAGE_HEAL_COLOR
    elsif critical
      text = PR_DAMAGE::MP_CRITICAL_TEXT.dup
      color1 = PR_DAMAGE::MP_DAMAGE_CRITICAL_COLOR
      color2 = PR_DAMAGE::MP_CRITICAL_TEXT_COLOR
    else
      text = PR_DAMAGE::MP_TEXT.dup
      color1 = color2 = PR_DAMAGE::MP_DAMAGE_COLOR
    end      
    text.gsub!("[#VALOR]", value.abs.to_s)
    text.gsub!("[#MP]", Vocab.mp)
    sprite.setup_text(1, text, color1)
    if critical and value.abs > 0
      sprite.setup_text(0, PR_DAMAGE::MP_CRITICAL_TEXT, color2)
    end
    sprite.setup_duration(duration)
  end
  
end

#==============================================================================
# Sprite_Base
#==============================================================================

class Sprite_Base < Sprite

  #--------------------------------------------------------------------------
  # ● Alias
  #--------------------------------------------------------------------------
  
  alias pr_damage_system_sprite_base_initialize initialize
  alias pr_damage_system_sprite_base_dispose dispose
  alias pr_damage_system_sprite_base_update update
  
  #--------------------------------------------------------------------------
  # ● Inicialização
  #--------------------------------------------------------------------------
 
  def initialize(viewport = nil)
    @need_base_update = true
    pr_damage_system_sprite_base_initialize(viewport)
    @pr_messages = []
  end
  
  #--------------------------------------------------------------------------
  # ● Dispose
  #--------------------------------------------------------------------------
  
  def dispose
    pr_damage_system_sprite_base_dispose
    for sprite in @pr_messages
      next if sprite.nil?
      sprite.dispose
    end
  end
  
  #--------------------------------------------------------------------------
  # ● Atualização
  #--------------------------------------------------------------------------
  
  def update
    if @need_base_update
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
    end
    pr_damage_system_sprite_base_update
  end 
  
  #--------------------------------------------------------------------------
  # ● Mensagem
  #--------------------------------------------------------------------------
    
  def message(texts, duration=60, call=PR_DAMAGE::DEFAULT_MESSAGE)
    sprite = eval(call + ".new(nil, self.viewport)")
    for t in 0...texts.size
      text1 = texts[t]
      next if text1.nil?
      sprite.setup_text(t, text1[0], text1[1], text1[2])
    end
    sprite.setup_duration(duration)
    sprite.x = self.x
    sprite.y = self.y
    sprite.z = 3000
    sprite.refresh
    @pr_messages.push(sprite)
  end    
  
  #--------------------------------------------------------------------------
  # ● Dano
  #--------------------------------------------------------------------------
    
  def damage(value, critical=false, duration=60, call=PR_DAMAGE::DEFAULT_DAMAGE)
    sprite = eval(call + ".new(nil, self.viewport)")
    PR_DAMAGE.get_hp_damage_s(sprite, value, critical, duration)
    sprite.x = self.x
    sprite.y = self.y
    sprite.z = 3000
    sprite.refresh
    @pr_messages.push(sprite)
  end    
  
  #--------------------------------------------------------------------------
  # ● Dano
  #--------------------------------------------------------------------------
    
  def mp_damage(value, critical=false, duration=60, call=PR_DAMAGE::DEFAULT_MP_DAMAGE, follow = false)
    sprite = eval(call + ".new(nil, self.viewport)")
    PR_DAMAGE.get_mp_damage(sprite, value, critical, duration)
    sprite.x = self.x
    sprite.y = self.y
    sprite.z = 3000
    sprite.follow = follow
    sprite.refresh
    @pr_messages.push(sprite)
  end  

end

#==============================================================================
# Game_Character
#==============================================================================

class Game_Character
  
  #--------------------------------------------------------------------------
  # ● Váriáveis Globais
  #--------------------------------------------------------------------------
      
  attr_accessor :damages
  attr_accessor :mp_damages
  attr_accessor :messages
  
  #--------------------------------------------------------------------------
  # ● Alias
  #--------------------------------------------------------------------------
      
  alias pr_damage_system_game_character_initialize initialize
  
  #--------------------------------------------------------------------------
  # ● Inicialização
  #--------------------------------------------------------------------------
      
  def initialize
    @damages = []
    @mp_damages = []
    @messages = []
    pr_damage_system_game_character_initialize
  end
  
  #--------------------------------------------------------------------------
  # ● Dano
  #--------------------------------------------------------------------------
      
  def set_damage(value, critical=false, wait=0, damage_scene=nil)
    @damages.push([value, critical, wait, damage_scene])
  end
  
  #--------------------------------------------------------------------------
  # ● Dano
  #--------------------------------------------------------------------------
      
  def set_mp_damage(value, critical=false, wait=0, damage_scene=nil)
    @mp_damages.push([value, critical, wait, damage_scene])
  end
  
  #--------------------------------------------------------------------------
  # ● Mensagem
  #--------------------------------------------------------------------------
      
  def set_message(message, wait=0, color=Color.new(255, 255, 255), font=nil, call_scene=nil, arguments = [], follow = false)
    texts = []
    for line in message.split("\n")
      line_text = [line, color, font]
      texts.push(line_text)
    end
    @messages.push([texts, wait, call_scene, arguments, follow])
  end
  
end

#==============================================================================
# Sprite_Character
#==============================================================================

class Sprite_Character < Sprite_Base
  
  #--------------------------------------------------------------------------
  # ● Alias
  #--------------------------------------------------------------------------
      
  alias pr_damage_system_sprite_character_update update
  
  #--------------------------------------------------------------------------
  # ● Atualização
  #--------------------------------------------------------------------------
  
  def update
    update_damage
    pr_damage_system_sprite_character_update
  end
  
  #--------------------------------------------------------------------------
  # ● Atualização do Dano
  #--------------------------------------------------------------------------
    
  def update_damage
    unless @character.nil?
      if @character.damages.size > 0
        for damage in @character.damages
          duration = 60 + damage[2]
          call_scene = damage[3]
          if call_scene != nil
            self.damage(damage[0], damage[1], duration, call_scene)
          else
            self.damage(damage[0], damage[1], duration)
          end
        end
        @character.damages.clear
      end
      if @character.mp_damages.size > 0
        for damage in @character.mp_damages
          duration = 60 + damage[2]
          call_scene = damage[3]
          if call_scene != nil
            self.mp_damage(damage[0], damage[1], duration, call_scene)
          else
            self.mp_damage(damage[0], damage[1], duration)
          end
        end
        @character.mp_damages.clear
      end
      if @character.messages.size > 0
        for i in 0...@character.messages.size
          message = @character.messages[i]
          next if message.nil?
          duration = 60 + message[1]
          if message[2] != nil
            self.message(message[0], duration, message[2], message[3], message[4])
          else
            self.message(message[0], duration)
          end
        end
        @character.messages.clear
      end
    end
  end
  
  #--------------------------------------------------------------------------
  # ● Mensagem
  #--------------------------------------------------------------------------
    
  def message(texts, duration=60, call=PR_DAMAGE::DEFAULT_MESSAGE, arguments = [], follow = false)
    sprite = eval(call + ".new(@character, self.viewport, arguments)")
    for t in 0...texts.size
      text1 = texts[t]
      next if text1.nil?
      sprite.setup_text(t, text1[0], text1[1], text1[2])
    end
    sprite.setup_duration(duration)
    sprite.x = self.x
    sprite.y = self.y
    sprite.follow = follow
    sprite.z = 3000
    sprite.refresh
    @pr_messages.push(sprite)
  end    
  
  #--------------------------------------------------------------------------
  # ● Dano
  #--------------------------------------------------------------------------
    
  def damage(value, critical=false, duration=60, call=PR_DAMAGE::DEFAULT_DAMAGE)
    sprite = eval(call + ".new(@character, self.viewport)")
    PR_DAMAGE.get_hp_damage(sprite, value, critical, duration)
    sprite.x = self.x
    sprite.y = self.y
    sprite.z = 3000
    sprite.refresh
    @pr_messages.push(sprite)
  end    
  
  #--------------------------------------------------------------------------
  # ● Dano
  #--------------------------------------------------------------------------
    
  def mp_damage(value, critical=false, duration=60, call=PR_DAMAGE::DEFAULT_MP_DAMAGE)
    sprite = eval(call + ".new(@character, self.viewport)")
    PR_DAMAGE.get_mp_damage(sprite, value, critical, duration)
    sprite.x = self.x
    sprite.y = self.y
    sprite.z = 3000
    sprite.refresh
    @pr_messages.push(sprite)
  end    

end

#==============================================================================
# PR_Sprite_Message_Default
#==============================================================================

class PR_Sprite_Message_Default < Sprite
  
  @@bitmap_size = Bitmap.new(32, 32)
  
  #--------------------------------------------------------------------------
  # - Váriáveis Globais
  #--------------------------------------------------------------------------
  
  attr_reader :duration
  attr_accessor :follow
  
  #--------------------------------------------------------------------------
  # - Inicia
  #--------------------------------------------------------------------------
  
  def initialize(char=nil, viewport=nil, arguments=[])
    super(viewport)
    @char = char
    if @char != nil
      @original_x = @char.real_x
      @original_y = @char.real_y
      if $scene.instance_of?(Scene_Map)
        @on_map = true
      end
    end 
    @black = Color.new(0, 0, 0)
    @duration = 0
    @add_y = 0
    @add_x = 0 
    @follow = false
    clear(false)
  end
  
  #--------------------------------------------------------------------------
  # - Dispose
  #--------------------------------------------------------------------------
  
  def dispose
    self.bitmap.dispose unless self.bitmap.nil?
    super()
  end
  
  #--------------------------------------------------------------------------
  # - Define a duração
  #--------------------------------------------------------------------------
  
  def setup_duration(duration)
    @duration = duration
    @original_duration = 60
    if @duration > 60
      self.visible = false
    end
  end
  
  #--------------------------------------------------------------------------
  # - Limpa
  #--------------------------------------------------------------------------
  
  def clear(need_refresh=true)
    @texts = []
    @height = 0
    @width = 0
    refresh if need_refresh
  end
  
  #--------------------------------------------------------------------------
  # - Dá um Setup nos textos
  #--------------------------------------------------------------------------
  
  def setup_text(id, text, color, font=nil)
    @texts[id] = [text, color, font]
    if font.nil?
      @@bitmap_size.font = Font.new
    else
      @@bitmap_size.font = font
    end
    regexp_hex = /[0123456789ABCDEFabcdef]/
    texto = text.gsub(/\[[Cc][Oo][Ll][Oo][Rr][ ]?=[ ]?#(#{regexp_hex}#{regexp_hex}#{regexp_hex}#{regexp_hex}#{regexp_hex}#{regexp_hex}#{regexp_hex}?#{regexp_hex}?)\]/) { "" }
    texto.gsub!(/\[\\[Cc][Oo][Ll][Oo][Rr]/) { "" }
    @size_texto = texto
    rect = @@bitmap_size.text_size(texto)
    @height += rect.height + 4
    @width = [rect.width + 16, @width].max
  end
  
  #--------------------------------------------------------------------------
  # - Atualiza
  #--------------------------------------------------------------------------
  
  def refresh
    unless self.bitmap.nil?
      self.bitmap.dispose 
      self.bitmap = nil
    end
    return if @height == 0
    self.bitmap = Bitmap.new(@width, @height)
    self.ox = (@width / 2)
    self.oy = (@height / 2)
    i = 0
    for text in @texts
      next if text.nil?
      i += draw_text(i, text)
    end
  end
  
  #--------------------------------------------------------------------------
  # - Desenha os textos
  #--------------------------------------------------------------------------
  
  def draw_text(y, text)
    texto = text[0].dup
    original_color = text[1]
    font = text[2]
    if font.nil?
      self.bitmap.font = Font.new
      @@bitmap_size.font = Font.new
    else
      self.bitmap.font = font
      @@bitmap_size.font = font
    end
    ah = (@@bitmap_size.text_size(texto).height + 4)
    ax = 0
    regexp_hex = /[0123456789ABCDEFabcdef]/
    texto.gsub!(/\[[Cc][Oo][Ll][Oo][Rr][ ]?=[ ]?#(#{regexp_hex}#{regexp_hex}#{regexp_hex}#{regexp_hex}#{regexp_hex}#{regexp_hex}#{regexp_hex}?#{regexp_hex}?)\]/) { "\x01[##{$1}]" }
    texto.gsub!(/\[\\[Cc][Oo][Ll][Oo][Rr]/) { "\x02" }
    size = self.bitmap.text_size(@size_texto).width
    color = original_color
    while ((c = texto.slice!(/./m)) != nil)
      case c
      when "\x01"
        texto.sub!(/\[#(#{regexp_hex}#{regexp_hex})(#{regexp_hex}#{regexp_hex})(#{regexp_hex}#{regexp_hex})(#{regexp_hex}#{regexp_hex})?\]/, "")
        r = $1.hex
        g = $2.hex
        b = $3.hex
        a = ($4.nil? ? 255 : $4.hex)
        color = Color.new(r, g, b, a)
        next
      when "\x02"
        color = original_color
        next
      end
      dx = ((self.bitmap.width - 2) / 2) - (size / 2) + ax
      self.bitmap.font.color = @black
      self.bitmap.draw_text(dx, y, self.bitmap.width - 2, ah - 2, c)
      self.bitmap.draw_text(dx + 2, y, self.bitmap.width - 2, ah - 2, c)
      self.bitmap.draw_text(dx, y + 2, self.bitmap.width - 2, ah - 2, c)
      self.bitmap.draw_text(dx + 2, y + 2, self.bitmap.width - 2, ah - 2, c)
      self.bitmap.font.color = color
      self.bitmap.draw_text(dx + 1, y + 1, self.bitmap.width - 2, ah - 2, c)
      ax += self.bitmap.text_size(c).width
    end
    return ah
  end
  
  #--------------------------------------------------------------------------
  # - Atualização do Frame
  #--------------------------------------------------------------------------
  
  def update
    return if self.disposed?
    if @duration > 60
      @duration -= 1
      self.visible = false
      return
    end
    self.visible = true
    if @duration > 0
      @duration -= 1
      self.opacity = @duration * (255.0 / (@original_duration.to_f - 20.0))
      if @on_map
        update_char
        return
      end
      @add_y = 0
      @add_x = 0 
      update_adds
      self.x += @add_x
      self.y += @add_y
    end
  end
  
  #--------------------------------------------------------------------------
  # - Atualização da Posição
  #--------------------------------------------------------------------------
  
  def update_adds
    case (60 - @duration)
    when 1..7
      @add_y -= 8
    when 8..11
      @add_y -= 4
    when 12..14
      @add_y -= 2
    when 15..17
      @add_y -= 1
    when 18..20
      @add_y += 1
    when 21..25
      @add_y += 2
    when 26..32
      @add_y += 4
    else
      @add_y += 6
    end
    @add_x -= 1 if @duration % 2 == 0
  end
    
  #--------------------------------------------------------------------------
  # - Atualização do Char
  #--------------------------------------------------------------------------
  
  def update_char
    update_adds
    ax = ($game_map.adjust_x(@original_x) + 8007) / 8 - 1000 + 16
    ay = ($game_map.adjust_y(@original_y) + 8007) / 8 - 1000 + 32
    self.x = ax + @add_x
    self.y = ay + @add_y
  end
  
end
#==============================================================================
# FF_Sprite_Damage
#==============================================================================

class FF_Sprite_Damage < Sprite
  
  @@bitmap_size = Bitmap.new(32, 32)
  
  #--------------------------------------------------------------------------
  # - Váriáveis Globais
  #--------------------------------------------------------------------------
  
  attr_accessor :x
  attr_accessor :y
  attr_accessor :ox
  attr_accessor :oy
  attr_reader :duration
  attr_accessor :follow
  
  #--------------------------------------------------------------------------
  # - Inicia
  #--------------------------------------------------------------------------
  
  def initialize(char=nil, viewport=nil, arguments=[0, 0])
    super(viewport)
    @char = char
    if @char != nil
      @original_x = @char.real_x
      @original_y = @char.real_y
      if $scene.instance_of?(Scene_Map)
        @on_map = true
      end
    end 
    @black = Color.new(0, 0, 0)
    @sprites = []
    @x = 0
    @y = 0
    @ox = arguments[0]
    @oy = arguments[1]
    @duration = 0
    @follow = false
    clear(false)
  end
  
  #--------------------------------------------------------------------------
  # - Dispose
  #--------------------------------------------------------------------------
  
  def dispose
    dispose_sprites(@sprites)
    @disposed = true
  end
  
  #--------------------------------------------------------------------------
  # - Dispose
  #--------------------------------------------------------------------------
  
  def dispose_sprites(sprites)
    for i in 0...sprites.size
      next if @sprites[i].nil?
      case @sprites[i]
      when Array
        dispose_sprites(sprites[i])
      when Sprite
        sprites[i].dispose
      end
    end
  end
  
  #--------------------------------------------------------------------------
  # - Define a duração
  #--------------------------------------------------------------------------
  
  def setup_duration(duration)
    @duration = duration
    @original_duration = duration
  end
  
  #--------------------------------------------------------------------------
  # - Limpa
  #--------------------------------------------------------------------------
  
  def clear(need_refresh=true)
    @texts = []
    @height = 0
    @width = 0
    refresh if need_refresh
  end
  
  #--------------------------------------------------------------------------
  # - Dá um Setup nos textos
  #--------------------------------------------------------------------------
  
  def setup_text(id, text, color, font=nil)
    @texts[id] = [text, color, font]
    if font.nil?
      @@bitmap_size.font = Font.new
    else
      @@bitmap_size.font = font
    end
    regexp_hex = /[0123456789ABCDEFabcdef]/
    texto = text.gsub(/\[[Cc][Oo][Ll][Oo][Rr][ ]?=[ ]?#(#{regexp_hex}#{regexp_hex}#{regexp_hex}#{regexp_hex}#{regexp_hex}#{regexp_hex}#{regexp_hex}?#{regexp_hex}?)\]/) { "" }
    texto.gsub!(/\[\/[Cc][Oo][Ll][Oo][Rr]\]/) { "" }
    @size_texto = texto
    rect = @@bitmap_size.text_size(texto)
    @height += rect.height + 4
    @width = [rect.width + 16, @width].max
  end
  
  #--------------------------------------------------------------------------
  # - Atualiza
  #--------------------------------------------------------------------------
  
  def refresh
    i = 0
    for text in @texts
      next if text.nil?
      i += draw_text(i, text)
    end
  end
  
  #--------------------------------------------------------------------------
  # - Desenha os textos
  #--------------------------------------------------------------------------
  
  def draw_text(y, text)
    texto = text[0].dup
    original_color = text[1]
    font = text[2]
    if font.nil?
      real_font = Font.new
      @@bitmap_size.font = Font.new
    else
      real_font = font
      @@bitmap_size.font = font
    end
    ah = (@@bitmap_size.text_size(texto).height + 4)
    ax = 0
    regexp_hex = /[0123456789ABCDEFabcdef]/
    texto.gsub!(/\[[Cc][Oo][Ll][Oo][Rr][ ]?=[ ]?#(#{regexp_hex}#{regexp_hex}#{regexp_hex}#{regexp_hex}#{regexp_hex}#{regexp_hex}#{regexp_hex}?#{regexp_hex}?)\]/) { "\x01[##{$1}]" }
    texto.gsub!(/\[\/[Cc][Oo][Ll][Oo][Rr]\]/) { "\x02" }
    color = original_color
    i = 1
    while ((c = texto.slice!(/./m)) != nil)
      case c
      when "\x01"
        texto.sub!(/\[#(#{regexp_hex}#{regexp_hex})(#{regexp_hex}#{regexp_hex})(#{regexp_hex}#{regexp_hex})(#{regexp_hex}#{regexp_hex})?\]/, "")
        r = $1.hex
        g = $2.hex
        b = $3.hex
        a = ($4.nil? ? 255 : $4.hex)
        color = Color.new(r, g, b, a)
        next
      when "\x02"
        color = original_color
        next
      end
      sprite = FF_Sprite_Damage_System.new(@viewport)
      sprite.bitmap = Bitmap.new(48, 48)
      sprite.bitmap.font = real_font
      sprite.bitmap.font.color = @black
      sprite.bitmap.draw_text(0, 0, 46, 46, c)
      sprite.bitmap.draw_text(2, 0, 46, 46, c)
      sprite.bitmap.draw_text(0, 2, 46, 46, c)
      sprite.bitmap.draw_text(2, 2, 46, 46, c)
      sprite.bitmap.font.color = color
      sprite.bitmap.draw_text(1, 1, 46, 46, c)
      sprite.ox = 18
      sprite.oy = 18
      sprite.add_y = y
      sprite.add_x = ax
      sprite.x = @x - @ox + sprite.add_x
      sprite.y = @y - @oy + sprite.add_y
      sprite.duration = @original_duration + i * 3
      @sprites.push(sprite)
      ax += sprite.bitmap.text_size(c).width
      i += 1
    end
    return ah
  end
  
  #--------------------------------------------------------------------------
  # - Atualização do Frame
  #--------------------------------------------------------------------------
  
  def update
    return if @disposed
    @duration = 0
    if @on_map
      update_char
    end
    for sprite in @sprites
      sprite.update
      sprite.x = @x - @ox + sprite.add_x
      sprite.y = @y - @oy + sprite.add_y
      @duration = [sprite.duration, @duration].max
    end
  end
      
  #--------------------------------------------------------------------------
  # - Atualização do Char
  #--------------------------------------------------------------------------
  
  def update_char
    if (@follow && @char != nil)
      ax = ($game_map.adjust_x(@char.real_x) + 8007) / 8 - 1000 + 16
      ay = ($game_map.adjust_y(@char.real_y) + 8007) / 8 - 1000 + 32
      self.x = ax
      self.y = ay
    else
      ax = ($game_map.adjust_x(@original_x) + 8007) / 8 - 1000 + 16
      ay = ($game_map.adjust_y(@original_y) + 8007) / 8 - 1000 + 32
      self.x = ax
      self.y = ay
    end
  end
  
end

#==============================================================================
# Dano do Final Fantasy
#==============================================================================

class FF_Sprite_Damage_System < Sprite
  
  attr_accessor :add_x
  attr_accessor :add_y
  attr_accessor :duration
  
  
  def initialize(viewport)
    super(viewport)
    @duration = 0
    @add_x = 0
    @add_y = 0
    @add_x2 = 0
    @add_y2 = 0
  end
  
  def duration=(valor)
    @duration = valor
    self.visible = (@duration <= 60)
  end
    
  def add_x
    return @add_x + @add_x2
  end
  
  def add_y
    return @add_y + @add_y2
  end
  
  def update
    if @duration > 0
      @duration -= 1
      self.visible = (@duration <= 60)
      case @duration
      when 55..59
        @add_y2 -= 3
      when 51..54
        @add_y2 -= 1
      when 47..50
        @add_y2 += 1
      when 42..46
        @add_y2 += 3
      end
      self.opacity = 255 * @duration / 60.0
    else
      self.visible = false
    end
  end
  
end

#==============================================================================
# Fim da Verificação
#==============================================================================

end
