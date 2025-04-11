extends Node2D

var deck: PackedInt32Array = [] #set only for testing purposes
var end: int = -1
var top_card = -1 #set only for testing purposes

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Scrap.hide()
	$Upgrade.hide()
	$Build.hide()
	display_card()

func add_card(name, level):
	if len(deck) == end+1:
		var card = {
			"name": name,
			"level": level
			}
		deck.append(card)
	else:
		deck[end] = name
		end += 1
	hide_cards()
	display_card()
	
func remove_card() -> int:
	if end >-1:
		var card = deck[end]
		deck[end] = -1
		end -=1
		hide_cards()
		if end != -1:
			display_card()
		return card
	else: return 0

func hide_cards(): 
	$RevealedCard.texture = null
	$RevealedCardHighlight.texture = null

func display_card():
	if (len(deck) > 0):
		var file_path ="res://Cards/" + str(deck[-1]) + ".png"
		if FileAccess.file_exists(file_path):
			$RevealedCard.texture = load(file_path)
		else:
			print("couldn't find card")
	else:
		print("deck is empty")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_grab_card_pressed() -> void:
	if len(deck) > 0:
		var file_path ="res://Cards/" + str(top_card) + "h.png"
		if FileAccess.file_exists(file_path):
			$RevealedCardHighlight.texture = load(file_path)
			$Scrap.show()
			$Build.show()
			$Upgrade.show()
		else:
			print("couldn't find card")
	else:
		print("no cards in the deck")
