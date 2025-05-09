extends Node2D

var level: int = 1
var rarity : float = 2.0
var upgrade : String = "nature"
var board
var listener: bool = true
var location: Vector2i
var rng = RandomNumberGenerator.new()
var type: String = "nature"
var object_name = "clover"



func set_level(nivel):
	level = nivel
	get_node("level").text = str(nivel)
	
func mod_level(amount):
	level += amount
	get_node("level").text = str(level)
	
func set_location(loc):
	location = loc
	
func activate(loc, code, type, source):
	if code == "building added":
		var rando = rng.randi_range(0,20)
		if level >= rando:
			upgrade_an_adjacent()
			
func upgrade_an_adjacent():
	var adjacents = []
	for x in [-1,0,1]:
		for y in [-1,0,1]:
			if not (x==0 and y==0):
				var sx = location[0] + x
				var sy = location[1] + y
				if sx >= 0 and sx < 5 and sy >= 0 and sy < 5:
					var obj = board.grid[sx][sy]  # Note: y is the row, x is the column
					if obj != null and obj.has_method("mod_level"):
						adjacents.append(obj)
	if adjacents != []:
		$AnimationPlayer.play("wiggle")
		var index = rng.randi_range(0,len(adjacents)-1)
		adjacents[index].mod_level(1)
