extends Node2D

var level: int = 1
var rarity : float = 3.5
var upgrade : String = "toxic"
var board
var listener: bool = false
var type: String = "nature"
var location: Vector2i
var object_name = "battery"





func activate(loc, code, type, source):
	print("printing cone activation ", loc, code, type, source)


func set_level(nivel):
	level = nivel
	get_node("level").text = str(nivel)
	

func mod_level(amount):
	level += amount
	get_node("level").text = str(level)
	

func set_location(loc):
	location = loc
