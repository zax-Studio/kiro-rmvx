#####################################
# Add on by Andres Rondon
#####################################
class Game_Actor < Game_Battler
  attr_reader     :actor_id
end

class Game_Character
  attr_reader   :is_walking

  def copy_from(character)
    # From RGSS2
    @id = character.id
    @x = character.x
    @y = character.y
    @real_x = character.real_x
    @real_y = character.real_y
    @tile_id = character.tile_id
    @character_name = character.character_name
    @character_index = character.character_index
    @opacity = character.opacity
    @blend_type = character.blend_type
    @direction = character.direction
    @pattern = character.pattern
    @move_route_forcing = character.move_route_forcing
    @priority_type = character.priority_type
    @through = character.through
    @bush_depth = character.bush_depth
    @animation_id = character.animation_id
    @balloon_id = character.balloon_id
    @transparent = character.transparent

    # From PR ABS
    @pre_dead = character.pre_dead
    @abs_animation = character.abs_animation
    @battler = character.battler
    @collapse = character.collapse
    @appear = character.appear
    @white_flash = character.white_flash
    @clear_sprite = character.clear_sprite
    @blink = character.blink
    @shielded = character.shielded
    @ch = character.ch
    @cw = character.cw
    @hud_balloon_id = character.hud_balloon_id
    @last_action_type = character.last_action_type
    @last_action = character.last_action
    @attacked_by = character.attacked_by

    # From PR - Damage_System
    @damages = character.damages
    @mp_damages = character.mp_damages
    @messages = character.messages
  end

  def move_on_top_of_player
    @real_x = $game_player.real_x
    @real_y = $game_player.real_y - 256
  end

  def turn_toward_char(character)
    sx = distance_x_from_char(character)
    sy = distance_y_from_char(character)
    if sx.abs > sy.abs                    # Horizontal distance is longer
      sx > 0 ? turn_left : turn_right
    elsif sx.abs < sy.abs                 # Vertical distance is longer
      sy > 0 ? turn_up : turn_down
    end
  end
end

class Game_Event < Game_Character
  attr_accessor :update_on_top_of_player

  alias_method :abs_ar_ge_initialize, :initialize
  def initialize(map_id, event)
    abs_ar_ge_initialize(map_id, event)
    @update_on_top_of_player = false
  end

  alias_method :abs_ar_ge_update, :update
  def update
    abs_ar_ge_update
    move_on_top_of_player if update_on_top_of_player
  end
end

class Game_Follower < Game_Character
  include PRABS::CONFIG::ANIMATION
  
  attr_reader   :is_inline
  attr_reader   :is_fighting
  
  def initialize
    @is_inline = true
    @is_fighting = false
    @is_walking = false
    @follower_combo = [false, 0, 1]
    @combo_max = 2
    @automove = true
    @automove_sight = 3
    @enemy_on_sight = false
    @autoattack = true
    @autoattack_type = 0
    @auto_wait = 0
  end
  
  def update
    return if @battler.nil?
    super
    if (@battler.dead?)
      set_dead()
      follow_leader
      return
    end
    if @enemy_on_sight
      return if follower_attack()
    end
    return if self.moving?
    if @auto_wait > 0
      @auto_wait -= 1
    elsif @autoattack_type == 1
      update_get_abs_target
      update_autoattack
      @autoattack_type = 0
      return
    else
      if @autoattack
        @autoattack_type = 1
      end
    end
    if @automove
      update_get_abs_target
      update_automove
    end

    if !@attacked_by.nil? || (@is_inline && !$game_player.attacked_by.nil?)
      attacker = @attacked_by
      attacker ||= $game_player.attacked_by
      if attacker.battler.nil? || attacker.battler.dead?
        if !@attacked_by.nil?
          @attacked_by = nil
        else
          $game_player.attacked_by = nil
        end
      elsif !@is_fighting
        move_toward_character(attacker)
        @is_fighting = true
      end
    end
  end

  # returning true means it finished the move
  # returning false means it will continue the remaining process in the update method
  def follower_attack
    enemy =  @abs_target.character
    if enemy.nil? || enemy.battler.nil? || enemy.battler.dead?
      @is_fighting = false
      return false
    end

    if (@autoattack && @follower_combo[0])
      if (@follower_combo[1] > 0)
        @follower_combo[1] -= 1
        return true
      end
      dx = (@real_x - enemy.real_x).abs
      dy = (@real_y - enemy.real_y).abs
      sequence = PRABS::HERO.get_sequence(@battler.id, @battler.weapon_id, 0)[0]
      offset_x = sequence.nil? ? nil : sequence[5]
      if dx + dy <= 256 + (offset_x.nil? ? 0 : offset_x * 256)
        target_attack(enemy, @follower_combo[2])
        if (rand(@combo_max * 2) <= (@combo_max - @follower_combo[2] + 1) && @follower_combo[2] < @combo_max)
          @follower_combo[1] = rand(10) + 10
          @follower_combo[2] += 1
        else
          @follower_combo = [false, 0, 1]
        end
        @abs_wait = 40 + (@follower_combo[2] * 15)
        return true
      end
    end

    if @abs_wait > 0
      @abs_wait -= 1
      return true
    end

    return false
  end

  def update_get_abs_target
    abs_targets = ABS_Targets.new
    for char in $game_map.screen_enemies.values
      unless (char.battler.nil? || char.battler.dead? || char.fake_enemy)
        abs_targets.push(ABS_Target.new(char, get_dist(char)))
      end
    end
    @abs_target = abs_targets.get_closest
    @abs_target ||= ABS_Target.new(nil, 99)
    @enemy_on_sight = @abs_target.distance <= @automove_sight
  end

  def update_automove
    if @enemy_on_sight
      sequence = PRABS::HERO.get_sequence(@battler.id, @battler.weapon_id, 0)[0]
      offset = sequence.nil? ? 0 : sequence[5]
      offset ||= 0
      move_toward_character(@abs_target.character, false, offset)
    elsif $game_party.following_leader && (!@is_inline || @is_fighting)
      follow_leader
    end
  end

  def update_autoattack
    if @enemy_on_sight
      use_autoattack(@abs_target.character)
    elsif $game_party.following_leader && !@is_inline
      follow_leader
    end
  end
  
  def use_autoattack(char)
    if char.nil? || char.battler.nil? || char.battler.dead?
      if $game_party.following_leader
        follow_leader
      end
      return
    end
    break_line
    @is_fighting = true
    dx = (@real_x - char.real_x).abs
    dy = (@real_y - char.real_y).abs
    sequence = PRABS::HERO.get_sequence(@battler.id, @battler.weapon_id, 0)[0]
    offset_x = sequence.nil? ? nil : sequence[5]
    if dx + dy <= 256 + (offset_x.nil? ? 0 : offset_x * 256)
      target_attack(char, @follower_combo[2])
      @abs_wait = 40
      if (rand(@combo_max * 2) <= @combo_max)
        @follower_combo = [true, rand(10) + 10, 2]
      else
        @follower_combo = [false, 0, 1]
      end
      @auto_wait = 40
    end
  end

  def target_attack(target, combo_index)
    return if target.battler.nil?

    data = PRABS::HERO.get_sequence(@battler.id, @battler.weapon_id, combo_index)
    # Randomness of attack sequence (FrontAttack,Circle)
    sequence = data[rand(data.length)]
    if !sequence.nil?
      if sequence[1] != 88 # 'Bow and arrow' skill
        animation_name = sequence[2]
        skill = $data_skills[sequence[1]]
        $game_map.setup_map_animation(skill.nil? ? 0 : skill.animation_id, target.x, target.y, @direction) 
        real_name = @character_name + "/" + animation_name
        frames = FRAMES[real_name]
        if (frames.nil?)
          real_name = @character_name
          frames = DEFAULT_FRAMES
        end
        @abs_animation.setup(real_name, frames, false, true, @character_index)
        attack(target, (DAMAGE_FRAME[real_name].nil? ? DEFAULT_DAMAGE_FRAME : DAMAGE_FRAME[real_name]))
      else # We can assume it's the 'Bow and arrow' skill
        turn_toward_char(target)
        if (use_skill($data_skills[sequence[1]], sequence[3], false))
          @abs_wait = setup_animation(sequence[2])
        end
      end
    else
      @abs_animation.setup(@character_name, DEFAULT_FRAMES, false, true, @character_index)
      attack(target, DEFAULT_DAMAGE_FRAME)
    end
  end
  
  def set_dead
    super
    @opacity = 0
    @battler = nil
    @attacked_by = nil
    @is_walking = false
    @is_fighting = false
    $game_map.need_refresh = true
  end

  def break_line
    @is_inline = false
  end

  def set_follow_line_variables
    @is_inline = true
    @is_fighting = false
    @attacked_by = nil
    @abs_target = ABS_Target.new(nil, 99)
  end

  def follow_leader
    number_in_line = $game_party.get_member_index(@actor)
    moves_finished = follow_line($game_player.x, $game_player.y, true, true, number_in_line)
    if moves_finished > 0
      set_follow_line_variables()
    end
  end

  def follow_line(x, y, walk = false, in_caterpillar_position = false, number_in_line = 0)
    nx = x
    ny = y
    moves_finished = 0
    direction = $game_player.direction
    if in_caterpillar_position
      case direction
      when 2
        ny -= number_in_line
      when 4
        nx += number_in_line
      when 6
        nx -= number_in_line
      when 8
        ny += number_in_line
      end
      unless walk || @battler.nil?
        set_direction(direction)
        @appear = true unless @battler.dead?
      end
    end
    if walk
      sx = distance_x_from_target(nx)
      sy = distance_y_from_target(ny)
      walkto(sx, sy)
      if !@is_walking
        set_direction(direction)
        moves_finished = 1
      end
    else
      moveto(nx, ny)
      moves_finished = 1
    end
    return moves_finished
  end

  def passable?(x, y)
    return true if @is_inline && !@is_fighting && !@is_walking
    super
  end
end

class Game_Party
  # Config
  FOLLOW_LEADER_SWITCH = 161
  MEETING_POSITION_SWITCH = 160
  #=======

  include Input
  include PRABS::CONFIG::BUTTONS

  attr_reader :following_leader

  alias_method :abs_party_initialize, :initialize
  def initialize
    abs_party_initialize
    @current_member_id = 9
    @current_member_index = 0
    @orig_party_order = []
    @regroup_on_next_move_flag = false
    @refollow_on_next_move_flag = false
    @following_leader = true
  end

  alias_method :abs_party_setup_starting_members, :setup_starting_members
  def setup_starting_members
    abs_party_setup_starting_members()
    update_orig_party_order()
  end

  alias_method :abs_party_add_actor, :add_actor
  def add_actor(actor_id)
    abs_party_add_actor(actor_id)
    regroup()
    update_orig_party_order()
  end
  
  alias_method :abs_party_remove_actor, :remove_actor
  def remove_actor(actor_id)
    switch_to_next_member if actor_id == get_front_actor_id
    abs_party_remove_actor(actor_id)
    update_orig_party_order()
  end

  def update_orig_party_order
    @orig_party_order = @actors.dup
  end

  def update
    if (Input.trigger?(SWITCH_PLAYER) && !$game_switches[HIDE_CATERPILLAR])
      switch_to_next_member()
    elsif (Input.trigger?(TOGGLE_CATERPILLAR) || $game_switches[FOLLOW_LEADER_SWITCH])  
      toggle_group()
    elsif ($game_switches[MEETING_POSITION_SWITCH])
      form_meeting_position()
    elsif (Input.trigger?(REGROUP_PARTY))
      regroup()
    end
  end

  def switch_to_next_member
    return if @actors.length < 2
    current_member_id = get_front_actor_id()
    orig_index = @orig_party_order.index(current_member_id)
    next_orig_index = orig_index
    for i in 1..@actors.length do
      next_orig_index = next_orig_index + 1 >= @actors.length ? 0 : next_orig_index + 1
      next_member_id = @orig_party_order[next_orig_index]
      unless $game_actors[next_member_id].dead?
        @actors.collect! do |i|
          case i
          when current_member_id
            next_member_id
          when next_member_id
            current_member_id
          else
            i
          end
        end
        break
      end
    end

    @followers.each do |char|
      unless char.battler.nil?
        if char.battler.actor_id == get_front_actor_id()
          transfer_player_control_to_follower(char)
          break
        end
      end
    end
  end

  def get_front_actor_id
    return @actors[0]
  end

  def transfer_player_control_to_follower(follower)
    temp_char = Game_Character.new
    temp_char.copy_from($game_player)
    $game_player.copy_from(follower)
    follower.copy_from(temp_char)

    $game_player.appear = true
    $game_player.center($game_player.x, $game_player.y)
    $scene.refresh_spriteset if $scene.is_a?(Scene_Map)

    @regroup_on_next_move_flag = true
  end

  def abs_all_dead?
    members().each { |actor| return false unless actor.dead? }
    return true
  end

  def toggle_group
    if (!@following_leader)
      all_follow_leader
    else
      ungroup
    end
  end

  def ungroup
    @followers.each { |char| char.break_line() }
    @following_leader = false
  end

  def all_follow_leader
    $game_switches[MEETING_POSITION_SWITCH] = false
    $game_switches[FOLLOW_LEADER_SWITCH] = true
    moveto_party($game_player.x, $game_player.y, true, true, true)
    @refollow_on_next_move_flag = true
  end

  def regroup
    @regroup_on_next_move_flag = false
    @refollow_on_next_move_flag = false
    moveto_party($game_player.x, $game_player.y, true, false, false)
  end

  def form_meeting_position
    direction = $game_player.direction
    x = $game_player.x
    y = $game_player.y
    finished_walkin_count = 0

    @followers.each_with_index do |char, i|
      even = (i % 2) == 0
      steps = i + 1
      if direction == 2 || direction == 8
        if even
          x -= steps
        else
          x += steps
        end
      else
        if even
          y -= steps
        else
          y += steps
        end
      end
      finished_walkin_count += char.follow_line(x, y, true)
    end
    if finished_walkin_count == @followers.length
      $game_switches[MEETING_POSITION_SWITCH] = false
      @regroup_on_next_move_flag = true
    end
  end

  def get_member_index(actor_id)
    return @actors.index(actor_id)
  end
end

class Scene_Map < Scene_Base
  def refresh_spriteset
    @spriteset.dispose              # Dispose of sprite set
    $game_map.update
    @spriteset = Spriteset_Map.new  # Recreate sprite set
    Input.update
  end
end

class Game_Interpreter
  def is_character_on_top?
    this_event = get_character(0)
    return true if $game_player.pos?(this_event.x, this_event.y)
    $game_party.followers.each do |char|
      next if char.battler.nil? || char.battler.dead? || char.actor.nil?
      return true if char.pos_nt?(this_event.x, this_event.y)
    end

    return false
  end

  def animate_item_found
    this_event = get_character(0)
    this_event.update_on_top_of_player = true
    this_event.jump(0, 0)
  end
end