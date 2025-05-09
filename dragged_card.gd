extends Sprite2D

@onready var deck = get_parent()
var card_name
var type
var upgrade
var level
var default_location = Vector2(150,250)
var drag_card

func _ready():
	position = default_location


func set_card(card):
	drag_card = card
	card_name = card.name
	type = card.type
	upgrade = card.upgrade
	level = card.level
	
func return_to_deck():
	deck.add_card(type, card_name, level, upgrade)
	hide()
	position = default_location
	
func release():
	hide()
	position = default_location
	
