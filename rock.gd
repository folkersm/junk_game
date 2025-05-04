extends Node2D

var level: int = 1
var rarity : float = 2.0
var upgrade : String = "metal"
var location: Vector2i
var listener: bool = true
var type: String = "nature"
var object_name = "rock"
var board

func set_level(nivel):
	level = nivel
	get_node("level").text = str(nivel)

func mod_level(amount):
	level += amount
	get_node("level").text = str(level)

func set_location(loc):
	location = loc

func activate(loc: Vector2i, code, type, source):
	if source == "pile" and code == "resource" and type == "paper" and abs(loc.x - location.x) <= 1 and abs(loc.y - location.y) <= 1:
		board.generate_resource(location,"paper",level, "rock")
		wiggle()

func wiggle():
	$AnimationPlayer.play("wiggle")
	
