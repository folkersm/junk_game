extends Node2D
var default_map = [[0,0,0,0,0],[0,0,0,0,0],[0,0,0,0,0],[0,0,0,0,0],[0,0,0,0,0]]

func _ready():
	for i in default_map:
		for j in i:
			j = 0

func start_game():
	var selected_zone = $ItemList.get_selected_items()
	var main_game_scene = preload("res://main.tscn").instantiate()
	get_tree().root.add_child(main_game_scene)
	get_tree().current_scene.queue_free()  # queue_free() avoids immediate removal
	get_tree().current_scene = main_game_scene
	main_game_scene.build_map(default_map)
	
	
