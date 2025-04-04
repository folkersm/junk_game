extends Node2D
var score_requirement: int = 100
var score_val: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_score_requirement(score_requirement)
	set_score_val(0)

func set_score_requirement(score):
	score_requirement = score
	$Score.text = str(score_val) +"/"+ str(score_requirement)
	
func set_score_val(val):
	score_val = val
	$Score.text = str(score_val) +"/"+ str(score_requirement)
	
func add_score(val):
	score_val += val
	$Score.text = str(score_val) +"/"+ str(score_requirement)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
