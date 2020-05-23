#============================================================
# ● [VX] ◦ Call Event ◦
# * Missing features from RM2K
#------------------------------------------------------------
# ◦ by Woratana [woratana@hotmail.com]
# ◦ Thaiware RPG Maker Community
# ◦ Released Date: 04/05/2008
#------------------------------------------------------------
=begin

* What is 'Call Event'? *
- Run the event commands in that event immediately.

+[How to use: Version 2]+
=========================================================================
>> Call event from other map by call script:
  
callev(event id, page you want, map ID)
------------------------------------------------------------------------
e.g. callev(5,2,1)
^ to call event commands list from 'page 2' of 'event ID 5' in Map ID '1'
------------------------------------------------------------------------
>> Call event in current map by call script:
  
callev(event id, page you want)
------------------------------------------------------------------------
>> If you want to call event in current page that it's running,
set 'page you want' to 0
------------------------------------------------------------------------
*Note: You CANNOT call an erased event!
========================================================================
=end
#------------------------------------------------------------

# Make variable 'event' readable from outside
class Game_Event; attr_reader :event; end
class Game_Interpreter
  def callev(evid = 0,page = 0, id_map = $game_map.map_id)
    return if evid == 0
    if id_map != $game_map.map_id
      # Load new map data if event is not from current map
      dest_map = load_data(sprintf("Data/Map%03d.rvdata", id_map))
      if page == 0
        # Get first page if user haven't set page
        inter_event = dest_map.events[evid].pages[0]
      else
        inter_event = dest_map.events[evid].pages[page - 1]
      end
    else
      # Use $game_map if event is in current map
      if page == 0
        inter_event = $game_map.events[evid]
      else
        inter_event = $game_map.events[evid].event.pages[page - 1]
      end
    end
    # Add new child_interpreter to run commands
    @child_interpreter = Game_Interpreter.new(@depth + 1)
    # Add commands from target event
    @child_interpreter.setup(inter_event.list, @event_id)
  end
end