extends TileMapLayer

var pile: PackedScene = preload('res://pile.tscn')
var building: PackedScene = preload('res://building.tscn')
var build_mode: bool = false
var grid_pos
var CELL_SIZE = 256
var daddy
var grid_size = 5
var grid = []
var distribution_of_types_default = {"industrial": 1,
"nature":1,
"food":1,
"paper":1,
"plastic":5,
"glass":1,
"metal":1,
"tech":1,
"fabric":1,
"toxic":1,}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var daddy = get_parent()
	for i in grid_size:
		grid.append([0,0,0,0,0])
	add_building("cone",2, Vector2(3,3))
	add_building("rock",2, Vector2(2,2))
	add_building("battery",2, Vector2(0,0))
	add_pile(distribution_of_types_default, Vector2(0,1))
		

func add_pile(quantities, location):
	if grid[location[0]][location[1]] == 0:
		print("got to add a pile")
		var new_pile = pile.instantiate()
		new_pile.init(quantities, location)
		new_pile.position = grid_to_pixel_coords(location)
		add_child(new_pile)
		

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
		set_cell(prev_pos, 1, Vector2i(0,0),0)
	if pos[0] >= 1 and pos[0] <= 5 and pos[1] >=1 and pos[1] <= 5:
		set_cell(pos, 0, Vector2i(0,0), 0)
		prev_pos = pos
				
		#highlight tiles when hovering, indicate whether the item can be placed
	
		
