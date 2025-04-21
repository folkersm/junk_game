@tool
extends EditorScript
var distribution_of_types_default = {"industrial": 1,
"nature":1,
"food":1,
"paper":1,
"plastic":5,
"glass":1,
"metal":1,
"tech":1,
"fabric":1,
"toxic":1,}

# Called when the script is executed (using File -> Run in Script Editor).
func _run() -> void:
	print("helo")
	var verticle_offset = 10
	var text_scale = 1.9
	var node = get_scene()
	var scoreTrack = node.get_child(0).get_child(4)
	var index = 0
	var score_types = distribution_of_types_default.keys()
	var label_children = scoreTrack.get_children()
	var scores = label_children[1]
	var labels = label_children[0]
	var score
	var label
	for i in 10:
		label = labels.get_child(i)
		score = scores.get_child(i)
		label.scale = Vector2(text_scale,text_scale)
		label.position = Vector2(100,index*20*text_scale-verticle_offset)
		label.text = score_types[index]
		score.scale = Vector2(text_scale,text_scale)
		score.position = Vector2(0,index*20*text_scale-verticle_offset)
		score.text = str(0)
		index+=1
