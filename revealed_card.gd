extends Sprite2D

var dragging := false
var default_location = Vector2(150,250)
var can_drop
@onready var board := get_node("../../Board")
#
#func enable_dragging():
	#can_drop = true

#revealed card is dragged meaning it is clicked
#remove the top card and insert its info into a dragged card node
#reveal the next card on the deck and let the deck continue to accumulate cards as usual
#if the dragged card lands on an empty space, populate the grid with that card
#if the dragged card misses the board, ends on the deck, or is placed on an occupied board tile send it back to the deck
#if the dragged card ends on the recycler send it there. 
#
#
#func _input(event):
	#if event is InputEventMouseButton and can_drop:
		#if event.button_index == MOUSE_BUTTON_LEFT:
			#if event.pressed:
				## Check if the mouse is over the sprite
				#if get_rect().has_point(to_local(event.position)):
					#get_parent()._on_grab_card_pressed()
					#dragging = true
					#get_viewport().set_input_as_handled()
			#elif dragging:
				#dragging = false
				#handle_drop(event.position)
				#
#
	#elif event is InputEventMouseMotion and dragging:
		#global_position += event.relative
#
#func handle_drop(mouse_position):
	#var board_node = board  # Adjust if your board is structured differently
	#var local_pos = board_node.to_local(mouse_position)
	#var tile_coords = board_node.local_to_map(local_pos)-Vector2i(1,1)
#
	## Defensive bounds check
	#var x = tile_coords.x
	#var y = tile_coords.y
	#if y >= 0 and y < board.grid.size() and x >= 0 and x < board.grid[y].size():
		#if board.grid_is_empty(Vector2i(x,y)) and 0 < len(get_parent().deck):
			#print("Dropped on open tile at: ", tile_coords)
			#var top_card = get_parent().deck[-1]
			#var level = top_card["level"]
			#var nombre = top_card["name"]
			#var type = top_card["type"]
			#board.add_building(nombre, level, tile_coords, type)
			#position = default_location
			#get_parent().remove_card()
			#can_drop = false
			## Do something: maybe snap it to tile or mark as occupied
			##board.grid[y][x] = 1  # Mark tile as now occupied
		#else:
			#position = default_location
			#print("Tile occupied! Do something else...")
			## e.g. move it back to starting position
	#else:
		#position = default_location
		#print("Out of bounds drop!")
#
#
#func _on_game_clock_timer_timeout() -> void:
	#pass # Replace with function body.
