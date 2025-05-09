extends Node2D

var previous_view
var original_size
var player_board_focus = null
@onready var deck = get_node("Deck")
@onready var board = get_node("Board")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	previous_view = get_viewport().size
	original_size = get_viewport().size
	
func update_board_focus(coords):
	if board.set_focus_shadow_loc(coords):
		player_board_focus = coords


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
		

func process_frame():
	if player_board_focus != null:
		board.activate(player_board_focus, "player_focus", "null", "player_focus")


func _on_screen_adjust_timer_timeout() -> void:
	if previous_view != get_viewport().size:
		previous_view = get_viewport().size
		var x_prev = float(previous_view[0])
		var y_prev = float(previous_view[1])
		var x_orig = float(original_size[0])
		var y_orig = float(original_size[1])
		print(x_prev, " ", x_orig)
		var x_scale: float = x_prev/x_orig
		var y_scale: float = y_prev/y_orig
		print(x_scale, y_scale, x_prev)
		var small_dimension = min(x_scale, y_scale)
		scale = Vector2(small_dimension, small_dimension)
