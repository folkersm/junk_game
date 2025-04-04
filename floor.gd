extends TileMapLayer

var pile: PackedScene = preload('res://pile.tscn')
var building: PackedScene = preload('res://building.tscn')
var build_mode: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func add_pile():
	var new_pile = pile.instantiate()
	add_child(new_pile)
	
func add_building():
	var new_build = building.instantiate()
	add_child(new_build)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if build_mode:
		pass
		#highlight tiles when hovering, indicate whether the item can be placed
	
		
