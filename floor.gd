extends TileMapLayer

var pile: PackedScene = preload('res://pile.tscn')
var building: PackedScene = preload('res://building.tscn')
var build_mode: bool = false
var grid_pos
var CELL_SIZE = 256
var daddy
var grid_size = 5
var grid = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var daddy = get_parent()
	for i in grid_size:
		grid.append([0,0,0,0,0])
	add_building("cone",2, Vector2(2,2))
		

func add_pile(type, quantity, location):
	var new_pile = pile.instantiate()
	new_pile.init(type, quantity)
	add_child(new_pile)
	place_pile(new_pile, location)
	

func grid_to_pixel_coords(int_coords):
	var daddy_size = get_parent().scale[1]
	CELL_SIZE = tile_set.tile_size * scale[0]*daddy_size
	var output = Vector2(int_coords[0],int_coords[1])*CELL_SIZE #+ position*daddy_size
	return output

func add_building(name, level, location):
	if grid[location[0]][location[1]] == 0:
		var new_build = building.instantiate()
		new_build.init(name, level, location)
		new_build.position = grid_to_pixel_coords(location)
		add_child(new_build)
		

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
	
		
