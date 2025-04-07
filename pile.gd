extends Node2D

var path_to_card_rarity = "res://cards.json"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func set_card_indecies(distribution_of_types):
	var file = FileAccess.open(path_to_card_rarity, FileAccess.READ)
	if file:
		var json_rarity_data = file.get_as_text()
		file.close()
		var json = JSON.new()
		var parsed_rarity_data = json.parse(json_rarity_data)
		if parsed_rarity_data.error == OK:
			var rarity_data = parsed_rarity_data.result
		else:
			print("error loading cards")
	
	
	

func instantiate(coords):
	position = coords
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func highlight():
	$GarbagePileHighlight.show()

func deselect():
	$GarbagePileHighlight.hide()
	
func _on_select_pressed() -> void:
	highlight()
