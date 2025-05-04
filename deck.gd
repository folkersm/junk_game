extends Node2D

var deck = [] #set only for testing purposes
var card_library = load('res://card_library.tscn').instantiate()
var game_board_node 
var resource_path_score_tracker: String = "../ScoreTracker/Scores/"
var recycler
@onready var main_view = get_node("..")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	recycler = get_node("../Recycler")
	game_board_node= get_node("../Board")
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
	else:
		print("deck is empty")

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
	else:
		print("ain't no cards in the deck")

func _on_upgrade_pressed() -> void:
	if len(deck) > 0:
		var resource_type = deck[-1]["upgrade"]
		var cur_resouce_for_upgrade = get_node(resource_path_score_tracker + "/" + resource_type)
		if int(cur_resouce_for_upgrade.text) >= deck[-1]["level"]:
			cur_resouce_for_upgrade.text = str(int(cur_resouce_for_upgrade.text) -deck[-1]["level"])
			deck[-1]["level"] +=1
			display_card()
		else:
			print("can't upgrade bro, you need more" + resource_type)
