extends Node2D

var deck = [] #set only for testing purposes

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Scrap.hide()
	$Upgrade.hide()
	$Build.hide()
	display_card()
	$CardCount.text = str(len(deck))

func add_card(name, level):
	var card = {
			"name": name,
			"level": level
			}
	deck.append(card)
	$CardCount.text = str(len(deck))
	hide_cards()
	display_card()
	
func remove_card() -> int:
	if len(deck) > 0:
		var card = deck[-1]
		$CardCount.text = str(len(deck))
		hide_cards()
		display_card()
		deck.pop_back()
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
			$RevealedCard.texture = load("res://Cards/rock.png")
	else:
		print("deck is empty")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_grab_card_pressed() -> void:
	if len(deck) > 0:
		var file_path ="res://Cards/" + str(deck[-1]["name"]) + "h.png"
		if FileAccess.file_exists(file_path):
			$RevealedCardHighlight.texture = load(file_path)
			$Scrap.show()
			$Build.show()
			$Upgrade.show()
		else:
			print("couldn't find card")
	else:
		print("no cards in the deck")
