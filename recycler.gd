extends Node2D

var stack = []
var resource_path_score_tracker: String = "../ScoreTracker/Scores/"
var card_library

func _ready():
	card_library = get_node("../Deck").card_library

func on_frame_end():
	if len(stack) > 0:
		recycle()
		display_height()

func display_height():
	$StackHeight.text = str(len(stack))

func recycle():
	get_node("recycle_light/AnimationPlayer").play("recycle")
	var resource_type = stack[0]["type"]
	var cur_resouce_for_scrap = get_node(resource_path_score_tracker + "/" + resource_type)
	cur_resouce_for_scrap.text = str(int(cur_resouce_for_scrap.text) + stack[0]["level"])
	stack.pop_front()
	display_card()

func add_object(object):
	stack.append(object)
	display_card()
	display_height()
	
func display_card():
	if (len(stack) > 0):
		var top_card = stack[-1]
		print("recycler top card ",top_card)
		var image = card_library.get_node(top_card["type"] + "/" + top_card["name"] + "/image").texture
		$top_card.texture = image
		$CardLevel.text = str(top_card["level"])
		$CardLevel.show()
		$top_card.show()
	else:
		$top_card.hide()
		$CardLevel.hide()
		print("deck is empty")
