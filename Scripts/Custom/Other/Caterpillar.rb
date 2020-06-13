class Game_Player
  #--------------------------------------------------------------------------
  # * Move Down
  # turn_enabled : a flag permits direction change on that spot
  #--------------------------------------------------------------------------
  def move_down(turn_enabled = true)
    super(turn_enabled)
  end

  #--------------------------------------------------------------------------
  # * Move Left
  # turn_enabled : a flag permits direction change on that spot
  #--------------------------------------------------------------------------
  def move_left(turn_enabled = true)
    super(turn_enabled)
  end

  #--------------------------------------------------------------------------
  # * Move Right
  # turn_enabled : a flag permits direction change on that spot
  #--------------------------------------------------------------------------
  def move_right(turn_enabled = true)
    super(turn_enabled)
  end

  #--------------------------------------------------------------------------
  # * Move up
  # turn_enabled : a flag permits direction change on that spot
  #--------------------------------------------------------------------------
  def move_up(turn_enabled = true)
    super(turn_enabled)
  end

  #--------------------------------------------------------------------------
  # * Move Lower Left
  #--------------------------------------------------------------------------
  def move_lower_left
    super
  end

  #--------------------------------------------------------------------------
  # * Move Lower Right
  #--------------------------------------------------------------------------
  def move_lower_right
    super
  end

  #--------------------------------------------------------------------------
  # * Move Upper Left
  #--------------------------------------------------------------------------
  def move_upper_left
    super
  end

  #--------------------------------------------------------------------------
  # * Move Upper Right
  #--------------------------------------------------------------------------
  def move_upper_right
    super
  end
end

class Game_Follower < Game_Character
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_reader :actor
  attr_accessor :move_speed
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  alias_method :trick_caterpillar_follower_initialize, :initialize
  
  def initialize(actor)
    super()
    @through = true
    @priority_type = 0
    @actor = actor
    trick_caterpillar_follower_initialize
    setup if actor != nil
  end

  #--------------------------------------------------------------------------
  # * Set Actor
  #--------------------------------------------------------------------------
  def actor=(actor)
    @actor = actor
    setup
  end

  #--------------------------------------------------------------------------
  # * Setup
  #--------------------------------------------------------------------------
  def setup
    if @actor != nil
      @battler = $game_actors[@actor]
      @character_name = @battler.character_name
      @character_index = @battler.character_index
    else
      @character_name = ""
      @character_index = 0
    end
    @opacity = 255
    @blend_type = 0
    @through = false
    @priority_type = 1
  end

  #--------------------------------------------------------------------------
  # * Screen Z
  #--------------------------------------------------------------------------
  def screen_z
    if $game_player.x == @x and $game_player.y == @y
      return $game_player.screen_z - 1
    end
    super
  end

  #--------------------------------------------------------------------------
  # * Same Position Starting Determinant (Disabled)
  #--------------------------------------------------------------------------
  def check_event_trigger_here(triggers)
    result = false
    return result
  end

  #--------------------------------------------------------------------------
  # * Front Envent Starting Determinant (Disabled)
  #--------------------------------------------------------------------------
  def check_event_trigger_there(triggers)
    result = false
    return result
  end

  #--------------------------------------------------------------------------
  # * Touch Event Starting Determinant (Disabled)
  #--------------------------------------------------------------------------
  def check_event_trigger_touch(x, y)
    result = false
    return result
  end
end

class Spriteset_Map
  alias_method :spriteset_map_create_characters, :create_characters

  def create_characters
    spriteset_map_create_characters
    $game_party.followers.each do |char|
      @character_sprites << Sprite_Character.new(@viewport1, char)
    end
  end
end

class Game_Party
  #--------------------------------------------------------------------------
  # * Constants
  #--------------------------------------------------------------------------
  MAX_SIZE = 4
  CATERPILLAR = 149
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_reader :followers
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  alias_method :trick_caterpillar_party_initialize, :initialize

  def initialize
    trick_caterpillar_party_initialize
    @followers = Array.new(MAX_SIZE - 1) { Game_Follower.new(nil) }
    @move_list = []
  end

  #--------------------------------------------------------------------------
  # * Update Followers
  #--------------------------------------------------------------------------
  def update_followers
    flag = $game_player.transparent || $game_switches[CATERPILLAR]
    @followers.each_with_index do |char, i|
      next if i >= @actors.length - 1
      char.actor = @actors[i + 1]
      char.move_speed = $game_player.move_speed
      if $game_player.dash?
        char.move_speed += 1
      end
      char.update
      char.transparent = flag
    end
  end

  #--------------------------------------------------------------------------
  # * Move To Party
  #--------------------------------------------------------------------------
  def moveto_party(x, y, regroup_all = true, walk = false, in_caterpillar_position = false)
    finished_walking_count = 0
    @followers.each_with_index do |char, i|
      char.set_follow_line_variables() if regroup_all
      unless char.is_inline
        finished_walking_count += 1
        next
      end
      number_in_line = i + 1
      finished_walking_count += char.follow_line(x, y, walk, in_caterpillar_position, number_in_line)
      if walk && finished_walking_count == @followers.length
        $game_switches[FOLLOW_LEADER_SWITCH] = false
      end
    end
    
    @following_leader = true if regroup_all
    @move_list.clear if !walk || finished_walking_count >= @followers.length
  end

  #--------------------------------------------------------------------------
  # * Move Party
  #--------------------------------------------------------------------------
  def move_party
    return unless @following_leader
    @move_list.each_index do |i|
      follower = @followers[i]
      if follower == nil
        @move_list[i...@move_list.size] = nil
        next
      end
      next if !follower.is_inline || follower.is_walking
      case @move_list[i].type
      when 2
        follower.move_down(*@move_list[i].args)
      when 4
        follower.move_left(*@move_list[i].args)
      when 6
        follower.move_right(*@move_list[i].args)
      when 8
        follower.move_up(*@move_list[i].args)
      when 1
        follower.move_lower_left
      when 3
        follower.move_lower_right
      when 7
        follower.move_upper_left
      when 9
        follower.move_upper_right
      when 5
        follower.jump(*@move_list[i].args)
      end
    end
  end

  #--------------------------------------------------------------------------
  # * Add Move List
  #--------------------------------------------------------------------------
  def update_move(type, *args)
    if @regroup_on_next_move_flag || (@refollow_on_next_move_flag && type != @followers[0].direction)
      moveto_party($game_player.x, $game_player.y, false, false, true)
    end
    if @refollow_on_next_move_flag || @regroup_on_next_move_flag
      @followers.each_index do |i|
        @move_list.unshift(Game_MoveListElement.new(type, args))
      end
      @refollow_on_next_move_flag = false
      @regroup_on_next_move_flag = false
    end
    move_party
    @move_list.unshift(Game_MoveListElement.new(type, args))
  end

  def duplicate_previous_move(follower_index)
    if follower_index > 0
      @move_list[follower_index] = @move_list[follower_index - 1]
    end
  end
end

class Game_MoveListElement
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(type, args)
    @type = type
    @args = args
  end

  #--------------------------------------------------------------------------
  # * Type
  #--------------------------------------------------------------------------
  def type
    return @type
  end

  #--------------------------------------------------------------------------
  # * Args
  #--------------------------------------------------------------------------
  def args
    return @args
  end
end

class Game_Player
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_reader :move_speed

  #--------------------------------------------------------------------------
  # * Update
  #--------------------------------------------------------------------------
  alias_method :trick_caterpillar_player_update, :update

  def update
    $game_party.update_followers
    trick_caterpillar_player_update
  end

  #--------------------------------------------------------------------------
  # * Moveto
  #--------------------------------------------------------------------------
  alias_method :trick_caterpillar_player_moveto, :moveto

  def moveto(x, y)
    $game_party.moveto_party(x, y)
    trick_caterpillar_player_moveto(x, y)
  end

  #--------------------------------------------------------------------------
  # * Move Down
  #--------------------------------------------------------------------------
  alias_method :trick_caterpillar_player_move_down, :move_down

  def move_down(turn_enabled = true)
    if passable?(@x, @y + 1)
      $game_party.update_move(2, turn_enabled)
    end
    trick_caterpillar_player_move_down(turn_enabled)
  end

  #--------------------------------------------------------------------------
  # * Move Left
  #--------------------------------------------------------------------------
  alias_method :trick_caterpillar_player_move_left, :move_left

  def move_left(turn_enabled = true)
    if passable?(@x - 1, @y)
      $game_party.update_move(4, turn_enabled)
    end
    trick_caterpillar_player_move_left(turn_enabled)
  end

  #--------------------------------------------------------------------------
  # * Move Right
  #--------------------------------------------------------------------------
  alias_method :trick_caterpillar_player_move_right, :move_right

  def move_right(turn_enabled = true)
    if passable?(@x + 1, @y)
      $game_party.update_move(6, turn_enabled)
    end
    trick_caterpillar_player_move_right(turn_enabled)
  end

  #--------------------------------------------------------------------------
  # * Move Up
  #--------------------------------------------------------------------------
  alias_method :trick_caterpillar_player_move_up, :move_up

  def move_up(turn_enabled = true)
    if passable?(@x, @y - 1)
      $game_party.update_move(8, turn_enabled)
    end
    trick_caterpillar_player_move_up(turn_enabled)
  end

  #--------------------------------------------------------------------------
  # * Move Lower Left
  #--------------------------------------------------------------------------
  alias_method :trick_caterpillar_player_move_lower_left, :move_lower_left

  def move_lower_left
    if passable?(@x - 1, @y) and passable?(@x, @y + 1)
      $game_party.update_move(1)
    end
    trick_caterpillar_player_move_lower_left
  end

  #--------------------------------------------------------------------------
  # * Move Lower Right
  #--------------------------------------------------------------------------
  alias_method :trick_caterpillar_player_move_lower_right, :move_lower_right

  def move_lower_right
    if passable?(@x + 1, @y) and passable?(@x, @y + 1)
      $game_party.update_move(3)
    end
    trick_caterpillar_player_move_lower_right
  end

  #--------------------------------------------------------------------------
  # * Move Upper Left
  #--------------------------------------------------------------------------
  alias_method :trick_caterpillar_player_move_upper_left, :move_upper_left

  def move_upper_left
    if passable?(@x - 1, @y) and passable?(@x, @y - 1)
      $game_party.update_move(7)
    end
    trick_caterpillar_player_move_upper_left
  end

  #--------------------------------------------------------------------------
  # * Move Upper Right
  #--------------------------------------------------------------------------
  alias_method :trick_caterpillar_player_move_upper_right, :move_upper_right

  def move_upper_right
    if passable?(@x + 1, @y) and passable?(@x, @y - 1)
      $game_party.update_move(9)
    end
    trick_caterpillar_player_move_upper_right
  end

  #--------------------------------------------------------------------------
  # * Jump
  #--------------------------------------------------------------------------
  alias_method :trick_caterpillar_player_jump, :jump

  def jump(x_plus, y_plus)
    new_x = @x + x_plus
    new_y = @y + y_plus
    if (x_plus == 0 and y_plus == 0) or passable?(new_x, new_y)
      $game_party.update_move(5, x_plus, y_plus)
    end
    trick_caterpillar_player_jump(x_plus, y_plus)
  end
end