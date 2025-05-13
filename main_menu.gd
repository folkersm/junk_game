extends Node2D
var default_map =[]
var height = 5
var width = 6

func _ready():
	for i in width:
		default_map.append([])
		for j in height:
			default_map[i].append(null)
	

func start_game():
	var selected_zone = $ItemList.get_selected_items()
	var main_game_scene = preload("res://main.tscn").instantiate()
	get_tree().root.add_child(main_game_scene)
	get_tree().current_scene.queue_free()  # queue_free() avoids immediate removal
	get_tree().current_scene = main_game_scene
	main_game_scene.build_map(default_map)
	
	
