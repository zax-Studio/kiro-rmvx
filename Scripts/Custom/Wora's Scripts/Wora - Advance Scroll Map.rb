#===============================================================
# ● [VX] ◦ Advance Scroll System ◦ □
# * Scroll with speed like 2.5 or 1.6, and/or in diagonal direction~ *
#--------------------------------------------------------------
# ◦ by Woratana [woratana@hotmail.com]
# ◦ Thaiware RPG Maker Community
# ◦ Released on: 25/05/2008
# ◦ Version: 1.0
#--------------------------------------------------------------

#==================================================================
# ** HOW TO USE **
#-----------------------------------------------------------------
# To start scroll, call script:
#  scroll(direction, distance, speed)
#
# * direction: Scroll direction
# ** You can use these words for direction:
# ** DOWNLEFT, DOWN, DOWNRIGHT, LEFT, RIGHT, UPLEFT, UP, UPRIGHT
#
# * distance: Scroll Distance (1 for 1 tile)
#
# * speed: Scroll Speed, it can be any positive number (3, 2.3, 4.5, ...)
#
# For example:
#  scroll(UPLEFT, 10, 2.5)
# will scroll in UP-LEFT diretion for 10 tiles, with speed 2.5
#==================================================================

class Game_Map
  def update_scroll
    if @scroll_rest > 0                 # If scrolling
      distance = 2 ** @scroll_speed     # Convert to distance
      case @scroll_direction
      when 1  # Down-Left
        scroll_down(distance)
        scroll_left(distance)
      when 2  # Down
        scroll_down(distance)
      when 3  # Down-Right
        scroll_down(distance)
        scroll_right(distance)
      when 4  # Left
        scroll_left(distance)
      when 6  # Right
        scroll_right(distance)
      when 7  # Up-Left
        scroll_up(distance)
        scroll_left(distance)
      when 8  # Up
        scroll_up(distance)
      when 9 # Up-Right
        scroll_up(distance)
        scroll_right(distance)
      end
      @scroll_rest -= distance          # Subtract scrolled distance
    end
  end
end

class Game_Interpreter
  DOWNLEFT = 1
  DOWN = 2
  DOWNRIGHT = 3
  LEFT = 2
  RIGHT = 6
  UPLEFT = 7
  UP = 8
  UPRIGHT = 9
  
  def scroll(direction, distance, speed)
    @params[0], @params[1], @params[2] = direction, distance, speed.to_f
    command_204
  end
end