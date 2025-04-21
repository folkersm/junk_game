extends TileMapLayer

var pile: PackedScene = preload('res://pile.tscn')
var building: PackedScene = preload('res://building.tscn')
var card_library = load('res://card_library.tscn').instantiate()
var build_mode: bool = false
var grid_pos
var CELL_SIZE = 256
var daddy
var grid_size = 5
var grid = []
var cards_rarity #stores the rarity of each card, organized by types
var cards_distro  = {}#tracks the probability intervals for each card within each type
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
"nature":100,
"food":1,
"paper":1,
"plastic":5,
"glass":1,
"metal":1,
"tech":1,
"fabric":1,
"toxic":1,}
var resource_path_score_tracker: String = "../ScoreTracker/Scores/"
var path_deck : String = "../Deck"
var node_deck : Node2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	cards_rarity = card_library.get_probs()
	generate_cards_distro()
	var daddy = get_parent()
	node_deck = get_node(path_deck)
	for i in grid_size:
		grid.append([0,0,0,0,0])
	add_building("cone",2, Vector2(3,3))
	add_building("rock",2, Vector2(2,2))
	add_building("battery",2, Vector2(0,0))
	add_pile(distribution_of_types_default, Vector2(0,1))
		

func add_pile(quantities, location):
	if grid[location[0]][location[1]] == 0:
		var new_pile = pile.instantiate()
		new_pile.init(quantities, location)
		new_pile.position = grid_to_pixel_coords(location)
		new_pile.signal_generate_resource.connect(generate_resource)
		new_pile.signal_generate_card.connect(generate_card)
		add_child(new_pile)
		

func generate_cards_distro():
	
	cards_distro = cards_rarity
	print(cards_distro)
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
	node_deck.add_card(drawn_card, 1)
	print("generatae card ", drawn_card)
	
	
func generate_resource(type, pile_amount):
	var resource_node = get_node(resource_path_score_tracker + str(type))
	resource_node.text = str(int(resource_node.text) + resource_gen_modifier(pile_amount, type))

func resource_gen_modifier(pile_amount, type): #use this to implement stat modifiers
	return pile_amount

func add_building(name, level, location):
	if grid[location[0]][location[1]] == 0:
		var new_build = building.instantiate()
		new_build.init(name, level, location)
		new_build.position = grid_to_pixel_coords(location)
		add_child(new_build)
		

func grid_to_pixel_coords(int_coords):
	var daddy_size = get_parent().scale[1]
	CELL_SIZE = tile_set.tile_size*daddy_size
	var output = Vector2(int_coords[0],int_coords[1])*CELL_SIZE +CELL_SIZE*3/2 #+ position*daddy_size
	return output

func place_pile(pile, location):
	pile.location = Vector2(location)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var daddy_size = get_parent().scale[1]
	CELL_SIZE = tile_set.tile_size * scale[0]*daddy_size
	var mouse_pos = Vector2(get_global_mouse_position())-position*daddy_size  # Mouse position in world space
	grid_pos = mouse_pos / (CELL_SIZE[0])
	grid_pos = Vector2i(grid_pos.floor())  # Integer grid coordinates
	highlight_tile(grid_pos)
var prev_pos
func highlight_tile(pos):
	if prev_pos:
		set_cell(prev_pos, 0, Vector2i(0,0),0)
	if pos[0] >= 1 and pos[0] <= 5 and pos[1] >=1 and pos[1] <= 5:
		set_cell(pos, 1, Vector2i(0,0), 0)
		prev_pos = pos
				
		#highlight tiles when hovering, indicate whether the item can be placed
		
