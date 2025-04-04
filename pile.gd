extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func instantiate(coords):
	position = coords
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func highlight():
	$GarbagePileHighlight.show()

func deselect():
	$GarbagePileHighlight.hide()
	
func _on_select_pressed() -> void:
	highlight()
