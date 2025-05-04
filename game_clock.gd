extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$GameSpeedAdjust.max_value = 5
	$GameSpeedAdjust.min_value = .1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$FrameProgress.value += delta #delta = .01666
	$GameClockValueLabel2.text = str($GameSpeedAdjust.value)

func _on_game_clock_timer_timeout() -> void:
	$FrameProgress.max_value = $GameSpeedAdjust.value
	$GameSpeedAdjust/GameClockTimer.wait_time = $GameSpeedAdjust.value
	
