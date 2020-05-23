#_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_
#_/    ◆              Day-to-Night Phases - KGC_DayNight                ◆ VX ◆
#_/    ◇                   Last update : 2008/03/08                          ◇
#_/    ◆                  Translated by Mr. Anonymous                        ◆
#_/-----------------------------------------------------------------------------
#_/  This script adds the concept of Day-to-Night phase shifting to your game.
#_/   Events that only occur during certain phase shifts, such as night, can
#_/   be created as well.
#_/=============================================================================
#_/  Note: The event command "Tint Screen" doesn't function normally while this 
#_/   script is running a phase shift. To use the Tint Screen function properly,
#_/   please refer to the directions.
#_/=============================================================================
#_/ Installation: Insert above Main.
#_/-----------------------------------------------------------------------------
#_/  Terminology: Phase refers to the current state of the day, such as "Noon".
#_/                         ◆ Instructions For Usage ◆
#_/  
#_/                           ◆ Stop Day-to-Night ◆
#_/  When [DN_STOP] is inserted into a Map's name (after its given name), the
#_/  Day-to-Night change stops, the timer does not stop however, and if a phase
#_/  is currently active, such as "Night", the tint remains on the map.
#_/  
#_/                 ◆ Stop Day-to-Night and Time, Cancel Phase ◆
#_/  
#_/  When [DN_VOID] is inserted into a Map's name (after its given name), the
#_/  Day-to-Night change stops, the timer is effectively frozen, and if a phase
#_/  is currently active, such as "Night", the tint is reverted back to normal.
#_/  
#_/                       ◆ Phase-Specific Encounters ◆
#_/  
#_/  When [DN Phase#](Where Phase# refers to the phase. 0 = Noon, 1 = Evening,
#_/   2 = Night, 3 = Morning) is inserted into a specified Troop's "Notes" box 
#_/   in the Troops tab of the database, the specified Troop will only appear
#_/   under those conditions.
#_/  
#_/                         ◆ Event Script Functions ◆
#_/  The following commands are available using the "Script" item in events.
#_/  
#_/  * stop_daynight
#_/     Day to Night change is stopped.
#_/  
#_/  * start_daynight
#_/     Day to Night change is started.
#_/  
#_/  * get_daynight_name 
#_/     Name of present phase is acquired. This function only works in other
#_/      scripts.
#_/  
#_/  * get_daynight_week (variable_id)
#_/     Appoints the day of the week to the given variable.
#_/  
#_/  * get_daynight_week_name
#_/     Name of the present day is aquired. This function only works in other
#_/      scripts.
#_/  
#_/  * change_daynight_phase(phase, duration, pass_days)
#_/     Changes the current phase to a new one. Handy for Inns and the like.
#_/     Example: change_daynight_phase (3, 1, 1)
#_/       This would make one day pass, change the phase to morning, with a
#_/       duration of one frame. Duration must be set to a minimum of 1.
#_/  
#_/   * transit_daynight_phase(duration)
#_/      Forces the phase to change at the very moment you call this.
#_/       This appears to be bugged. No matter how I've called it, I get errors.
#_/  
#_/   * set_daynight_default(duration)
#_/      Forces the tint of the current phase to reset to the initial phase.
#_/  
#_/   * restore_daynight_phase(duration)
#_/      Forces the tint of the current phase to reset to its normal tint.
#_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_

#==============================================================================#
#                              ★ Customization ★                               #
#==============================================================================#

module KGC
 module DayNight
  #                      ◆ Day to Night Switch Method ◆
  #  0. Time Lapse  1.Time passes with number of steps  2.Real Time
  METHOD = 2

  #                           ◆ Phase Variable ◆
  # The present phase (of day and night) is stored here.
  PHASE_VARIABLE = 19
  
  #                     ◆ Passing Days Storage Variable ◆
  #  The passing days is stored here.
  PASS_DAYS_VARIABLE = 20

  #                         ◆ Stop On Event Toggle ◆ 
  #  Stops the Day/Night Timer when an event is run by player.
  STOP_ON_EVENT = false
  
  #                         ◆ Phases During Combat ◆
  #  true = Only the battleback is tinted.
  #  false = Battleback and enemies are tinted.
  TONE_BACK_ONLY_IN_BATTLE = true

  #                       ◆ Setting Individual Phases ◆
  #  Each phase makes use of the Tint Screen function. The format as follows:
  #   ["Name", the color tone(Tint), time switch],
  #
  #  [Name]
  #    Name of Phase
  #    *The name holds no significance.
  #  [Tint]
  #    The color tone of the entire screen.
  #    Please don't alter this if you don't grasp color tints.
  #  [Time Shift]
  #    The amount of steps taken until the next phase shift occurs.
  #    The following set up is for step-time change. (METHOD = 1) 
  PHASE = [
    ["Noon",   Tone.new(   0,    0,   0), 300],     # Phase 0
    ["Evening", Tone.new( -32,  -96, -96), 100],    # Phase 1
    ["Night",   Tone.new(-128, -128, -32), 250],    # Phase 2
    ["Morning",   Tone.new( -48,  -48, -16), 100],  # Phase 3
  ] 

  #                          ◆ Real Time Setup ◆
  # Replace the values in the about phase set-up if you wish to use real-time.
  #  ["Noon",   Tone.new(  0,   0,   0), 16],     #Phase0 (16 o'clock [4:00PM])
  #  ["Evening", Tone.new(  0, -96, -96), 20],    #Phase1 (20 o'clock [8:00PM])
  #  ["Night",   Tone.new(-96, -96, -64),  6],    #Phase2 (6 o'clock [6:00AM])
  #  ["Morning",   Tone.new(-48, -48, -16), 10],  #Phase3 (10 o'clock [10:00AM])

  #                            ◆ Day Change ◆
  #  The day changes on the value set here.
  #   0.Day  1.Evening  2.Night  3.Morning
  PASS_DAY_PHASE = 3

  #                        ◆ Fade Time (by frame) ◆
  #  The amount of frames it takes to fade into the next phase.
  PHASE_DURATION = 1800

  #                        ◆ Day of the Week Names ◆
  #  This shouldn't be hard to figure out, I hope.
  #  When using the Real-Time method (= 2), this must be seven days.
  #  Values of these are 0, 1, 2, 3, 4, 5, 6
  WEEK_NAME = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
 end
end

#------------------------------------------------------------------------------#

$imported = {} if $imported == nil
$imported["DayNight"] = true

if $data_mapinfos == nil
  $data_mapinfos = load_data("Data/MapInfos.rvdata")
end

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #
#  Unless you know what you're doing, it's best not to alter anything beyond  #
#  this point, as this only affects the tags used for the Map name.           #
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

module KGC::DayNight
  METHOD_TIME  = 0  # Time Lapse
  METHOD_STEP  = 1  # Time passes with number of steps
  METHOD_RTIME = 2  # Real Time
  
#  Whatever word(s) in the following lines are what are used to determine 
#  what is searched for in the Map Name or the "Notes" section of the database.

  # Regular Expression Defined
  module Regexp
    # Base MapInfo Module
    module MapInfo
      # Day/Night Stop tag string
      DAYNIGHT_STOP = /\[DN_STOP\]/i
      # Day/Night Void tag string
      DAYNIGHT_VOID = /\[DN_VOID\]/i
    end

    # Base Troop Module
    module Troop
      # Appearance Phase tag string
      APPEAR_PHASE = /\[DN((?:[ ]*[\-]?\d+(?:[ ]*,)?)+)\]/i
    end
  end

  #--------------------------------------------------------------------------
  # ○ 敵グループ出現判定
  #     troop : 判定対象の敵グループ
  #     phase : 判定するフェーズ
  #--------------------------------------------------------------------------
  def self.troop_appear?(troop, phase = $game_system.daynight_phase)
    # 出現判定
    unless troop.appear_daynight_phase.empty?
      return false unless troop.appear_daynight_phase.include?(phase)
    end
    # 非出現判定
    unless troop.nonappear_daynight_phase.empty?
      return false if troop.nonappear_daynight_phase.include?(phase)
    end

    return true
  end
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# □ KGC::Commands
#==============================================================================

module KGC::Commands
  module_function
  #--------------------------------------------------------------------------
  # ○ 昼夜切り替えを停止
  #--------------------------------------------------------------------------
  def stop_daynight
    $game_system.daynight_change_enabled = false
  end
  #--------------------------------------------------------------------------
  # ○ 昼夜切り替えを起動
  #--------------------------------------------------------------------------
  def start_daynight
    $game_system.daynight_change_enabled = true
  end
  #--------------------------------------------------------------------------
  # ○ Preset Phase is aquired.
  #--------------------------------------------------------------------------
  def get_daynight_name
    return KGC::DayNight::PHASE[get_daynight_phase][0]
  end
  #--------------------------------------------------------------------------
  # ○ Obtain DayNight Week and store it in a variable.
  #     variable_id : Variable ID
  #--------------------------------------------------------------------------
  def get_daynight_week(variable_id = 0)
    if KGC::DayNight::METHOD == KGC::DayNight::METHOD_RTIME
      week = Time.now.wday
    else
      days = $game_variables[KGC::DayNight::PASS_DAYS_VARIABLE]
      week = (days % KGC::DayNight::WEEK_NAME.size)
    end

    if variable_id > 0
      $game_variables[variable_id] = week
    end
   return week
  end
  #--------------------------------------------------------------------------
  # ○ Present Day of the Week is aquired.
  #--------------------------------------------------------------------------
  def get_daynight_week_name
    return KGC::DayNight::WEEK_NAME[get_daynight_week]
  end
  #--------------------------------------------------------------------------
  # ○ Phase Shift
  #     phase     : Phase
  #     duration  : Shift Time(In Frames)
  #     pass_days : Passing Days  (When argument is omitted: 0)
  #--------------------------------------------------------------------------
  def change_daynight_phase(phase,
      duration = KGC::DayNight::PHASE_DURATION,
      pass_days = 0)
    $game_temp.manual_daynight_duration = duration
    $game_system.daynight_counter = 0
    $game_system.daynight_phase = phase
    $game_variables[KGC::DayNight::PASS_DAYS_VARIABLE] += pass_days
    $game_map.need_refresh = true
  end
  #--------------------------------------------------------------------------
  # ○ Transit Daynight Phase
  #     duration : Shift Time(In Frames)
  #--------------------------------------------------------------------------
  def transit_daynight_phase(duration = KGC::DayNight::PHASE_DURATION)
    $game_screen.transit_daynight_phase(duration)
    $game_map.need_refresh = true
  end
  #--------------------------------------------------------------------------
  # ○ デフォルトの色調に戻す
  #     duration : 切り替え時間(フレーム)
  #--------------------------------------------------------------------------
  def set_daynight_default(duration = KGC::DayNight::PHASE_DURATION)
    $game_screen.set_daynight_default(duration)
    $game_map.need_refresh = true
  end
  #--------------------------------------------------------------------------
  # ○ 現在のフェーズを復元
  #     duration : 切り替え時間(フレーム)
  #--------------------------------------------------------------------------
  def restore_daynight_phase(duration = KGC::DayNight::PHASE_DURATION)
    $game_screen.restore_daynight_phase(duration)
    $game_map.need_refresh = true
  end
end

class Game_Interpreter
  include KGC::Commands
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

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
  # ○ 昼夜切り替え停止
  #--------------------------------------------------------------------------
  def daynight_stop
    return @name =~ KGC::DayNight::Regexp::MapInfo::DAYNIGHT_STOP
  end
  #--------------------------------------------------------------------------
  # ○ 昼夜エフェクト無効
  #--------------------------------------------------------------------------
  def daynight_void
    return @name =~ KGC::DayNight::Regexp::MapInfo::DAYNIGHT_VOID
  end
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# ■ RPG::Area
#==============================================================================

unless $@
class RPG::Area
  #--------------------------------------------------------------------------
  # ○ エンカウントリストの取得
  #--------------------------------------------------------------------------
  alias encounter_list_KGC_DayNight encounter_list
  def encounter_list
    list = encounter_list_KGC_DayNight.clone

    # 出現条件判定
    list.each_index { |i|
      list[i] = nil unless KGC::DayNight.troop_appear?($data_troops[list[i]])
    }
    return list.compact
  end
end
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# ■ RPG::Troop
#==============================================================================

class RPG::Troop
  #--------------------------------------------------------------------------
  # ○ Generate DayNight Cache
  #--------------------------------------------------------------------------
  def create_daynight_cache
    @__appear_daynight_phase = []
    @__nonappear_daynight_phase = []

    # 出現するフェーズ
    if @name =~ KGC::DayNight::Regexp::Troop::APPEAR_PHASE
      $1.scan(/[\-]?\d+/).each { |num|
        phase = num.to_i
        if phase < 0
          # 出現しない
          @__nonappear_daynight_phase << phase.abs
        else
          # 出現する
          @__appear_daynight_phase << phase
        end
      }
    end
  end
  #--------------------------------------------------------------------------
  # ○ 出現するフェーズ
  #--------------------------------------------------------------------------
  def appear_daynight_phase
    create_daynight_cache if @__appear_daynight_phase == nil
    return @__appear_daynight_phase
  end
  #--------------------------------------------------------------------------
  # ○ 出現しないフェーズ
  #--------------------------------------------------------------------------
  def nonappear_daynight_phase
    create_daynight_cache if @__nonappear_daynight_phase == nil
    return @__nonappear_daynight_phase
  end
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# ■ Game_Temp
#==============================================================================

class Game_Temp
  #--------------------------------------------------------------------------
  # ● 公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_accessor :manual_daynight_duration # 手動フェーズ変更フラグ
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  alias initialize_KGC_DayNight initialize
  def initialize
    initialize_KGC_DayNight

    @manual_daynight_duration = nil
  end
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# ■ Game_System
#==============================================================================

class Game_System
  #--------------------------------------------------------------------------
  # ● 公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_writer   :daynight_counter         # フェーズ遷移カウンタ
  attr_writer   :daynight_change_enabled  # 昼夜切り替え有効
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  alias initialize_KGC_DayNight initialize
  def initialize
    initialize_KGC_DayNight

    @daynight_counter = 0
    @daynight_change_enabled = true
  end
  #--------------------------------------------------------------------------
  # ○ フェーズ遷移カウンタを取得
  #--------------------------------------------------------------------------
  def daynight_counter
    @daynight_counter = 0 if @daynight_counter == nil
    return @daynight_counter
  end
  #--------------------------------------------------------------------------
  # ○ 現在のフェーズを取得
  #--------------------------------------------------------------------------
  def daynight_phase
    return $game_variables[KGC::DayNight::PHASE_VARIABLE]
  end
  #--------------------------------------------------------------------------
  # ○ 現在のフェーズを変更
  #--------------------------------------------------------------------------
  def daynight_phase=(value)
    $game_variables[KGC::DayNight::PHASE_VARIABLE] = value
  end
  #--------------------------------------------------------------------------
  # ○ 昼夜切り替え有効フラグを取得
  #--------------------------------------------------------------------------
  def daynight_change_enabled
    @daynight_change_enabled = 0 if @daynight_change_enabled == nil
    return @daynight_change_enabled
  end
  #--------------------------------------------------------------------------
  # ○ フェーズ進行
  #--------------------------------------------------------------------------
  def progress_daynight_phase
    self.daynight_phase += 1
    if self.daynight_phase >= KGC::DayNight::PHASE.size
      self.daynight_phase = 0
    end
    $game_map.need_refresh = true
  end
  #--------------------------------------------------------------------------
  # ○ 現在のフェーズオブジェクトを取得
  #--------------------------------------------------------------------------
  def daynight_phase_object
    return KGC::DayNight::PHASE[daynight_phase]
  end
  #--------------------------------------------------------------------------
  # ○ 以前のフェーズオブジェクトを取得
  #--------------------------------------------------------------------------
  def previous_daynight_phase_object
    return KGC::DayNight::PHASE[daynight_phase - 1]
  end
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# ■ Game_Screen
#==============================================================================

class Game_Screen
  #--------------------------------------------------------------------------
  # ● 公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_reader   :daynight_tone            # 昼夜の色調
  #--------------------------------------------------------------------------
  # ● クリア
  #--------------------------------------------------------------------------
  alias clear_KGC_DayNight clear
  def clear
    clear_KGC_DayNight

    clear_daynight
  end
  #--------------------------------------------------------------------------
  # ○ 昼夜切り替え用変数をクリア
  #--------------------------------------------------------------------------
  def clear_daynight
    @default_tone = Tone.new(0, 0, 0)

    # 移動判定用座標初期化
    @daynight_x = 0
    @daynight_y = 0

    # フレーム更新用カウント初期化
    @frame_count = Graphics.frame_count
    @daynight_tone_duration = 0

    apply_daynight
  end
  #--------------------------------------------------------------------------
  # ○ 昼夜の色調を適用
  #--------------------------------------------------------------------------
  def apply_daynight
    return if $game_map == nil

    # 切り替えを無効化するマップの場合
    if $game_map.daynight_void?
      if @daynight_tone_changed
        # 初期の色調に戻す
        @tone = @default_tone.clone
        @daynight_tone_changed = false
      end
      @daynight_tone = @tone.clone
      return
    end

    # フェーズがおかしければ修復
    if $game_system.daynight_phase_object == nil
      $game_system.daynight_phase = 0
    end

    # 現在の色調を適用
    @tone = $game_system.daynight_phase_object[1].clone
    @daynight_tone = @tone.clone

    # 現実時間遷移の場合
    if KGC::DayNight::METHOD == KGC::DayNight::METHOD_RTIME
      time = Time.now
      # マッチするフェーズに遷移
      KGC::DayNight::PHASE.each_with_index { |phase, i|
        if phase[2] <= time.hour
          start_tone_change(phase[1], 1)
          $game_system.daynight_phase = i
          break
        end
      }
    end

    @daynight_tone_changed = true
  end
  #--------------------------------------------------------------------------
  # ○ 色調の取得
  #--------------------------------------------------------------------------
  def tone
    if $game_temp.in_battle && KGC::DayNight::TONE_BACK_ONLY_IN_BATTLE
      return @default_tone
    else
      return @tone
    end
  end
  #--------------------------------------------------------------------------
  # ● 色調変更の開始
  #     tone     : 色調
  #     duration : 時間
  #--------------------------------------------------------------------------
  alias start_tone_change_KGC_DayNight start_tone_change
  def start_tone_change(tone, duration)
    duration = [duration, 1].max
    start_tone_change_KGC_DayNight(tone, duration)

    @daynight_tone_target = tone.clone
    @daynight_tone_duration = duration
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  alias update_KGC_DayNight update
  def update
    update_KGC_DayNight

    update_daynight_transit
  end
  #--------------------------------------------------------------------------
  # ● 色調の更新
  #--------------------------------------------------------------------------
  alias update_tone_KGC_DayNight update_tone
  def update_tone
    update_tone_KGC_DayNight

    if @daynight_tone_duration >= 1
      d = @daynight_tone_duration
      target = @daynight_tone_target
      @daynight_tone.red = (@daynight_tone.red * (d - 1) + target.red) / d
      @daynight_tone.green = (@daynight_tone.green * (d - 1) + target.green) / d
      @daynight_tone.blue = (@daynight_tone.blue * (d - 1) + target.blue) / d
      @daynight_tone.gray = (@daynight_tone.gray * (d - 1) + target.gray) / d
      @daynight_tone_duration -= 1
    end
  end
  #--------------------------------------------------------------------------
  # ○ フェーズ遷移の更新
  #--------------------------------------------------------------------------
  def update_daynight_transit
    # 手動切り替えが行われた場合
    if $game_temp.manual_daynight_duration
      start_tone_change($game_system.daynight_phase_object[1],
        $game_temp.manual_daynight_duration)
      $game_temp.manual_daynight_duration = nil
      @daynight_tone_changed = true
    end

    return unless $game_system.daynight_change_enabled  # 切り替えを
    return if $game_map.daynight_stop?                  # 停止中

    if KGC::DayNight::STOP_ON_EVENT
      interpreter = ($game_temp.in_battle ? $game_troop.interpreter :
        $game_map.interpreter)
      return if interpreter.running?                    # イベント実行中
    end

    case KGC::DayNight::METHOD
    when KGC::DayNight::METHOD_TIME   # 時間
      update_daynight_pass_time
    when KGC::DayNight::METHOD_STEP   # 歩数
      update_daynight_step
    when KGC::DayNight::METHOD_RTIME  # 現実時間
      update_daynight_real_time
    end
  end
  #--------------------------------------------------------------------------
  # ○ 遷移 : 時間経過
  #--------------------------------------------------------------------------
  def update_daynight_pass_time
    # カウント増加量計算
    inc_count = Graphics.frame_count - @frame_count
    # 加算量がおかしい場合は戻る
    if inc_count >= 100
      @frame_count = Graphics.frame_count
      return
    end
    # カウント加算
    $game_system.daynight_counter += inc_count
    @frame_count = Graphics.frame_count

    # 状態遷移判定
    count = $game_system.daynight_counter / Graphics.frame_rate
    if count >= $game_system.daynight_phase_object[2]
      transit_daynight_next
    end
  end
  #--------------------------------------------------------------------------
  # ○ 遷移 : 歩数
  #--------------------------------------------------------------------------
  def update_daynight_step
    # 移動していなければ戻る
    return if @daynight_x == $game_player.x && @daynight_y == $game_player.y

    @daynight_x = $game_player.x
    @daynight_y = $game_player.y
    # カウント加算
    $game_system.daynight_counter += 1
    # 状態遷移判定
    count = $game_system.daynight_counter
    if count >= $game_system.daynight_phase_object[2]
      transit_daynight_next
    end
  end
  #--------------------------------------------------------------------------
  # ○ 遷移 : 現実時間
  #--------------------------------------------------------------------------
  def update_daynight_real_time
    time = Time.now
    # 状態遷移判定
    time1 = $game_system.daynight_phase_object[2]
    transit = (time1 <= time.hour)
    if $game_system.previous_daynight_phase_object != nil
      time2 = $game_system.previous_daynight_phase_object[2]
      if time1 < time2
        transit &= (time.hour < time2)
      end
    end

    if transit
      transit_daynight_next
    end
  end
  #--------------------------------------------------------------------------
  # ○ 次の状態へ遷移
  #     duration : 遷移時間
  #--------------------------------------------------------------------------
  def transit_daynight_next(duration = KGC::DayNight::PHASE_DURATION)
    $game_system.daynight_counter = 0
    $game_system.progress_daynight_phase
    # 日数経過判定
    if $game_system.daynight_phase == KGC::DayNight::PASS_DAY_PHASE
      $game_variables[KGC::DayNight::PASS_DAYS_VARIABLE] += 1
    end
    # 色調切り替え
    start_tone_change($game_system.daynight_phase_object[1], duration)
    @daynight_tone_changed = true
  end
  #--------------------------------------------------------------------------
  # ○ デフォルトの状態(0, 0, 0)に戻す
  #     duration : 遷移時間
  #--------------------------------------------------------------------------
  def set_daynight_default(duration)
    start_tone_change(@default_tone, duration)
  end
  #--------------------------------------------------------------------------
  # ○ 現在のフェーズを復元
  #     duration : 遷移時間
  #--------------------------------------------------------------------------
  def restore_daynight_phase(duration)
    start_tone_change($game_system.daynight_phase_object[1], duration)
    @daynight_tone_changed = true
  end
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# ■ Game_Map
#==============================================================================

class Game_Map
  #--------------------------------------------------------------------------
  # ● セットアップ
  #     map_id : マップ ID
  #--------------------------------------------------------------------------
  alias setup_KGC_DayNight setup
  def setup(map_id)
    setup_KGC_DayNight(map_id)

    @screen.apply_daynight
  end
  #--------------------------------------------------------------------------
  # ○ 昼夜切り替えを停止するか
  #--------------------------------------------------------------------------
  def daynight_stop?
    info = $data_mapinfos[map_id]
    return false if info == nil
    return (info.daynight_stop || info.daynight_void)
  end
  #--------------------------------------------------------------------------
  # ○ 昼夜切り替えが無効か
  #--------------------------------------------------------------------------
  def daynight_void?
    info = $data_mapinfos[map_id]
    return false if info == nil
    return info.daynight_void
  end
  #--------------------------------------------------------------------------
  # ● エンカウントリストの取得
  #--------------------------------------------------------------------------
  alias encounter_list_KGC_DayNight encounter_list
  def encounter_list
    list = encounter_list_KGC_DayNight.clone

    # 出現条件判定
    list.each_index { |i|
      list[i] = nil unless KGC::DayNight.troop_appear?($data_troops[list[i]])
    }
    return list.compact
  end
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# ■ Spriteset_Battle
#==============================================================================

if KGC::DayNight::TONE_BACK_ONLY_IN_BATTLE
class Spriteset_Battle
  #--------------------------------------------------------------------------
  # ● バトルバックスプライトの作成
  #--------------------------------------------------------------------------
  alias create_battleback_KGC_DayNight create_battleback
  def create_battleback
    create_battleback_KGC_DayNight

    if @battleback_sprite.wave_amp == 0
      @battleback_sprite.tone = $game_troop.screen.daynight_tone
    end
  end
  #--------------------------------------------------------------------------
  # ● バトルフロアスプライトの作成
  #--------------------------------------------------------------------------
  alias create_battlefloor_KGC_DayNight create_battlefloor
  def create_battlefloor
    create_battlefloor_KGC_DayNight

    @battlefloor_sprite.tone = $game_troop.screen.daynight_tone
  end
end
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# ■ Scene_Map
#==============================================================================

class Scene_Map < Scene_Base
  #--------------------------------------------------------------------------
  # ● 開始処理
  #--------------------------------------------------------------------------
  alias start_KGC_DayNight start
  def start
    $game_map.screen.clear_daynight

    start_KGC_DayNight
  end
end

#_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_
#_/  The original untranslated version of this script can be found here:
# 
#_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_
