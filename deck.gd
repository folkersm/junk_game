extends Node2D

var deck = [] #set only for testing purposes
var card_library = load('res://card_library.tscn').instantiate()
var resource_path_score_tracker: String = "../ScoreTracker/Scores/"
var can_drop = true
var dragging
@onready var dragged_card = $DraggedCard
@onready var main_view = get_node("..")
@onready var board := get_node("../Board")
@onready var recycler = get_node("../Recycler")
@onready var recycler_base = get_node("../Recycler/base")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Scrap.hide()
	$Upgrade.hide()
	display_card()
	$CardCount.text = str(len(deck))

func add_card(type, nombre, level, upgrade):
	var card = {
			"type": type,
			"name": nombre,
			"level": level,
			"upgrade": upgrade
			}
	deck.append(card)
	$CardCount.text = str(len(deck))
	hide_cards()
	display_card()
	
func remove_card():
	if len(deck) > 0:
		var card = deck[-1]
		deck.pop_back()
		hide_cards()
		display_card()
		$CardCount.text = str(len(deck))
		return card
	else: return 0

func hide_cards(): 
	$RevealedCard.texture = null
	$RevealedCardHighlight.texture = null

func display_card():
	if (len(deck) > 0):
		var top_card = deck[-1]
		var image = card_library.get_node(top_card["type"] + "/" + top_card["name"] + "/image").texture
		$RevealedCard.texture = image
		$CardLevel.text = str(top_card["level"])
		$CardLevel.visible = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
		

func scrap_card():
	if Input.is_key_pressed(KEY_SHIFT):
		for item in deck:
			recycler.add_object(item)
		deck = []
		hide_cards()
		$CardCount.text = "0"
		$CardLevel.hide()
	elif len(deck) > 0:
		recycler.add_object(deck[-1])
		remove_card()
	
	

func _on_grab_card_pressed() -> void:
	if len(deck) > 0:
			$Scrap.show()
			$Upgrade.show()

func _on_upgrade_pressed() -> void:
	if len(deck) > 0:
		var resource_type = deck[-1]["upgrade"]
		var cur_resouce_for_upgrade = get_node(resource_path_score_tracker + "/" + resource_type)
		if int(cur_resouce_for_upgrade.text) >= deck[-1]["level"]:
			cur_resouce_for_upgrade.text = str(int(cur_resouce_for_upgrade.text) -deck[-1]["level"])
			deck[-1]["level"] +=1
			display_card()
		
func enable_dragging():
	can_drop = true

#revealed card is dragged meaning it is clicked
#remove the top card and insert its info into a dragged card node
#reveal the next card on the deck and let the deck continue to accumulate cards as usual
#if the dragged card lands on an empty space, populate the grid with that card
#if the dragged card misses the board, ends on the deck, or is placed on an occupied board tile send it back to the deck
#if the dragged card ends on the recycler send it there. 


func _input(event):
	if event is InputEventMouseButton and can_drop:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				# Check if the mouse is over the sprite
				if $CardBase.get_rect().has_point($CardBase.to_local(event.position)) and len(deck) > 0:
					dragged_card.show()
					dragged_card.texture = card_library.get_node(deck[-1]["type"] + "/" + deck[-1]["name"] + "/image").texture
					# remove card and send card info to dragged card
					dragged_card.set_card(deck[-1])
					remove_card()
					_on_grab_card_pressed()
					dragging = true
					get_viewport().set_input_as_handled()
			elif dragging:
				dragging = false
				handle_drop(event.position)
				

	elif event is InputEventMouseMotion and dragging:
		dragged_card.global_position += event.relative

func handle_drop(mouse_position):
	var board_node = board  # Adjust if your board is structured differently
	var local_pos = board.to_local(mouse_position)
	var tile_coords = board.local_to_map(local_pos)-Vector2i(1,1)
	var recycler_pos = recycler.to_local(mouse_position)

	# Defensive bounds check
	var x = tile_coords.x
	var y = tile_coords.y
	if y >= 0 and y < board.grid.size() and x >= 0 and x < board.grid[y].size():
		if board.grid_is_empty(Vector2i(x,y)):
			var nombre = dragged_card.card_name
			var level = dragged_card.level
			var type = dragged_card.type
			board.add_building(nombre, level, tile_coords, type)
			dragged_card.release()
			can_drop = false
			# Do something: maybe snap it to tile or mark as occupied
			#board.grid[y][x] = 1  # Mark tile as now occupied
		else:
			$DraggedCard.return_to_deck()
			print("Tile occupied! Do something else...")
			# e.g. move it back to starting position
	elif recycler_base.get_rect().has_point(recycler_base.to_local(mouse_position)):
		recycler.add_object(dragged_card.drag_card)
		dragged_card.release()
		print("in recycler debug deck")
	else: #didn't land on board or recycler or deck, so send back to top of deck
		$DraggedCard.return_to_deck()
		print("sending dragged card back to deck")
