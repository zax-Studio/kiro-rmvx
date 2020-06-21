=begin 
#==============================================================================
# ** Sprite_ItemFound
#------------------------------------------------------------------------------
#  This sprite is used to display items found
#==============================================================================

class Sprite_ItemFound < Sprite_Base
	#--------------------------------------------------------------------------
	# * Constants
	#--------------------------------------------------------------------------
	DURATION = 32                             # frames to complete the movement
	DURATION_AFTER_ANIMATION = 40
	PIXELS_TO_LIFT = 16
	#--------------------------------------------------------------------------
	# * Public Instance Variables
	#--------------------------------------------------------------------------
	attr_accessor :character
	#--------------------------------------------------------------------------
	# * Object Initialization
	#     viewport  : viewport
	#     character : character (Game_Character)
	#--------------------------------------------------------------------------
	def initialize(viewport, character = nil, frames = nil, target = nil)
		super(viewport)
		@character = character
		@frames = DURATION
		@target = PIXELS_TO_LIFT
		@subtrahend = @target / @frames
		@translation_done = false
		
		self.x = @character.screen_x
		self.y = @character.screen_y
		self.z = @character.screen_z
		self.opacity = @character.opacity
		self.blend_type = @character.blend_type
		self.bush_depth = @character.bush_depth

		update
	end
	#--------------------------------------------------------------------------
	# * Dispose
	#--------------------------------------------------------------------------
	def dispose
		super
	end
	#--------------------------------------------------------------------------
	# * Frame Update
	#--------------------------------------------------------------------------
	def update
		super
		update_bitmap
		self.visible = (not @character.transparent)
		update_src_rect
		if @translation_done
			@frames += 1
			if @frames == DURATION_AFTER_ANIMATION
				dispose
				return
			end
		else
			update_translation
		end
		if @character.animation_id != 0
			animation = $data_animations[@character.animation_id]
			start_animation(animation)
			@character.animation_id = 0
		end
	end
	#--------------------------------------------------------------------------
	# * Get tile set image that includes the designated tile
	#     tile_id : Tile ID
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
	# * Update Transfer Origin Bitmap
	#--------------------------------------------------------------------------
	def update_bitmap
		if @tile_id != @character.tile_id or @character_name != @character.character_name or @character_index != @character.character_index
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
			end
		end
	end
	#--------------------------------------------------------------------------
	# * Update Transfer Origin Rectangle
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
	# * Update translation (movement)
	#--------------------------------------------------------------------------
	def update_translation
		#print(@subtrahend)
		if @subtrahend < 1
			@subtrahend += @subtrahend
			return
		end
		#print(@subtrahend.floor)
		self.y -= @subtrahend.floor
		@subtrahend = @target / @frames
		@frames -= 1
		@translation_done = true if @frames == 0
	end
end

class Scene_Map
	attr_accessor :spriteset
end

class Game_Interpreter
	def on_item_found
		$game_map.add_itemfound(@event_id)
	end
end

class Game_Map
	def add_itemfound(event_id)
		character = $game_map.events[event_id]
		$scene.spriteset.add_itemfound_sprite(character) unless $scene.spriteset.nil?
	end
end

class Spriteset_Map
	alias ar_if_ssm_initialize initialize
	def initialize
		@itemfound_sprites = []
		ar_if_ssm_initialize
	end

	def add_itemfound_sprite(character)
			@itemfound_sprites.push(Sprite_ItemFound.new(@viewport1, character))
	end
	
	def update_itemfound_sprites
    ids = []
    nc = false
		@itemfound_sprites.each do |sprite|
			sprite.update
      if sprite.disposed?
        ids.push(i)
      end
    end
    for i in ids
      @itemfound_sprites[i] = nil
      nc = true
    end
    if nc
      @itemfound_sprites.compact!
    end
	end

	alias ar_if_gmap_update update
	def update
		ar_if_gmap_update
		update_itemfound_sprites
	end
end 
=end