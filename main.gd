extends Node

signal deselect
var building: PackedScene = preload('res://building.tscn')
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$MainView.hide()
	$MainMenu.show()
	var sprite = building.instantiate()
	var texture = load("res://Cards/cone.png")  # Or use icon.png if you prefer
	sprite.get_child(0).texture = texture
	sprite.position = Vector2(200, 200)
	add_child(sprite)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	

func _on_start_game_pressed() -> void:
	$MainView.show()
	$MainMenu.hide()
	
func emit_deselect():
	deselect.emit()
