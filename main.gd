extends Node

signal deselect
var building: PackedScene = preload('res://building.tscn')
@onready var board = get_node("MainView/Board")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	#$MainView.hide()
	#$MainMenu.show()

func build_map(array):
	board.build_map(array)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func set_zone(zone):
	print(zone)
	

func _on_start_game_pressed() -> void:
	$MainView.show()
	$MainMenu.hide()
	
func emit_deselect():
	deselect.emit()
