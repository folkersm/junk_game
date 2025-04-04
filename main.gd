extends Node

signal deselect
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$MainView.hide()
	$MainMenu.show()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	

func _on_start_game_pressed() -> void:
	$MainView.show()
	$MainMenu.hide()
	
func emit_deselect():
	deselect.emit()
