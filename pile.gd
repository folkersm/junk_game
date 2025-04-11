extends Node2D


var distribution_of_types_default = {"industrial": 1,
"nature":1,
"food":1,
"paper":1,
"plastic":5,
"glass":1,
"metal":1,
"tech":1,
"fabric":1,
"toxic":1,}

var this_types_distro = distribution_of_types_default

var path_to_card_rarity = "res://cards.json"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func instantiate(coords):
	position = coords
	
	
func create_distro():
	var total_stuff_in_pile = 0
	for i in distribution_of_types_default.values():
		total_stuff_in_pile += i
	var running_total = 0
	for i in distribution_of_types_default:
		running_total += i.value()/total_stuff_in_pile
		this_types_distro[i.key()] = running_total
		
	
func select_randomly():
	var output = 0
	var random = randf_range(0.000001,.99999999)
	var distro_values = this_types_distro.values()
	if random > 0 and random < distro_values[0]:
		output = this_types_distro[0]
	else:
		for i in range(len(distro_values)-1):
			if random > distro_values[i] and random < distro_values[i+1]:
				output = this_types_distro[i+1]
				break

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func highlight():
	$GarbagePileHighlight.show()

func deselect():
	$GarbagePileHighlight.hide()
	
func _on_select_pressed() -> void:
	highlight()
