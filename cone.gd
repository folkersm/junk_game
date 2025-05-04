extends Node2D

var level: int = 1
var rarity : float = 5.0
var upgrade : String = "plastic"
var board
var listener: bool = false
var location: Vector2i
var type: String = "nature"
var object_name = "cone"




func set_level(nivel):
	level = nivel
	get_node("level").text = str(nivel)

func mod_level(amount):
	level += amount
	get_node("level").text = str(level)
	
func set_location(loc):
	location = loc
