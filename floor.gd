extends TileMapLayer

var pile: PackedScene = preload('res://pile.tscn')
var building: PackedScene = preload('res://building.tscn')
var card_library = load('res://card_library.tscn').instantiate()
@onready var recycler = get_node("../Recycler")
@onready var recycler_tile = get_node("../Recycler/base")
@onready var deck = get_node("../Deck")
@onready var deck_tile = get_node("../Deck/CardBase")
@onready var shadow = get_node("shadow")
@onready var main_view = get_parent()
var build_mode: bool = false
var grid_pos
var CELL_SIZE = 256
var daddy
var grid_size
var grid = []
var cards_rarity #stores the rarity of each card, organized by types
var cards_distro  = {}#tracks the probability intervals for each card within each type
var active_objects = []

var cards_distro_totals = {"industrial": 0,
"nature":0,
"food":0,
"paper":0,
"plastic":0,
"glass":0,
"metal":0,
"tech":0,
"fabric":0,
"toxic":0,}
var distribution_of_types_default = {"industrial": 1,
"nature":17,
"food":1,
"paper":1,
"plastic":1,
"glass":1,
"metal":1,
"tech":1,
"fabric":1,
"toxic":1,}
var resource_path_score_tracker: String = "../ScoreTracker/Scores/"
var path_deck : String = "../Deck"
var node_deck : Node2D
var main_view_size

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	cards_rarity = card_library.get_probs()
	generate_cards_distro()
	var daddy = get_parent()
	node_deck = get_node(path_deck)
	#for i in grid_size:
		#grid.append([null,null,null,null,null])
	
	#
	
	
	
func build_map(map_array):
	grid = map_array
	grid_size = [len(map_array[0]), len(map_array)]
	for row in range(len(map_array)):
		for column in range(len(map_array[row])):
			print(row, column, map_array[row][column])
			set_cell(Vector2i(row, column), 0, Vector2i(0,0), 0)
	add_pile(distribution_of_types_default, Vector2(2,2))
	add_building("clover", 20, Vector2i(0,0), "nature")
	
func is_object(loc):
	if "object_name" in grid[loc[0]][loc[1]]:
		return true
	else:
		return false

func grid_is_empty(loc): # takes in a integer coord and returns boolean of whether it's in the grid. loc = (x,y), grid_size = [y,x]
	if loc[0] >= 0 and loc[0] <= grid_size[1] and loc[1] >= 0 and loc[1] < grid_size[0] and grid[int(loc[0])][int(loc[1])] == null:
			return true
	else:
		return false

func coords_on_grid(loc): # takes in a integer coord and returns boolean of whether it's in the grid
	if loc[0] >= 0 and loc[0] <  grid_size[1] and loc[1] >= 0 and loc[1] < grid_size[0]:
			return true
	else:
		return false

func world_to_map(pos):# pos is a Vector2
	var main_view_size = get_parent().scale[1]
	CELL_SIZE = tile_set.tile_size * scale[0]*main_view_size
	var offset_pos = pos-position*main_view_size  # Mouse position in world space
	grid_pos = offset_pos / (CELL_SIZE[0])
	grid_pos = Vector2i(grid_pos.floor()) # Integer grid coordinates with offset applied
	return grid_pos #works with scaling of window

func grid_to_viewport(coords): #converts integer coords of grid 2d array to pixel coords for the viewport
	var board_coords = grid_to_pixel_coords(coords)
	return board_coords + position*main_view_size

func grid_to_pixel_coords(int_coords): # converts grid coords to pixel coords for tileset
	main_view_size = get_parent().scale[1]
	CELL_SIZE = tile_set.tile_size
	var output = Vector2i(int_coords[0],int_coords[1])*CELL_SIZE +CELL_SIZE*1/2 # scale teh grid coords by tile size and add offset for the fact that the grid isn't in the corner of the 
	return output


######### 			activations 			##########


func add_pile(quantities, location):
	if grid != [] and grid_is_empty(location):
		var new_pile = pile.instantiate()
		new_pile.init(quantities, location)
		new_pile.position = grid_to_pixel_coords(location)
		new_pile.signal_generate_resource.connect(generate_resource)
		new_pile.signal_generate_card.connect(generate_card)
		new_pile.main_view = main_view
		add_child(new_pile)
		grid[location[0]][location[1]] = new_pile

var old_build = false
func add_building(nombre, level, location, type):
	if grid != [] and grid_is_empty(location):
		activate_objects(location, "building added", type, "deck")
		var new_build = card_library.get_card(nombre, type).duplicate()
		new_build.position = grid_to_pixel_coords(location)
		new_build.set_level(level)
		new_build.set_location(location)
		new_build.board = self
		if new_build.listener:
			active_objects.append(new_build)
		add_child(new_build)
		grid[location[0]][location[1]] = new_build
		#var new_build = card_library.get_child("")
		
func place_pile(pile, location):
	pile.location = Vector2(location)
# Called every frame. 'delta' is the elapsed time since the previous frame.


func generate_cards_distro():
	cards_distro = cards_rarity
	for type in cards_distro.keys():
		var total: float = 0
		for card in cards_distro[type].keys():
			total += float(cards_distro[type][card])
			cards_distro[type][card] = total
		cards_distro_totals[type] = total

func generate_card(type):
	if cards_distro == {}:
		generate_cards_distro()
	var type_total = cards_distro_totals[type]
	var random_card = randf_range(0.0,type_total)
	var drawn_card
	for rarity_value in cards_distro[type].values():
		if random_card < rarity_value:
			drawn_card = cards_distro[type].find_key(rarity_value)
			break
	if (drawn_card != null):
		var upgrade_resource = card_library.get_upgrade(type,drawn_card)
		node_deck.add_card(type, drawn_card, 1, upgrade_resource)

func activate_objects(loc, code, type, source):
	var index = 0
	for object in active_objects:
		if is_instance_valid(object):
			#print("debug the activate objects func ",loc, code, type, source)
			object.activate(loc, code, type, source)
			index +=1
		else:
			active_objects.pop_at(index)

func activate(loc, code, type, source):
	if not grid_is_empty(loc) and coords_on_grid(loc):
		grid[loc[0]][loc[1]].activate(loc, code, type, source)

func generate_resource(loc,type, pile_amount, source):
	activate_objects(loc, "resource", type, source)
	var resource_node = get_node(resource_path_score_tracker + str(type))
	resource_node.text = str(int(resource_node.text) + resource_gen_modifier(pile_amount, type))

func resource_gen_modifier(pile_amount, type): #use this to implement stat modifiers
	return pile_amount
	
	#test

var prev_pos = Vector2i(0,0)
func highlight_tile(pos):
	if prev_pos != pos:
		set_cell(prev_pos, 0, Vector2i(0,0),0)
		if pos[0] >= 0 and pos[0] < grid_size[1] and pos[1] >= 0 and pos[1] < grid_size[0]:
			set_cell(pos, 1, Vector2i(0,0), 0)
			prev_pos = pos
				
		#highlight tiles when hovering, indicate whether the item can be placed

func set_focus_shadow_loc(loc):
	if coords_on_grid(loc):
		shadow.position = grid_to_pixel_coords(loc)
		return true
	else:
		return false

var is_dragging = false
var drag_start_position = Vector2i()
var dragged_tile_coordinates = Vector2i()
var grabbed_card

func _input(event):
	# if left click is pressed down:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var mouse_position = get_global_mouse_position()
		var cell_coordinates = world_to_map(mouse_position)
		# if there's a valid object in the tile where you click
		if not grid_is_empty(cell_coordinates) and coords_on_grid(cell_coordinates) and is_object(cell_coordinates): # first click to pick up object
			is_dragging = true
			drag_start_position = mouse_position
			dragged_tile_coordinates = cell_coordinates
			grabbed_card = grid[cell_coordinates[0]][cell_coordinates[1]]
			# You might want to visually indicate the tile is being dragged here
		else:
			focus_cell(cell_coordinates)
	# when released, do this, only when you were already dragging something
	elif event is InputEventMouseButton and not event.pressed and event.button_index == MOUSE_BUTTON_LEFT and is_dragging:
		is_dragging = false
		var final_pos = world_to_map(get_global_mouse_position())
		if grid_is_empty(final_pos):
			grabbed_card.position = grid_to_pixel_coords(final_pos)
			#grabbed_card.position = get_global_mouse_position()
			grid[dragged_tile_coordinates[0]][dragged_tile_coordinates[1]] = null
			grid[final_pos[0]][final_pos[1]] = grabbed_card
			grabbed_card.set_location(final_pos)
		elif grabbed_card != null: #if you haven't finished dragging your mouse on a empty tile, then check if you finished on the recycler or the deck
			var recycler_mouse_pos = recycler_tile.get_local_mouse_position()
			var deck_mouse_pos = deck_tile.get_local_mouse_position()
			var recycler_rect = Rect2(Vector2.ZERO-recycler_tile.texture.get_size() * recycler_tile.scale, recycler_tile.texture.get_size())
			var deck_rect = Rect2(Vector2.ZERO-recycler_tile.texture.get_size() * recycler_tile.scale, recycler_tile.texture.get_size())
			if recycler_rect.has_point(recycler_mouse_pos):
				send_to_recycler(dragged_tile_coordinates)
			elif deck_rect.has_point(deck_mouse_pos):
				send_to_deck(dragged_tile_coordinates)
			else:
				grabbed_card.position = grid_to_pixel_coords(dragged_tile_coordinates)
				focus_cell(final_pos)
	
	#handle moving the object while it's being dragged
	elif event is InputEventMouseMotion and is_dragging:
		var current_mouse_position = get_global_mouse_position()
		var drag_offset = current_mouse_position - drag_start_position
		main_view_size = get_parent().scale[1]
		grabbed_card.position += event.relative/(main_view_size*scale)
	
		# Apply the drag offset to the dragged element (e.g., another node or a visual representation)
				
func _process(delta: float) -> void:
	highlight_tile(world_to_map(get_global_mouse_position()))
	
func send_to_recycler(loc):
	var recycle_object = grid[loc[0]][loc[1]]
	var card = {
		"type": recycle_object.type,
		"name": str(recycle_object.object_name),
		"level": recycle_object.level,
		"upgrade": recycle_object.upgrade
		}
	recycle_object.queue_free()
	grid[loc[0]][loc[1]] = null
	recycler.add_object(card)

func send_to_deck(loc):
	var deck_object = grid[loc[0]][loc[1]]
	deck_object.queue_free()
	grid[loc[0]][loc[1]] = null
	deck.add_card(deck_object.type, deck_object.object_name, deck_object.level, deck_object.upgrade)
	
func focus_cell(loc):
	main_view.update_board_focus(loc)
