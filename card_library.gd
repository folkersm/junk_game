extends Node

var probability_dist = {}

func _ready() -> void:
	generate_card_probs()
	

#rather than hard-coding a list of card details, I'm going to use
func generate_card_probs(): # produce a data structure that holds all types and their probabilities
	probability_dist = {}
	var cards
	for type in get_children():
		cards = {}
		for card in type.get_children():
			cards[card.get_name()] = card.rarity
		probability_dist[type.get_name()] = cards

func get_probs():
	if probability_dist == {}:
		generate_card_probs()
	return probability_dist
	
func get_card(nombre, type):
	return get_node(str(type) + "/" + str(nombre))
	
func get_upgrade(type, nombre):
	return get_node(type + "/" + nombre).upgrade
