extends Node2D
var score_requirement: int = 100
var score_val: int = 0
var distribution_of_types_default = {"industrial": 1,
"nature":1,
"food":1,
"paper":1,
"plastic":5,
"glass":1,
"metal":1,
"tech":1,
"fabric":1,
"toxic":1}
var scores = {"industrial": 0,
"nature":0,
"food":0,
"paper":0,
"plastic":0,
"glass":0,
"metal":0,
"tech":0,
"fabric":0,
"toxic":0}
var number_of_scores = 8

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#set_score_requirement(score_requirement)
	#set_score_val(0)
	pass
	print("hello this is a test >% and this is the next test >% test %" % [1,2,3])
	for score in scores:
		scores[score] = 100
		get_node("Scores/" + score).text = "100"

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
