#_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
#_/   ◆                  Splash Logo - KGC_TitleDirection                ◆ VX ◆
#_/   ◇                       Last Update: 2008/09/06                         ◇
#_/   ◆                    Translation by Mr. Anonymous                       ◆
#_/   ◆ KGC Site:                                                             ◆
#_/   ◆ http://f44.aaa.livedoor.jp/~ytomy/                                    ◆
#_/   ◆ Translator's Blog:                                                    ◆
#_/   ◆ http://mraprojects.wordpress.com                                      ◆
#_/----------------------------------------------------------------------------
#_/   This script adds a function to display a splash logo before the title
#_/  screen is displayed. A sample of this effect is provided with the demo 
#_/  this script came packaged in.
#_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/

#==============================================================================
#                             ★ Customization ★
#==============================================================================

module KGC
module TitleDirection
  #                        ◆ Start Title BGM Timing ◆
  # This allows you to adjust when the title screen BGM is played.
  #   0..Before Logo  1..After Logo
  BGM_TIMING = 1

  #                 ◆ Show Logo During Testplay (DEBUGGING) ◆
  # This toggle allows you to bypass the logo display when debugging.
  TESTPLAY_SHOW = true
  
  #                         ◆ Splash Logo Image ◆
  #  Here, you may specify the image file you'd like to use as a logo.
  # The image must be in the "Graphics/Pictures" folder.
  # Setting this to nil will display nothing. If set to nil, the Splash Logo 
  #  Sound Effect defined below is also assumed to be nil.
  SPLASH_LOGO_FILE = "logo"
  
  #                       ◆ Splash Logo Sound Effect ◆
  # Here, you may specify a sound effect to play while the splash logo displays.
  # This can be written two ways. First, you can simply define a filename and
  #  the script automatically assumes to look in the SE folder and assign 
  #  default values for volume and pitch, as such:   
  #     SPLASH_LOGO_SE = "start_logo"
  #  Or class notation, allowing for additional customization, as such:
  #   SPLASH_LOGO_SE = RPG::SE.new("start_logo", 80, 100)
  # Format: ("SoundName", Volume, Pitch)
  SPLASH_LOGO_SE = RPG::SE.new("Decision2", 60, 50)
  
  #                           ◆ Logo Splash Style ◆
  #  Here, you may specify an effect for your logo. It's best just to try out
  # each option and see what works for you.
  #   0..Fade  1..Crossing  2..Zoom  3..Splash
  SPLASH_LOGO_TYPE = 0
  end
end
#=============================================================================#
#                          ★ End Customization ★                              #
#=============================================================================#

#=================================================#
#                    IMPORT                       #
#=================================================#

$imported = {} if $imported == nil
$imported["TitleDirection"] = true

#=================================================#

#==============================================================================
# □ Sprite_TitleLogo
#------------------------------------------------------------------------------
#   タイトル画面のロゴを扱うクラスです。
#==============================================================================

class Sprite_TitleLogo < Sprite
  attr_accessor :effect_no_out  # 消去エフェクトなし
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize
    super
    @effect_type = 0
    @effect_duration = 0
    @effect_sprites = []
    @effect_no_out = false
  end
  #--------------------------------------------------------------------------
  # ● 破棄
  #--------------------------------------------------------------------------
  def dispose
    super
    dispose_effect_sprites
  end
  #--------------------------------------------------------------------------
  # ○ エフェクト用スプライト破棄
  #--------------------------------------------------------------------------
  def dispose_effect_sprites
    @effect_sprites.each { |s| s.dispose }
    @effect_sprites = []
  end
  #--------------------------------------------------------------------------
  # ● Z 座標変更
  #--------------------------------------------------------------------------
  def z=(value)
    super(value)
    @effect_sprites.each { |s| s.z = value }
  end
  #--------------------------------------------------------------------------
  # ○ フェード効果
  #     dx : X 座標
  #     dy : Y 座標
  #     bitmap : 表示画像
  #--------------------------------------------------------------------------
  def effect_fade(dx, dy, bitmap)
    dispose_effect_sprites
    @effect_type = 0
    @effect_duration = 150
    # スプライト作成
    sprite = Sprite.new
    sprite.bitmap = bitmap
    # 表示位置を調整
    sprite.x = dx
    sprite.y = dy
    sprite.ox = bitmap.width / 2
    sprite.oy = bitmap.height / 2
    sprite.opacity = 0

    @effect_sprites << sprite
  end
  #--------------------------------------------------------------------------
  # ○ クロス効果
  #--------------------------------------------------------------------------
  def effect_cross(dx, dy, bitmap)
    dispose_effect_sprites
    @effect_type = 1
    @effect_duration = 150
    # スプライト作成
    sprites = [Sprite.new, Sprite.new]
    sprites[0].bitmap = bitmap
    sprites[1].bitmap = bitmap
    # 表示位置を調整
    sprites[0].x = dx - 240
    sprites[1].x = dx + 240
    sprites[0].y = dy
    sprites[1].y = dy
    sprites[0].ox = sprites[1].ox = bitmap.width / 2
    sprites[0].oy = sprites[1].oy = bitmap.height / 2
    sprites[0].opacity = 0
    sprites[1].opacity = 0

    @effect_sprites += sprites
  end
  #--------------------------------------------------------------------------
  # ○ ズーム効果
  #--------------------------------------------------------------------------
  def effect_zoom(dx, dy, bitmap)
    dispose_effect_sprites
    @effect_type = 2
    @effect_duration = 150
    # スプライト作成
    sprites = [Sprite.new, Sprite.new]
    sprites[0].bitmap = bitmap
    sprites[1].bitmap = bitmap
    # 初期設定
    sprites[0].x = sprites[1].x = dx
    sprites[0].y = sprites[1].y = dy
    sprites[0].ox = sprites[1].ox = bitmap.width / 2
    sprites[0].oy = sprites[1].oy = bitmap.height / 2
    sprites[0].zoom_x = sprites[0].zoom_y = 0.0
    sprites[1].zoom_x = sprites[1].zoom_y = 6.0
    sprites[0].opacity = sprites[1].opacity = 0

    @effect_sprites += sprites
  end
  #--------------------------------------------------------------------------
  # ○ スプラッシュ効果
  #--------------------------------------------------------------------------
  def effect_splash(dx, dy, bitmap)
    dispose_effect_sprites
    @effect_type = 3
    @effect_duration = 150
    # スプライト作成
    sprites = [Sprite.new]
    sprites[0].bitmap = bitmap
    # 初期設定
    sprites[0].ox = bitmap.width >> 1
    sprites[0].oy = bitmap.height >> 1
    sprites[0].x = dx
    sprites[0].y = dy
    sprites[0].opacity = 0
    (1..3).each { |i|
      sprites[i] = Sprite.new
      sprites[i].bitmap = bitmap
      sprites[i].ox = sprites[0].ox
      sprites[i].oy = sprites[0].oy
      sprites[i].x = dx
      sprites[i].y = dy
      sprites[i].opacity = 255
      sprites[i].visible = false
    }

    @effect_sprites += sprites
  end
  #--------------------------------------------------------------------------
  # ○ スプラッシュイン効果
  #--------------------------------------------------------------------------
  def effect_splash_in(dx, dy, bitmap)
    dispose_effect_sprites
    @effect_type = 4
    @effect_duration = 41
    # スプライト作成
    sprites = [Sprite.new]
    sprites[0].bitmap = bitmap
    # 初期設定
    sprites[0].ox = bitmap.width >> 1
    sprites[0].oy = bitmap.height >> 1
    sprites[0].x = dx - 160
    sprites[0].y = dy - 160
    sprites[0].opacity = 0
    (1..3).each { |i|
      sprites[i] = Sprite.new
      sprites[i].bitmap = bitmap
      sprites[i].ox = sprites[0].ox
      sprites[i].oy = sprites[0].oy
      sprites[i].x = dx
      sprites[i].y = dy
      sprites[i].opacity = 0
    }
    sprites[1].x += 160
    sprites[1].y -= 160
    sprites[2].x += 160
    sprites[2].y += 160
    sprites[3].x -= 160
    sprites[3].y += 160

    @effect_sprites += sprites
  end
  #--------------------------------------------------------------------------
  # ○ エフェクト停止
  #--------------------------------------------------------------------------
  def stop_effect
    dispose_effect_sprites
    @effect_duration = 0
  end
  #--------------------------------------------------------------------------
  # ○ エフェクト実行中判定
  #--------------------------------------------------------------------------
  def effect?
    return @effect_duration > 0
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  def update
    super

    if @effect_duration > 0
      update_effect
    end
  end
  #--------------------------------------------------------------------------
  # ○ エフェクト更新
  #--------------------------------------------------------------------------
  def update_effect
    @effect_duration -= 1
    case @effect_type
    when 0
      update_effect_fade
    when 1
      update_effect_cross
    when 2
      update_effect_zoom
    when 3
      update_effect_splash
    when 4
      update_effect_splash_in
    end
  end
  #--------------------------------------------------------------------------
  # ○ エフェクト更新 : フェード
  #--------------------------------------------------------------------------
  def update_effect_fade
    case @effect_duration
    when 100...150
      @effect_sprites[0].opacity += 6
    when 30...100
      # 何もしない
    when 0...30
      unless @effect_no_out
        @effect_sprites[0].opacity -= 10
      end
    end
  end
  #--------------------------------------------------------------------------
  # ○ エフェクト更新 : クロス
  #--------------------------------------------------------------------------
  def update_effect_cross
    case @effect_duration
    when 110...150
      @effect_sprites[0].x += 6
      @effect_sprites[1].x -= 6
      @effect_sprites[0].opacity += 4
      @effect_sprites[1].opacity += 4
    when 30...110
      @effect_sprites[0].opacity = 255
      @effect_sprites[1].visible = false
    when 0...30
      unless @effect_no_out
        @effect_sprites[0].opacity -= 13
      end
    end
  end
  #--------------------------------------------------------------------------
  # ○ エフェクト更新 : ズーム
  #--------------------------------------------------------------------------
  def update_effect_zoom
    case @effect_duration
    when 100...150
      @effect_sprites[0].zoom_x = (@effect_sprites[0].zoom_y += 0.02)
      @effect_sprites[1].zoom_x = (@effect_sprites[1].zoom_y -= 0.1)
      @effect_sprites[0].opacity += 3
      @effect_sprites[1].opacity += 3
    when 30...100
      @effect_sprites[0].opacity = 255
      @effect_sprites[1].visible = false
    when 0...30
      unless @effect_no_out
        @effect_sprites[0].opacity -= 13
      end
    end
  end
  #--------------------------------------------------------------------------
  # ○ エフェクト更新 : スプラッシュ
  #--------------------------------------------------------------------------
  def update_effect_splash
    case @effect_duration
    when 90...150
      @effect_sprites[0].opacity += 5
    when 0...60
      @effect_sprites[0].x -= 2
      @effect_sprites[0].y -= 2
      @effect_sprites[1].x += 2
      @effect_sprites[1].y -= 2
      @effect_sprites[2].x += 2
      @effect_sprites[2].y += 2
      @effect_sprites[3].x -= 2
      @effect_sprites[3].y += 2
      4.times { |j|
        @effect_sprites[j].visible = true
        @effect_sprites[j].opacity -= 5
      }
    end
  end
  #--------------------------------------------------------------------------
  # ○ エフェクト更新 : スプラッシュイン
  #--------------------------------------------------------------------------
  def update_effect_splash_in
    case @effect_duration
    when 1...41
      @effect_sprites[0].x += 2
      @effect_sprites[0].y += 2
      @effect_sprites[1].x -= 2
      @effect_sprites[1].y += 2
      @effect_sprites[2].x -= 2
      @effect_sprites[2].y -= 2
      @effect_sprites[3].x += 2
      @effect_sprites[3].y -= 2
      4.times { |j|
        @effect_sprites[j].opacity += 3
      }
    when 0
      @effect_sprites[0].opacity = 255
      (1..3).each { |i|
        @effect_sprites[i].visible = false
      }
    end
  end
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# ■ Scene_Title
#==============================================================================

class Scene_Title < Scene_Base
  #--------------------------------------------------------------------------
  # ● 開始処理
  #--------------------------------------------------------------------------
  alias start_KGC_TitleDirection start
  def start
    show_splash_logo

    start_KGC_TitleDirection
  end
  #--------------------------------------------------------------------------
  # ○ スプラッシュロゴ表示
  #--------------------------------------------------------------------------
  def show_splash_logo
    return if $__splash_logo_shown
    return if $TEST && !KGC::TitleDirection::TESTPLAY_SHOW
    return if KGC::TitleDirection::SPLASH_LOGO_FILE == nil

    play_title_music if KGC::TitleDirection::BGM_TIMING == 0

    # ロゴ表示 SE 演奏
    if KGC::TitleDirection::SPLASH_LOGO_SE != nil
      if KGC::TitleDirection::SPLASH_LOGO_SE.is_a?(RPG::SE)
        KGC::TitleDirection::SPLASH_LOGO_SE.play
      elsif KGC::TitleDirection::SPLASH_LOGO_SE.is_a?(String)
        se = RPG::SE.new(KGC::TitleDirection::SPLASH_LOGO_SE)
        se.play
      end
    end

    # エフェクト用スプライト作成
    sprite = Sprite_TitleLogo.new
    bitmap = Cache.picture(KGC::TitleDirection::SPLASH_LOGO_FILE)
    dx = Graphics.width / 2
    dy = Graphics.height / 2

    # エフェクト準備
    case KGC::TitleDirection::SPLASH_LOGO_TYPE
    when 0
      sprite.effect_fade(dx, dy, bitmap)
    when 1
      sprite.effect_cross(dx, dy, bitmap)
    when 2
      sprite.effect_zoom(dx, dy, bitmap)
    when 3
      sprite.effect_splash(dx, dy, bitmap)
    end
    # エフェクト実行
    Graphics.transition(0)
    while sprite.effect?
      Graphics.update
      Input.update
      sprite.update
      # C ボタンで中止
      if Input.trigger?(Input::C)
        sprite.stop_effect
      end
    end
    # 後始末
    sprite.dispose
    bitmap.dispose
    # トランジション準備
    Graphics.freeze

    $__splash_logo_shown = true
  end
end
