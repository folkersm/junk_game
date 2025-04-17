extends Node2D

var previous_view
var original_size

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	previous_view = get_viewport().size
	original_size = get_viewport().size
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
		



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
