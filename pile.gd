extends Node2D

var source = "pile"
var distro_of_types_default = {"industrial": 1,
"nature":1,
"food":1,
"paper":10,
"plastic":1,
"glass":1,
"metal":1,
"tech":1,
"fabric":1,
"toxic":1}
var coords : Vector2
var distro_of_types_prob
var distro_of_types
var chance_of_card: float = .5
var production_amount: int = 1
signal signal_generate_card(type)
signal signal_generate_resource(type)
var main_view

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func init(quantities, in_coords):# used by board scene to init new piles before they are placed on screen
	coords = in_coords
	distro_of_types = quantities
	create_distro() 
	determine_graphic()
	

func determine_graphic():
	#put logic here to determine graphic to use based on the distribution of garbage types
	$GarbagePile.texture =load("res://Piles/garbage_pile.png")
	

func create_distro(): # creates a percentage composition for each type
	var total_stuff_in_pile = 0
	for i in distro_of_types:
		total_stuff_in_pile += distro_of_types[i]
	var running_total = 0
	distro_of_types_prob = distro_of_types
	for i in distro_of_types:
		running_total += float(distro_of_types[i])/total_stuff_in_pile
		distro_of_types_prob[i] = running_total
	
func select_randomly(): # chooses a resource type from your distribution of types
	var output = 0
	var random = randf_range(0.000001,.99999999)
	var distro_values = distro_of_types_prob.values()
	if random > 0 and random < distro_values[0]:
		output = distro_of_types_prob.keys()[0]
	else: # distro uses a array of increasing thressholds, the algoirhtm checks each threshhold in order to see which gap the random number falls in
		for i in range(len(distro_values)-1):
			if random > distro_values[i] and random < distro_values[i+1]:
				output = distro_of_types_prob.keys()[i+1]
				break
	return output

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func deselect():
	$GarbagePileHighlight.hide()
	
func _on_select_pressed() -> void:
	main_view.player_board_focus = coords
	
func activate():
	$DigAnimation.play("wiggle")
	var type = select_randomly()
	var random_action = randf_range(0.0,1.0)
	if (random_action < chance_of_card):
		generate_card(type)
	else:
		generate_resource(type)
	# somehow I need to track the chances of getting a resource vs a card. 
	
func generate_card(type):
	signal_generate_card.emit(type)
	
func generate_resource(type):
	signal_generate_resource.emit(coords, type, production_amount, source)
