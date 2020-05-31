###############################################################################
############################# PR Coders - AMS ############################
###############################################################################
#==============================================================================
# Message System
# -----------------------------------------------------------------------------
# Instruções:
# -----------------------------------------------------------------------------
# [color=#FFFFF] Text [\color] -> Color(#FFFFFF - Código hexadecimal da cor)
# ----------------------------------------------------
# [b] Text [\b] -> Bold
# ----------------------------------------------------
# [i] Text [\i] -> Italic
# ----------------------------------------------------
# [u] Text [\u] -> Underlined
# ----------------------------------------------------
# [s] Text [\s] -> Stroked
# ----------------------------------------------------
# [s=#FFFFFF] Text [\s] -> Stroked using given color
# ----------------------------------------------------
# [d] Text [\d] -> Shadow
# ----------------------------------------------------
# [d=10] Text [\d] -> Shadow (size 10)
# ----------------------------------------------------
# [d=10 color=#FFFFFF] Text [\d] -> Shadow (size 10, color #FFFFFF)
# ----------------------------------------------------
# [size=20] Text [\size]  -> Text Size
# ----------------------------------------------------
# [gsize=20]  -> Text size (Permanent)
# ----------------------------------------------------
# [speed=3] Text [\speed]  -> Speed 3 letters per frame
# [speed=-3] Text [\speed]  -> Speed 3 frames per letter
# ----------------------------------------------------
# [gspeed=3] -> Global Speed
# ----------------------------------------------------
# [ipt] -> Locks the text until Input::C is triggered
# [input] -> Locks the text until Input::C is triggered
# ----------------------------------------------------
# [wait=40] -> Wait 40 frames
# ----------------------------------------------------
# [fade=40] -> Fade the text in 40 frames
# ----------------------------------------------------
# [tfade=40] -> Fade the window and text in 40 frames
# ----------------------------------------------------
# [icon="001-Weapon01"] -> Draws "001-Weapon01"
# ----------------------------------------------------
# [item=1] -> Draws item 1 icon and its name
# ----------------------------------------------------
# [armor=1] -> Draws armor 1 icon and its name
# ----------------------------------------------------
# [weapon=1] -> Draw weapons 1 icon and its name
# ----------------------------------------------------
# [align=X] -> Algign the text (0 - Left ; 1 - Center ; 2 - Right)
# ----------------------------------------------------
# [font="Fonte"] -> Change the font to "Fonte"
# [\font] -> Original Font
# ----------------------------------------------------
# [gfont="Fonte"] -> Global Font (permanent)
# ----------------------------------------------------
# [lock] -> Locks the C button
# ----------------------------------------------------
# [unlock] -> Unocks the C button
# ----------------------------------------------------
# [glock] -> Locks the C button (Permanent)
# ----------------------------------------------------
# [gunlock] -> Unocks the C button (Permanent)
# ----------------------------------------------------
# [next] -> Attach the next message
# ----------------------------------------------------
# [wtype=X] -> Window Type: (0 - Normal ; 1 - Screen ; 2 - Below Event ; 3 - Above event)
# ----------------------------------------------------
# [wpos=X] -> Must be used with [wtype=X];
# Ex:
# [wtype=1][wpos=X] X will be the Y position in screen
# [wtype=2][wpos=X] X - Event ID. (0 - Player ; 1 and so on - Event Id)
# [wtype=3][wpos=X] X - Event ID. (0 - Player ; 1 and so on - Event Id)
# ----------------------------------------------------
# Name Box
# ----------------------------------------------------
# [name="Nome"] "Nome" will appear in a separated window
# [name="Nome" type=1] "Nome" will appear in a separated window on the righ side
# Call:
# - To change the Window Name font.
## $game_system.window_name_font.name = "Fonte"
# - To change the Window Name size.
## $game_system.window_name_font.size = Value
# ----------------------------------------------------
# Faces
# ----------------------------------------------------
# Size Face:
## FACE_BASE_SIZE = [a, b] # a - Width ; b - height
# Defina os adicionais da face em:
## ADDS[0] = "" # Adicional 0 representa a face normal
## ADDS[1] = "_Talking" # Adicional 1 representa a face com o sufixo "_Talking"
## ADDS[2] = "_Seu_Aficional" # Adicional 2 representa a face com o sufixo "_Seu_Aficional"
## Ex: "Face" - Nome face normal
##     "Face_Talking" - Nome face com o adicional 1
##     "Face_Seu_Aficional" - Nome face com o seu adicional 2
# - Caso a face esteja olhando pro lado que você não queira use o seguinte
# comando para inverter
## $game_system.message_face_mirror = true
# - Posição da face: 0 - Esquerda ; 1 - Direita
## $game_system.message_face_position = 0
# - Comandos na mensagem
# ----------------------------------------------------
# [fadd=0] -> Muda a face para o adicional 0
# [fadd=1] -> Muda a face para o adicional 1
# ----------------------------------------------------
# [fstop] -> Deixa a face parada no frame 0
# [fstop=2] -> Deixa a face parada no frame 2
# ----------------------------------------------------
# [fanim]  -> A face retorna a se animar
# ----------------------------------------------------
# [frate=1] -> A taxa de animação do frame será 1 frame por segundo
# [frate=2] -> A taxa de animação do frame será 1 frame a cada 2 segundos
# [\frate] -> Retorna a taxa de animação padrão
#==============================================================================
# Nome e versão do script
script_name = "AMS" 
version = 1.0

# Habilita o script, para desabilitar deixe false
PRCoders.log_script(script_name, version)

module PRAMS
  
  # Tamanho Base da imagem da Face
  # [largura, altura]
  # Se a largura for maior que a atual será considerado uma animação de face
  FACE_BASE_SIZE = [96, 96]
  
  #Taxa de animação da face
  FACE_FRAME_RATE = 5
  
  # Adicionais da Face
  ADDS = []
  ADDS[0] = ""
  ADDS[1] = "_Talking"
  
  # Não Mexa!!!!
  HEX = /[0123456789ABCDEFabcdef]/
  
  # Fonte da Caixa de Nome
  NAME_FONT = Font.new
  # Nome da fonte
  NAME_FONT.name = "Calling Code"
  # Tamanho da Fonte
  NAME_FONT.size = 20
  # Cor da Fonte
  NAME_FONT.color = Color.new(255, 20, 20)
  # Negrito? (false = falso ; true => verdadeiro)
  NAME_FONT.bold = true
  # Itálico? (false = falso ; true => verdadeiro)
  NAME_FONT.italic = false
  
  # Fonte da Caixa de Mensagem
  TEXT_FONT = Font.new
  # Nome da fonte
  TEXT_FONT.name = NAME_FONT.name
  # Tamanho da Fonte
  TEXT_FONT.size = 16
  # Cor da Fonte
  TEXT_FONT.color = Color.new(255, 255, 255)
  # Negrito? (false = falso ; true => verdadeiro)
  TEXT_FONT.bold = false
  # Itálico? (false = falso ; true => verdadeiro)
  TEXT_FONT.italic = false
  
end

#==============================================================================
# Verificação se já não foi carregado
#==============================================================================

if PRCoders.check_enabled?(script_name, version)
  
# Carrega o script para evitar dois scripts iguais
PRCoders.load_script(script_name, version)

#==============================================================================
# Classe Game_System
#==============================================================================

class Game_System
  
  attr_accessor :message_face_mirror
  attr_accessor :message_face_position
  attr_accessor :message_speed
  attr_accessor :message_se
  attr_accessor :lock_jump_message
  attr_accessor :message_font
  attr_accessor :window_name_font
  attr_accessor :window_name_windowskin
  
  alias pr_ams_gsystem_initialize initialize
  
  def initialize
    @message_face_name = ""
    @message_face_mirror = false
    @message_face_position = 0
    @message_speed = 1
    @message_se = ""
    @lock_jump_message = false
    @message_font = AMSFont.new(PRAMS::TEXT_FONT)
    @window_name_font = AMSFont.new(PRAMS::NAME_FONT)
    @window_name_windowskin = "Window"
    pr_ams_gsystem_initialize
  end
  
  def message_font=(valor)
    if valor.is_a?(Font)
      @message_font = AMSFont.new(valor)
    else
      @message_font = valor
    end
  end
  
  def window_name_font=(valor)
    if valor.is_a?(Font)
      @window_name_font = AMSFont.new(valor)
    else
      @window_name_font = valor
    end
  end
  
end

class Font
  
  def setup_new_font(new_font)
    self.name = new_font.name
    self.size = new_font.size
    self.bold = new_font.bold
    self.italic = new_font.italic
    self.color = Color.new(new_font.color_red, new_font.color_green, new_font.color_blue, new_font.color_alpha)
  end
  
end

class AMSFont
  
  attr_accessor(:name, :size, :bold, :italic, :color_red, :color_green, :color_blue, :color_alpha)
  
  def initialize(font)
    setup_font(font)
  end
  
  def setup_font(new_font)
    self.name = new_font.name
    self.size = new_font.size
    self.bold = new_font.bold
    self.italic = new_font.italic
    self.color_red = new_font.color.red
    self.color_green = new_font.color.green
    self.color_blue = new_font.color.blue
    self.color_alpha = new_font.color.alpha
  end
  
  def color
    return Color.new(self.color_red, self.color_green, self.color_blue, self.color_alpha)
  end
  
  def color=(color)
    self.color_red = color.red
    self.color_green = color.green
    self.color_blue = color.blue
    self.color_alpha = color.alpha
  end
  
end

#==============================================================================
# ■ Game_Interpreter
#==============================================================================

class Game_Interpreter
  
  #--------------------------------------------------------------------------
  # ● Reseta a face
  #--------------------------------------------------------------------------
  
  def reset_face
    $game_system.message_face_position = 0
    $game_system.message_face_mirror = false
  end    
  
  #--------------------------------------------------------------------------
  # ● Mensagem
  #--------------------------------------------------------------------------
  
  def command_101
    unless $game_message.busy
      $game_message.face_name = @params[0]
      $game_message.face_index = @params[1]
      $game_message.background = @params[2]
      $game_message.position = @params[3]
      @index += 1
      while @list[@index].code == 401       # 文章データ
        $game_message.texts.push(@list[@index].parameters[0])
        @index += 1
      end
      while ($game_message.attach_next_text?)
        if @list[@index].code == 101 
          @index += 1
        end
        while @list[@index].code == 401       # 文章データ
          $game_message.texts.push(@list[@index].parameters[0])
          @index += 1
        end
      end
      if @list[@index].code == 102          # 選択肢の表示
        setup_choices(@list[@index].parameters)
      elsif @list[@index].code == 103       # 数値入力の処理
        setup_num_input(@list[@index].parameters)
      end
      set_message_waiting                   # メッセージ待機状態にする
    end
    return false
  end
  
  #--------------------------------------------------------------------------
  # ● Define as escolhas
  #--------------------------------------------------------------------------
  
  def setup_choices(params)
    $game_message.choice_start = $game_message.texts.size
    $game_message.choice_max = params[0].size
    for s in params[0]
      $game_message.texts.push(s)
    end
    $game_message.choice_cancel_type = params[1]
    $game_message.choice_proc = Proc.new { |n| @branch[@indent] = n }
    @index += 1
  end
  
  #--------------------------------------------------------------------------
  # ● Número
  #--------------------------------------------------------------------------
  
  def setup_num_input(params)
    $game_message.num_input_variable_id = params[0]
    $game_message.num_input_digits_max = params[1]
    @index += 1
  end
  
end

#==============================================================================
# ■ Game_Message
#==============================================================================

class Game_Message
  
  #--------------------------------------------------------------------------
  # ● Anexa o próximo Text?
  #--------------------------------------------------------------------------
  
  def attach_next_text?
    retorna = false
    @texts = @texts.dup
    for text in @texts
      next if text.nil?
      if text =~ /\[[Nn][Ee][Xx][Tt]\]/
        text.gsub!(/\[[Nn][Ee][Xx][Tt]\]/) { "" }
        retorna = true
      end
    end
    return retorna
  end
  
end

#==============================================================================
# ■ Numeric
#==============================================================================

class Numeric
  
  #--------------------------------------------------------------------------
  # - Para um número hexadecimal
  #--------------------------------------------------------------------------
    
  def to_hex(h = 0)
    n2 = n = self.to_i
    hex = ""
    while (n >= 16)
      x = n % 16
      n /= 16
      x = (x >= 10 ? (65 + (x - 10)).chr : x.to_s)
      hex = x + hex
    end
    x = (n >= 10 ? (65 + (n - 10)).chr : n.to_s)
    hex = x + hex
    while (hex.size < h)
      hex = "0" + hex
    end
    return hex
  end
  
end

#==============================================================================
# ■ Color
#==============================================================================

class Color
  
  #--------------------------------------------------------------------------
  # - Para uma cor hexadecimal
  #--------------------------------------------------------------------------
    
  def to_hex
    r = [[self.red, 255].min, 0].max
    g = [[self.green, 255].min, 0].max
    b = [[self.blue, 255].min, 0].max
    a = [[self.alpha, 255].min, 0].max
    text = "#" + r.to_hex(2) + g.to_hex(2) + b.to_hex(2) + (a == 255 ? "" : a.to_hex(2))
    return text
  end
  
  #--------------------------------------------------------------------------
  # - Igual a outra cor?
  #--------------------------------------------------------------------------
    
  def ==(valor)
    return false unless valor.is_a?(Color)
    return false if valor.red != self.red
    return false if valor.green != self.green
    return false if valor.blue != self.blue
    return false if valor.alpha != self.alpha
    return true
  end
  
end

#==============================================================================
# ■ Window_Message
#==============================================================================

class Window_Message < Window_Selectable
  
  #--------------------------------------------------------------------------
  # - Alias
  #--------------------------------------------------------------------------
    
  alias pr_coders_ams_wmessage_initialize initialize
  alias pr_coders_ams_wmessage_dispose dispose
  alias pr_coders_ams_wmessage_update update
  alias pr_coders_ams_wmessage_close close
  
  include PRAMS
  
  #--------------------------------------------------------------------------
  # - Inicialização
  #--------------------------------------------------------------------------
    
  def initialize
    @face_name = ""
    @last_face_name = ""
    pr_coders_ams_wmessage_initialize
    @sprite_face = Sprite_Face.new(self.viewport)
    @sprite_face.z = self.z + 10
    @window_name = Window_AMS_Name.new
    @window_name.z = self.z + 12
  end
  
  #--------------------------------------------------------------------------
  # ● Define a Janela
  #--------------------------------------------------------------------------
  
  def windowskin=(valor)
    unless valor.nil?
      valor = valor.dup
      valor.clear_rect(80, 16, 32, 32)
    end
    super
  end
  
  #--------------------------------------------------------------------------
  # ● Cria o Bitmap
  #--------------------------------------------------------------------------
  
  def reset_contents
    unless [1, 2, 3].include?(@window_type)
      self.contents.dispose
      self.contents = Bitmap.new(width - 32, [32, @max_lines * WLH].max)
      self.contents.font.setup_new_font($game_system.message_font)
    end
  end
  
  #--------------------------------------------------------------------------
  # ● Limpa o AMS
  #--------------------------------------------------------------------------
  
  def clear_ams
    @underline = false
    @shadow = false
    @stroke = false
    @wait_for_input = false
    @stroke_color = Color.new(0, 0, 0)
    @shadow_intensivity = 1
    @speed = $game_system.message_speed
    @wait_message_count = 0
    @message_locked = $game_system.lock_jump_message
    @window_name_position = 0
    @window_type = 0
    @additional_width = 0
    @initial_contents_x = 0
    @fade_max_time = 0
    @fade_finish = false
    @total_fade = false
    @window_position = nil
    self.oy = 0
    self.contents_opacity = 255
    @sprite_face.opacity = 255
    @window_name.contents_opacity = 255
    @window_name.opacity = 255
  end
  
  #--------------------------------------------------------------------------
  # ● Limpa o AMS
  #--------------------------------------------------------------------------
  
  def post_clear_ams
    self.oy = 0
    self.contents_opacity = 255
    @sprite_face.opacity = 255
    @window_name.contents_opacity = 255
    @window_name.opacity = 255
    @underline = false
    @shadow = false
    @stroke = false
    @wait_for_input = false
    @stroke_color = Color.new(0, 0, 0)
    @shadow_intensivity = 1
    @speed = $game_system.message_speed
    @wait_message_count = 0
    @message_locked = $game_system.lock_jump_message
  end
  
  #--------------------------------------------------------------------------
  # ● 解放
  #--------------------------------------------------------------------------
  
  def dispose
    pr_coders_ams_wmessage_dispose
    @sprite_face.dispose
    @window_name.dispose
  end
  
  #--------------------------------------------------------------------------
  # ● Comaça a mensagem
  #--------------------------------------------------------------------------
  
  def start_message
    @text = ""
    @max_lines = $game_message.texts.size
    for i in 0...$game_message.texts.size
      @text += "　　" if i >= $game_message.choice_start
      @text += $game_message.texts[i].clone + "\x00"
    end
    @item_max = $game_message.choice_max
    clear_ams
    convert_special_characters
    reset_window
    reset_contents
    post_clear_ams
    new_page
    reset_ams_positions
  end
  
  #--------------------------------------------------------------------------
  # ● Nova linha
  #--------------------------------------------------------------------------
 
  def new_line
    if $game_message.face_name.empty?
      @contents_x = 0
    else
      @contents_x = @initial_contents_x
    end
    @contents_y += WLH
    @line_count += 1
    @line_show_fast = false
  end
  
  #--------------------------------------------------------------------------
  # ● Nova página
  #--------------------------------------------------------------------------
  
  def new_page
    contents.clear
    if $game_message.face_name.empty?
      @contents_x = 0
      draw_face("")
      @face_name = ""
      @initial_contents_x = 0
      @additional_width = 0
    else
      @additional_width = 112
      name = $game_message.face_name
      index = $game_message.face_index
      @face_name = name.clone
      draw_face(name, index, 0, 0)
      case $game_system.message_face_position
      when 1
        @contents_x = 0
        @initial_contents_x = 0
      else
        @initial_contents_x = 112
        @contents_x = 112
      end
    end
    @contents_y = 0
    @line_count = 0
    @show_fast = false
    @line_show_fast = false
    @pause_skip = false
    contents.font.color = text_color(0)
  end
  
  #--------------------------------------------------------------------------
  # ● Reseta as posições
  #--------------------------------------------------------------------------
  
  def reset_ams_positions
    reset_name_position
    reset_face_position
  end
  
  #--------------------------------------------------------------------------
  # ● Verifica a caixa de nome
  #--------------------------------------------------------------------------
  
  def check_name
    #return
    @window_name.visible = false
    @window_name_position = 0
    @text.gsub!(/\[[Nn][Aa][Mm][Ee][ ]?=[ ]?\"(.*)\"[ ]?([Tt][Yy][Pp][Ee][ ]?=[ ]?)?(\d+)?[ ]?\]/) {
      @window_name.set_name($1.dup)
      @window_name.visible = true
      unless $2.nil?
        unless $3.nil?
          @window_name_position = ($3.to_i)
        end
      end
      ""
    }
    @text.gsub!(/\[[Hh][Nn][Aa][Mm][Ee][ ]?=[ ]?(\d+)[ ]?([Tt][Yy][Pp][Ee][ ]?=[ ]?)?(\d+)?[ ]?\]/) {
      if ($game_actors[$1.to_i] != nil)
        @window_name.set_name($game_actors[$1.to_i].name)
        @window_name.visible = true
        unless $2.nil?
          unless $3.nil?
            @window_name_position = ($3.to_i)
          end
        end
      end
      ""
    }
  end
  
  #--------------------------------------------------------------------------
  # ● Termina a mensagem
  #--------------------------------------------------------------------------
  
  def terminate_message
    if (@fade_finish or @total_fade) and (!@fade_start)
      @fade_start = true
      @start_opacities = [self.contents_opacity, (@back_sprite.visible ? @back_sprite.opacity : self.opacity), @sprite_face.opacity]
      @fade_time = @fade_max_time
      if @fade_max_time <= 0
        real_terminate_message
      end
      return
    end
    real_terminate_message
  end
  
  #--------------------------------------------------------------------------
  # ● Termina a mensagem
  #--------------------------------------------------------------------------
  
  def real_terminate_message
    self.active = false
    self.pause = false
    self.index = -1
    @gold_window.close
    @number_input_window.active = false
    @number_input_window.visible = false
    $game_message.main_proc.call if $game_message.main_proc != nil
    $game_message.clear
    @window_name.visible = false
  end
  
  #--------------------------------------------------------------------------
  # ● Fecha a janela
  #--------------------------------------------------------------------------
  
  def close
    if @disable_closing
      self.openness = 0
      return
    end
    pr_coders_ams_wmessage_close
  end
  
  #--------------------------------------------------------------------------
  # ● Atualiza
  #--------------------------------------------------------------------------
  
  def update
    if @fade_start
      @fade_time -= 1
      self.contents_opacity = @start_opacities[0] * @fade_time / @fade_max_time.to_f
      @window_name.contents_opacity = self.contents_opacity
      if @total_fade
        if @back_sprite.visible
          @back_sprite.opacity = @start_opacities[1] * @fade_time / @fade_max_time.to_f
        else
          self.opacity = @start_opacities[1] * @fade_time / @fade_max_time.to_f
          @window_name.opacity = self.opacity
        end
      end
      @sprite_face.opacity = @start_opacities[2] * @fade_time / @fade_max_time.to_f
      if @fade_time <= 0
        if @total_fade
          @disable_closing = true
        end
        real_terminate_message
        @fade_start = false
      end
      @back_sprite.opacity = 0
      return
    end
    @sprite_face.update
    if @line_count > (page_row_max - 1)
      oy_c = @line_count - (page_row_max - 1)
      add = ($game_message.num_input_variable_id > 0 ? WLH : 0)
      self.oy = [[self.oy + 2, oy_c * WLH + add, (@max_lines - page_row_max) * WLH + add].min, 0].max
    end
    pr_coders_ams_wmessage_update
  end
  
  #--------------------------------------------------------------------------
  # ● Atualiza o cursor
  #--------------------------------------------------------------------------
  
  def update_cursor
    if @index >= 0
      x = ($game_message.face_name.empty? ? 0 : $game_system.message_face_position == 1 ? 0 : 112)
      y = ($game_message.choice_start + @index) * WLH - self.oy
      self.cursor_rect.set(x, y, contents.width - x, WLH)
    else
      self.cursor_rect.empty
    end
  end
  
  #--------------------------------------------------------------------------
  # ● Apertar o botão
  #--------------------------------------------------------------------------
  
  def input_pause
    if @wait_for_input
      self.pause = true
      if Input.trigger?(Input::B) or Input.trigger?(Input::C)
        self.pause = false
        @wait_for_input = false
      end
      return
    end
    if Input.trigger?(Input::B) or Input.trigger?(Input::C)
      self.pause = false
      if @text != nil and not @text.empty?
        new_page if @line_count >= MAX_LINE
      else
        terminate_message
      end
    end
  end
  
  #--------------------------------------------------------------------------
  # ● Atualiza a mensagem
  #--------------------------------------------------------------------------
  
  def update_message
    if @wait_for_input
      self.pause = true
      return
    end
    if @wait_message_count > 0
      @wait_message_count -= 1
      return
    end
    if @speed > 0
      for i in 0...@speed
        unless update_message_letter
          break
        end
      end
    elsif @speed == 0
      update_message_letter
    else
      update_message_letter
      @wait_message_count += @speed.abs
    end
  end
  
  #--------------------------------------------------------------------------
  # ● Reseta a janela
  #--------------------------------------------------------------------------
  
  def reset_window
    @background = $game_message.background
    @position = $game_message.position
    if @background == 0   # 通常ウィンドウ
      self.opacity = 255
    else                  # 背景を暗くする、透明にする
      self.opacity = 0
    end
    case @position
    when 0  # 上
      self.y = 0
      @gold_window.y = 360
    when 1  # 中
      self.y = 144
      @gold_window.y = 0
    when 2  # 下
      self.y = 288
      @gold_window.y = 0
    end
    case @window_type
    when 1
      self.x = -16
      self.y = @window_position
    when 2
      if @window_position == 0
        self.x = $game_player.screen_x - (self.width / 2)
        self.y = $game_player.screen_y
      else
        self.x = $game_map.events[@window_position].screen_x - (self.width / 2)
        self.y = $game_map.events[@window_position].screen_y
      end
    when 3
      if @window_position == 0
        self.x = $game_player.screen_x - (self.width / 2)
        self.y = $game_player.screen_y - self.height - get_character_size($game_player.character_name)[1]
      else
        self.x = $game_map.events[@window_position].screen_x - (self.width / 2)
        self.y = $game_map.events[@window_position].screen_y - self.height - get_character_size($game_map.events[@window_position].character_name)[1]
      end
    end
  end
  
  #--------------------------------------------------------------------------
  # ● Pega o tamanho do character
  #--------------------------------------------------------------------------
  
  def get_character_size(character_name)
    bitmap = Cache.character(character_name)
    sign = character_name[/^[\!\$]./]
    if sign != nil and sign.include?('$')
      cw = bitmap.width / 3
      ch = bitmap.height / 4
    else
      cw = bitmap.width / 12
      ch = bitmap.height / 8
    end
    return [cw, ch]
  end
  
  #--------------------------------------------------------------------------
  # ● Converte os characters
  #--------------------------------------------------------------------------
  
  def convert_special_characters
    @text = @text.dup
    @show_data = []
    i = 0
    @text.gsub!(/\\[Vv]\[([0-9]+)\]/i) { $game_variables[$1.to_i] }
    @text.gsub!(/\\[Nn]\[([0-9]+)\]/i) { $game_actors[$1.to_i].name }
    @text.gsub!(/\\[Cc]\[([0-9]+)\]/i) { "\x01[#{$1}]" }
    @text.gsub!(/\\[Gg]/)              { "\x02" }
    @text.gsub!(/\\\./)             { "\x03" }
    @text.gsub!(/\\\|/)             { "\x04" }
    @text.gsub!(/\\!/)              { "\x05" }
    @text.gsub!(/\\>/)              { "\x06" }
    @text.gsub!(/\\</)              { "\x07" }
    @text.gsub!(/\\\^/)             { "\x08" }
    @text.gsub!(/\[[Cc][Ll][Oo][Ss][Ee]\]/) { "\x08" }
    # Adicionais
    @text.gsub!(/\[[Cc][Oo][Ll][Oo][Rr][ ]?=[ ]?#(#{HEX}#{HEX}#{HEX}#{HEX}#{HEX}#{HEX}#{HEX}?#{HEX}?)\]/) { "\x81[##{$1}]" }
    @text.gsub!(/\[\\[Cc][Oo][Ll][Oo][Rr][ ]?\]/) { "\x81[#{text_color(0).to_hex}]" }
    # Negrito
    @text.gsub!(/\[[Bb]\]/) { "\x82" }
    @text.gsub!(/\[\\[Bb]\]/) { "\x83" }
    # Itálico
    @text.gsub!(/\[[Ii]\]/) { "\x84" }
    @text.gsub!(/\[\\[Ii]\]/) { "\x85" }
    # Itálico
    @text.gsub!(/\[[Uu]\]/) { "\x86" }
    @text.gsub!(/\[\\[Uu]\]/) { "\x87" }
    # Sombra
    @text.gsub!(/\[[Dd]\]/) { "\x88[1]" }
    @text.gsub!(/\[[Dd][ ]?=[ ]?(-)?[ ]?(\d+)\]/) { "\x88[#{$1}#{$2}]" }
    @text.gsub!(/\[\\[Dd]\]/) { "\x89" }
    # Stroke
    @text.gsub!(/\[[Ss]\]/) { "\x8a[#000000]" }
    @text.gsub!(/\[[Ss][ ]?=[ ]?#(#{HEX}#{HEX}#{HEX}#{HEX}#{HEX}#{HEX}#{HEX}?#{HEX}?)\]/) { "\x8a[##{$1}]" }
    @text.gsub!(/\[\\[Ss]\]/) { "\x8b" }
    # Tamanho do Text
    @text.gsub!(/\[[Ss][Ii][Zz][Ee][ ]?=[ ]?(\d+)\]/) { "\x8c[#{$1}]" }
    @text.gsub!(/\[\\[Ss][Ii][Zz][Ee]\]/) { "\x8d" }
    @text.gsub!(/\[[Gg][Ss][Ii][Zz][Ee][ ]?=[ ]?(\d+)\]/) { "\x8e[#{$1}]" }
    # Ícone
    @text.gsub!(/\[[Ii][Cc][Oo][Nn][ ]?=[ ]?\[[ ]*(\d+)[ ]*,[ ]*(\d+)[ ]*\]\]/) { 
      index = $2.to_i * 16 + $1.to_i
      "\x8f[#{index}]" 
    }
    @text.gsub!(/\[[Ii][Cc][Oo][Nn][ ]?=[ ]?(\d+)\]/) { 
      "\x8f[#{$1}]" 
    }
    # Item
    @text.gsub!(/\[[Ii][Tt][Ee][Mm][ ]?=[ ]?(\d+)\]/) { 
      id = $1.to_i
      atext = ""
      if id > 0
        item = $data_items[id]
        unless item.nil?
          atext = "\x8f[#{item.icon_index}] #{item.name}"
        end
      end
      atext
    }
    # Arma
    @text.gsub!(/\[[Ww][Ee][Aa][Pp][Oo][Nn][ ]?=[ ]?(\d+)\]/) { 
      id = $1.to_i
      atext = ""
      if id > 0
        item = $data_weapons[id]
        unless item.nil?
          atext = "\x8f[#{item.icon_index}] #{item.name}"
        end
      end
      atext
    }
    # Armadura
    @text.gsub!(/\[[Aa][Rr][Mm][Oo][Rr][ ]?=[ ]?(\d+)\]/) { 
      id = $1.to_i
      atext = ""
      if id > 0
        item = $data_armors[id]
        unless item.nil?
          atext = "\x8f[#{item.icon_index}] #{item.name}"
        end
      end
      atext
    }
    # Espera pressionar a tecla
    @text.gsub!(/\[[Ii][Pp][Tt]\]/) { "\x90" }
    @text.gsub!(/\[[Ii][Nn][Pp][Uu][Tt]\]/) { "\x90" }
    # Espera pressionar a tecla
    @text.gsub!(/\[[Ss][Pp][Ee][Ee][Dd][ ]?=[ ]?(-)?[ ]?(\d+)\]/) { "\x91[#{$1}#{$2}]" }
    @text.gsub!(/\[\\[Ss][Pp][Ee][Ee][Dd]\]/) { "\x92" }
    @text.gsub!(/\[[Gg][Ss][Pp][Ee][Ee][Dd][ ]?=[ ]?(-)?[ ]?(\d+)\]/) { "\x93[#{$1}#{$2}]" }
    # Muda o nome da fonte
    @text.gsub!(/\[[Ff][Oo][Nn][Tt][ ]?=[ ]?\"(.*)\"\]/) { "\x94[#{$1}]" }
    @text.gsub!(/\[\\[Ff][Oo][Nn][Tt]\]/) { "\x95" }
    @text.gsub!(/\[[Gg][Ff][Oo][Nn][Tt][ ]?=[ ]?\"(.*)\"\]/) { "\x96[#{$1}]" }
    # Travar a Mensagem
    @text.gsub!(/\[[Ll][Oo][Cc][Kk]\]/) { "\x98" }
    @text.gsub!(/\[[Gg][Ll][Oo][Cc][Kk]\]/) { "\x9a" }
    # DesTravar a Mensagem
    @text.gsub!(/\[[Uu][Nn][Ll][Oo][Cc][Kk]\]/) { "\x99" }
    @text.gsub!(/\[\\[Ll][Oo][Cc][Kk]\]/) { "\x99" }
    @text.gsub!(/\[[Gg][Uu][Nn][Ll][Oo][Cc][Kk]\]/) { "\x9b" }
    @text.gsub!(/\[\\[Gg][Ll][Oo][Cc][Kk]\]/) { "\x9b" }
    # Face
    @text.gsub!(/\[[Ff][Aa][Dd][Dd][ ]?=[ ]?(\d+)\]/) { "\x9c[#{$1}]" }
    @text.gsub!(/\[[Ff][Ss][Tt][Oo][Pp]\]/) { "\x9d[-1]" }
    @text.gsub!(/\[[Ff][Ss][Tt][Oo][Pp][ ]?=[ ]?(\d+)\]/) { "\x9d[#{$1}]" }
    @text.gsub!(/\[[Ff][Aa][Nn][Ii][Mm]\]/) { "\x9e[-1]" }
    @text.gsub!(/\[[Ff][Aa][Nn][Ii][Mm][ ]?=[ ]?(\d+)\]/) { "\x9e[#{$1}]" }
    # Frame Rate
    @text.gsub!(/\[[Ff][Rr][Aa][Tt][Ee][ ]?=[ ]?(\d+)\]/) { "\x9f[#{$1}]" }
    @text.gsub!(/\[\\[Ff][Rr][Aa][Tt][Ee][ ]?\]/) { "\x9f[#{FACE_FRAME_RATE}]" }
    # Esperar
    @text.gsub!(/\[[Ww][Aa][Ii][Tt][ ]?=[ ]?(\d+)\]/) { "\a0[#{$1}]" }
    # Fade
    @text.gsub!(/\[[Ff][Aa][Dd][Ee][ ]?=[ ]?(\d+)\]/) { 
      @fade_max_time = [@fade_max_time, $1.to_i].max
      @fade_finish = (@fade_max_time > 0)
      ""
    }
    @text.gsub!(/\[[Tt][Ff][Aa][Dd][Ee][ ]?=[ ]?(\d+)\]/) { 
      @fade_max_time = [@fade_max_time, $1.to_i].max
      @total_fade = (@fade_max_time > 0)
      ""
    }
    # Posição da Janela
    @text.gsub!(/\[[Ww][Tt][Yy][Pp][Ee][ ]?=[ ]?(\d+)\]/) { 
      unless $1.nil?
        @window_type = $1.to_i
      end
      ""
    }
    # Posição da Janela
    @text.gsub!(/\[[Ww][Pp][Oo][Ss][ ]?=[ ]?(\d+)\]/) { 
      unless $1.nil?
        @window_position = $1.to_i
      end
      ""
    }
    # Barra
    @text.gsub!(/\\\\/)             { "\\" }
    # Nome
    check_name
    # Alinhamento dos Texts
    check_aligns
    check_line_widths
    # Tipo de Janela
    check_window_type
  end
  
  #--------------------------------------------------------------------------
  # ● Verifica os alinhamentos
  #--------------------------------------------------------------------------
  
  def check_aligns
    text_lines = @text.dup.split("\x00")
    @aligns = []
    la = 0
    for i in 0...text_lines.size
      @aligns[i] ||= la
      text_lines[i].gsub!(/\[[Aa][Ll][Ii][Gg][Nn][ ]?=[ ]?(\d+)\]/) {
        @aligns[i] = [[$1.to_i, 0].max, 2].min
        la = @aligns[i]
        ""
      }
    end
    @text.gsub!(/\[[Aa][Ll][Ii][Gg][Nn][ ]?=[ ]?(\d+)\]/) { "" }
  end
  
  #--------------------------------------------------------------------------
  # ● Verifica o tipo de mensagem
  #--------------------------------------------------------------------------
  
  def check_window_type
    # Ajeita a janela
    case @window_type
    when 1
      if @window_position.nil?
        @window_position = 80
      end
      self.width = 544 + 32
      self.height = 64
      self.contents.dispose
      self.contents = Bitmap.new(self.width - 32, self.height - 32)
    when 2..3
      if @window_position.nil?
        @window_position = 0
      end
      w = 0
      line_number = 0
      if $game_message.face_name.empty?
        add_w = 0
        add_h = 0
      else
        add_w = @sprite_face.frame_width + 32
        add_h = @sprite_face.frame_height + 32
      end
      for i in 0...@line_widths.size
        w = [@line_widths[i] + add_w, w, 96].max
        line_number += 1 if @line_widths[i] > 0
      end
      self.width = w + 32
      self.height = [[line_number, 4].min * 32 + 32, add_h].max
      self.contents.dispose
      self.contents = Bitmap.new(self.width - 32, self.height - 32)
      @window_position = @window_position.abs
    else
      self.x = 0
      self.width = 544
      self.height = 128
      create_contents
    end
  end
  
  #--------------------------------------------------------------------------
  # ● Verifica a largura das linhas
  #--------------------------------------------------------------------------
  
  def check_line_widths
    @line_widths = [0]
    @line_count = 0
    ay = 0
    atext = @text.dup
    new_page
    locked = @message_locked
    @message_locked = true
    loop do
      if @line_widths[@line_count].nil?
        @line_widths[@line_count] = 0
      end
      x = update_message_letter
      @line_widths[@line_count] = [@line_widths[@line_count], @contents_x].max
      break if @text.nil? or @text == ""
    end
    @message_locked = locked
    @text = atext
    new_page
  end
  
  #--------------------------------------------------------------------------
  # ● Atualiza a letra
  #--------------------------------------------------------------------------
  
  def update_message_letter(all_message=false)
    retorna = true
    loop do
      c = @text.slice!(/./m)            # 次の文字を取得
      case c
      when nil                          # 描画すべき文字がない
        finish_message                  # 更新終了
        break
      when "\x00"                       # 改行
        new_line
        if @line_count >= @max_lines
          unless @text.empty?           # さらに続きがあるなら
            self.pause = true           # 入力待ちを入れる
            retorna = false
            break
          end
        end
      when "\x01"                       # \C[n]  (文字色変更)
        @text.sub!(/\[([0-9]+)\]/, "")
        contents.font.color = text_color($1.to_i)
        next
      when "\x02"                       # \G  (所持金表示)
        @gold_window.refresh
        @gold_window.open
      when "\x03"                       # \.  (ウェイト 1/4 秒)
        @wait_count = 15
        break
      when "\x04"                       # \|  (ウェイト 1 秒)
        @wait_count = 60
        break
      when "\x05"                       # \!  (入力待ち)
        self.pause = true
        break
      when "\x06"                       # \>  (瞬間表示 ON)
        @line_show_fast = true
      when "\x07"                       # \<  (瞬間表示 OFF)
        @line_show_fast = false
      when "\x08"                       # \^  (入力待ちなし)
        @pause_skip = true
      # Mostra o Text não formatado
      when "\x80"
        @text.sub!(/\[([0-9]+)\]/, "")
        @text[0, 0] = @show_data[$1.to_i]
        next
      # Cor
      when "\x81"                       
        @text.sub!(/\[#(#{HEX}#{HEX})(#{HEX}#{HEX})(#{HEX}#{HEX})(#{HEX}#{HEX})?\]/, "")
        r = $1.hex
        g = $2.hex
        b = $3.hex
        a = ($4.nil? ? 255 : $4.hex)
        contents.font.color = Color.new(r, g, b, a)
        next
      # Negrio
      when "\x82"                       
        contents.font.bold = true
        next
      when "\x83"                       
        contents.font.bold = false
        next
      # Itálico
      when "\x84"                       
        contents.font.italic = true
        next
      when "\x85"                       
        contents.font.italic = false
        next
      # Sublinhado
      when "\x86"                       
        @underline = true
        next
      when "\x87"                       
        @underline = false
        next
      # Sublinhado
      when "\x88"                       
        @text.sub!(/\[(-)?([0-9]+)\]/, "")
        @shadow = true
        @shadow_intensivity = ($1.nil? ? $2.to_i : -($2.to_i))
        next
      when "\x89"                       
        @shadow = false
        next
      # Stroke
      when "\x8a"
        @text.sub!(/\[#(#{HEX}#{HEX})(#{HEX}#{HEX})(#{HEX}#{HEX})(#{HEX}#{HEX})?\]/, "")
        r = $1.hex
        g = $2.hex
        b = $3.hex
        a = ($4.nil? ? 255 : $4.hex)
        @stroke_color = Color.new(r, g, b, a)
        @stroke = true
        next
      # Stroke
      when "\x8b"
        @stroke = false
        next
      # Tamanho do Text
      when "\x8c"
        @text.sub!(/\[([0-9]+)\]/, "")
        contents.font.size = $1.to_i
        next
      when "\x8d"
        contents.font.size = $game_system.message_font.size
        next
      when "\x8e"
        @text.sub!(/\[([0-9]+)\]/, "")
        $game_system.message_font.size = $1.to_i
        contents.font.size = $game_system.message_font.size
        next
      # Ícone
      when "\x8f"
        @text.sub!(/\[([0-9]+)\]/, "")
        case @aligns[@line_count]
        when 1
          x = (self.width - 32 - @additional_width) / 2 - @line_widths[@line_count] / 2 + @contents_x + (@initial_contents_x / 2)
        when 2
          x = (self.width - 32 - @additional_width) - @line_widths[@line_count] + @contents_x - (@stroke ? 1 : 0) + @initial_contents_x
        else
          x = @contents_x + (@stroke ? 1 : 0)
        end
        draw_icon($1.to_i, x, @contents_y + WLH / 2 - 12)
        @contents_x += 24
      # Espera a entrada de tecla
      when "\x90"
        @wait_for_input = true
        retorna = false
        break
      # Muda a velocidade
      when "\x91"
        @text.sub!(/\[(-)?([0-9]+)\]/, "")
        @speed = ($1.nil? ? $2.to_i : -($2.to_i))
        retorna = false
        break
      # Muda a velocidade
      when "\x92"
        @speed = $game_system.message_speed
        retorna = false
        break
      # Muda a velocidade
      when "\x93"
        @text.sub!(/\[(-)?([0-9]+)\]/, "")
        $game_system.message_speed = ($1.nil? ? $2.to_i : -($2.to_i))
        @speed = $game_system.message_speed
        retorna = false
        break
      # Muda a Fonte do Text
      when "\x94"
        @text.sub!(/\[(.*)\]/, "")
        contents.font.name = $1.dup
        next
      # Retorna a Fonte do Text
      when "\x95"
        contents.font.name = $game_system.message_font.name
        next
      # Retorna a Fonte do Text
      when "\x96"
        @text.sub!(/\[(.*)\]/, "")
        $game_system.message_font.name = $1.dup
        contents.font.name = $game_system.message_font.name
        next
      # Trava a mensagem
      when "\x98"
        @message_locked = true
        next
      # DesTrava a mensagem
      when "\x99"
        @message_locked = false
        next
      # Trava a mensagem (Permanentemente)
      when "\x9a"
        $game_system.lock_jump_message = true
        @message_locked = true
        next
      # DesTrava a mensagem (Permanentemente)
      when "\x9b"
        $game_system.lock_jump_message = false
        @message_locked = false
        next
      # Adicional da Face
      when "\x9c"
        @text.sub!(/\[([0-9]+)\]/, "")
        next if ADDS[$1.to_i].nil?
        next unless @face_name[0, 2] == "!!"
        draw_face(@face_name + ADDS[$1.to_i])
        next
      # Para a animaçãp
      when "\x9d"
        @text.sub!(/\[(-)?([0-9]+)\]/, "")
        @sprite_face.looping = false
        if $1.nil?
          @sprite_face.set_frame($2.nil? ? 0 : $2.to_i)
        end
        next
      # Volta a animar
      when "\x9e"
        @text.sub!(/\[(-)?([0-9]+)\]/, "")
        @sprite_face.looping = true
        if $1.nil?
          @sprite_face.set_frame($2.nil? ? 0 : $2.to_i)
        end
        next
      # Muda a taxa de animação
      when "\x9f"
        @text.sub!(/\[([0-9]+)\]/, "")
        @sprite_face.set_frame_rate($1.to_i)
        next
      # Muda a taxa de animação
      when "\xa0"
        @text.sub!(/\[([0-9]+)\]/, "")
        @wait_message_count += $1.to_i
        retorna = false
        break
      # Mudar o nome
      else                              # 普通の文字
        draw_c(c)
      end
      break if @message_locked
      break unless @show_fast or @line_show_fast
    end
    return retorna
  end
  
  #--------------------------------------------------------------------------
  # ● Desenha a letra
  #--------------------------------------------------------------------------
  
  def draw_c(c)
    case @aligns[@line_count]
    when 1
      x = (self.width - 32 - @additional_width) / 2 - @line_widths[@line_count] / 2 + @contents_x + (@initial_contents_x / 2)
    when 2
      x = (self.width - 32 - @additional_width) - @line_widths[@line_count] + @contents_x - (@stroke ? 1 : 0) + @initial_contents_x
    else
      x = @contents_x + (@stroke ? 1 : 0)
    end
    y = @contents_y + (@stroke ? 1 : 0)
    w = 40 - (@stroke ? 2 : 0)
    h = WLH - (@underline ? 2 : 0) - (@stroke ? 2 : 0)
    color = contents.font.color.dup
    c_width = contents.text_size(c).width
    if c == " "
      contents.font.color = @stroke_color
      if @underline
        if @stroke
          contents.fill_rect(x - 1, y + h - 2, c_width, 1, contents.font.color)
          contents.fill_rect(x - 1, y + h, c_width, 1, contents.font.color)
          contents.fill_rect(x + 1, y + h - 2, c_width, 1, contents.font.color)
          contents.fill_rect(x + 1, y + h, c_width, 1, contents.font.color)
        end
      end
      contents.font.color = color
      if @underline
        contents.fill_rect(x, y + h - 1, c_width, 1, contents.font.color)
      end
      @contents_x += c_width
      return
    end
    if @shadow and @shadow_intensivity != 0
      bshadow = Bitmap.new(w, h)
      bshadow.font = contents.font.dup
      bshadow.font.color.set(0, 0, 0)
      bshadow.draw_text(0, 0, w, h, c)
      bshadow.blur
      contents.blt(x + @shadow_intensivity, y + @shadow_intensivity, bshadow, bshadow.rect, 200)
      bshadow.dispose
    end
    if @stroke
      contents.font.color = @stroke_color
      contents.draw_text(x - 1, y - 1, w, h, c)
      contents.draw_text(x - 1, y + 1, w, h, c)
      contents.draw_text(x + 1, y - 1, w, h, c)
      contents.draw_text(x + 1, y + 1, w, h, c)
      if @underline
        contents.fill_rect(x - 1, y + h - 2, c_width, 1, contents.font.color)
        contents.fill_rect(x - 1, y + h, c_width, 1, contents.font.color)
        contents.fill_rect(x + 1, y + h - 2, c_width, 1, contents.font.color)
        contents.fill_rect(x + 1, y + h, c_width, 1, contents.font.color)
      end
    end
    contents.font.color = color
    contents.draw_text(x, y, w, h, c)
    if @underline
      contents.fill_rect(x, y + h - 1, c_width, 1, contents.font.color)
    end
    @contents_x += c_width
  end
  
  #--------------------------------------------------------------------------
  # ● Começa a seleção de número
  #--------------------------------------------------------------------------
  
  def start_number_input
    digits_max = $game_message.num_input_digits_max
    number = $game_variables[$game_message.num_input_variable_id]
    @number_input_window.digits_max = digits_max
    @number_input_window.number = number
    if $game_message.face_name.empty?
      @number_input_window.x = x
    else
      @number_input_window.x = ($game_system.message_face_position == 1 ? x : x + 112)
    end
    @number_input_window.y = y + @contents_y - self.oy
    @number_input_window.active = true
    @number_input_window.visible = true
    @number_input_window.update
  end
  
  #--------------------------------------------------------------------------
  # ● Desenha a Face
  #--------------------------------------------------------------------------
  
  def draw_face(face_name, face_index=0, x=0, y=0, size = 96)
    bitmap = Cache.face(face_name)
    include = "!!"
    if face_name[0, include.size] == include
      return if @last_face_name == face_name
      @sprite_face.reset_size
      @sprite_face.bitmap = bitmap
      @sprite_face.bitmap_dispose = true
    else
      rect = Rect.new(0, 0, 0, 0)
      rect.x = face_index % 4 * 96 + (96 - size) / 2
      rect.y = face_index / 4 * 96 + (96 - size) / 2
      rect.width = size
      rect.height = size
      @sprite_face.size = [rect.width, rect.height]
      nbitmap = Bitmap.new(rect.width, rect.height)
      nbitmap.blt(0, 0, bitmap, rect)
      @sprite_face.bitmap = nbitmap
      @sprite_face.bitmap_dispose = true
      bitmap.dispose
    end
    @last_face_name = face_name.clone
  end
  
  #--------------------------------------------------------------------------
  # ● Reseta a posição da Face
  #--------------------------------------------------------------------------
  
  def reset_face_position
    return if @sprite_face.bitmap.nil?
    case $game_system.message_face_position
    when 1
      @sprite_face.x = self.x + self.width - @sprite_face.size[0] - 16
    else
      @sprite_face.x = self.x + 16
    end
    @sprite_face.mirror = $game_system.message_face_mirror
    @sprite_face.y = self.y + (self.height / 2 - @sprite_face.bitmap.height / 2)
  end
  
  #--------------------------------------------------------------------------
  # ● Reseta a posição da Face
  #--------------------------------------------------------------------------
  
  def reset_name_position
    return if @window_name.nil?
    case @window_name_position 
    when 1
      @window_name.x = self.x + self.width - @window_name.width
    else
      @window_name.x = self.x
    end
    @window_name.y = self.y - @window_name.height / 2
    @window_name.z = self.z + 12
    @window_name.background = @background
  end
  
  #--------------------------------------------------------------------------
  # ● Abretura da janela
  #--------------------------------------------------------------------------
  
  def openness=(valor)
    super
    return if @sprite_face.nil?
    return if @sprite_face.disposed?
    @sprite_face.visible = (self.openness == 255)
  end
  
end

#==============================================================================
# Window_AMS_Name
#------------------------------------------------------------------------------
# Nome da janela de mensagems
#==============================================================================

class Window_AMS_Name
  
  #--------------------------------------------------------------------------
  # - Atualização do Cursor de Seleção
  #--------------------------------------------------------------------------
  
  def initialize
    @back = Window_Base.new(0, 0, 64, 64)
    @sprite_contents = Sprite.new
    @sprite_contents.bitmap = Bitmap.new(32, 32)
    @windowskin_name = $game_system.window_name_windowskin
    refresh_windowskin
    @back.contents.dispose
    @back.back_opacity = 190
    set_name("João")
    @name = ""
    self.visible = false
  end
  
  #--------------------------------------------------------------------------
  # - Atualização da windowskin
  #--------------------------------------------------------------------------
  
  def refresh_windowskin
    skin = Cache.system(@windowskin_name).dup
    skin.clear_rect(80, 16, 32, 32)
    @back.windowskin = skin
  end
  
  #--------------------------------------------------------------------------
  # - Atualização do Cursor de Seleção
  #--------------------------------------------------------------------------
  
  def set_name(name)
    if @windowskin_name != $game_system.window_name_windowskin
      @windowskin_name = $game_system.window_name_windowskin.dup
      refresh_windowskin
    end
    @name = name.dup
    @sprite_contents.bitmap.font.setup_new_font($game_system.window_name_font)
    name_rect = @sprite_contents.bitmap.text_size(name.to_s)
    @sprite_contents.bitmap.dispose
    @sprite_contents.bitmap = nil
    @sprite_contents.bitmap = Bitmap.new(name_rect.width + 8, name_rect.height + 8)
    @sprite_contents.bitmap.font.setup_new_font($game_system.window_name_font)
    @sprite_contents.bitmap.draw_text(@sprite_contents.bitmap.rect, name)
    @back.dispose
    @back = Window_Base.new(0, 0, name_rect.width + 16, name_rect.height + 16)
    @back.visible = @visible
  end
  
  #--------------------------------------------------------------------------
  # - Largura
  #--------------------------------------------------------------------------
  
  def width
    return @back.width
  end
  
  #--------------------------------------------------------------------------
  # - Altura
  #--------------------------------------------------------------------------
  
  def height
    return @back.height
  end
  
  #--------------------------------------------------------------------------
  # - Visibilidade
  #--------------------------------------------------------------------------
  
  def visible=(valor)
    @visible = (valor ? true : false)
    @sprite_contents.visible = @visible
    @back.visible = @visible
  end
  
  #--------------------------------------------------------------------------
  # - Dispose
  #--------------------------------------------------------------------------
  
  def dispose
    @sprite_contents.bitmap.dispose
    @sprite_contents.dispose
    @back.dispose
  end
  
  #--------------------------------------------------------------------------
  # - Fundo
  #--------------------------------------------------------------------------
  
  def background=(valor)
    @background = valor
    case @background
    when 0
      return
    when 1
      @back.opacity = 0
    end
  end
  
  #--------------------------------------------------------------------------
  # - Opacidade
  #--------------------------------------------------------------------------
  
  def opacity=(valor)
    @back.opacity = valor
  end
  
  #--------------------------------------------------------------------------
  # - Opacidade
  #--------------------------------------------------------------------------
  
  def back_opacity=(valor)
    @back.back_opacity = valor
  end
  
  #--------------------------------------------------------------------------
  # - Opacidade
  #--------------------------------------------------------------------------
  
  def contents_opacity=(valor)
    @sprite_contents.opacity = valor
  end
  
  #--------------------------------------------------------------------------
  # - Posição X
  #--------------------------------------------------------------------------
  
  def x=(valor)
    @sprite_contents.x = valor + 8
    @back.x = valor
  end
  
  #--------------------------------------------------------------------------
  # - Posição Y
  #--------------------------------------------------------------------------
  
  def y=(valor)
    @sprite_contents.y = valor + @back.height / 2 - (@sprite_contents.bitmap.height / 2)
    @back.y = valor
  end
  
  #--------------------------------------------------------------------------
  # - Posição Z
  #--------------------------------------------------------------------------
  
  def z=(valor)
    @sprite_contents.z = valor + 10
    @back.z = valor
  end
  
end

#==============================================================================
# Sprite_Face
#------------------------------------------------------------------------------
# Mostra a face na mensgame
#==============================================================================

class Sprite_Face < Sprite
  
  attr_reader   :looping
  attr_accessor :size
  attr_accessor :bitmap_dispose
  
  #--------------------------------------------------------------------------
  # - Inicialização
  #--------------------------------------------------------------------------
  
  def initialize(viewport=nil)
    super(viewport)
    @counter = 0
    @counter2 = 0
    @looping = true
    @max_counter = 0
    @frame_rate = PRAMS::FACE_FRAME_RATE
    @size = PRAMS::FACE_BASE_SIZE[0..1]
    @bitmap_dispose = false
  end
  
  #--------------------------------------------------------------------------
  # - Looping
  #--------------------------------------------------------------------------
    
  def looping=(valor)
    if valor
      @looping = true
    else
      @looping = false
      @counter = 0
      @counter2 = 0
      refresh
    end
  end
  
  #--------------------------------------------------------------------------
  # - Altura do Frame
  #--------------------------------------------------------------------------
    
  def frame_height
    if self.bitmap.nil?
      return 0
    else
      return @size[1] + 16
    end
  end
  
  #--------------------------------------------------------------------------
  # - Largura do Frame
  #--------------------------------------------------------------------------
    
  def frame_width
    if self.bitmap.nil?
      return 0
    else
      return @size[0] + 16
    end
  end
  
  #--------------------------------------------------------------------------
  # - Define o Frame
  #--------------------------------------------------------------------------
    
  def set_frame(frame)
    @counter = frame % @max_counter
    refresh
  end
  
  #--------------------------------------------------------------------------
  # - Reseta o tamanho
  #--------------------------------------------------------------------------
    
  def reset_size
    @size = PRAMS::FACE_BASE_SIZE[0..1]
  end
  
  #--------------------------------------------------------------------------
  # - Define a taxa
  #--------------------------------------------------------------------------
    
  def set_frame_rate(frame_rate=PRAMS::FACE_FRAME_RATE)
    @frame_rate = frame_rate
  end
  
  #--------------------------------------------------------------------------
  # - Atualização
  #--------------------------------------------------------------------------
    
  def refresh
    return if @max_counter == 0
    x = (@size[0] * @counter)
    self.src_rect.set(x, 0, @size[0], @size[1])
  end
  
  #--------------------------------------------------------------------------
  # - Bitmap=
  #--------------------------------------------------------------------------
    
  def bitmap=(valor)
    unless self.bitmap.nil?
      if @bitmap_dispose
        self.bitmap.dispose unless self.bitmap.disposed?
      end
    end
    super
    if self.bitmap.nil?
      @max_counter = 0
      return
    end
    @counter = 0
    @counter2 = 0
    @max_counter = [(self.bitmap.width / @size[0]), 1].max
    refresh
  end   
  
  #--------------------------------------------------------------------------
  # - Atualização
  #--------------------------------------------------------------------------
    
  def update
    super
    return if self.bitmap.nil?
    return unless @looping
    @counter2 = (@counter2 + 1) % @frame_rate
    if @counter2 == 0
      @counter = (@counter + 1) % @max_counter
      refresh
    end
  end    
  
end

end
