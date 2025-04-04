extends Node2D

var items = []
var size = 3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("here")
	$SlotSize.text = str(len(items)) + "/" + str(size)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func add_item(item):
	if items.length() < size:
		items.append(item)
	else:
		print("can't put an item")
		

	
func purchase_slot():
	size +=1
	$SlotSize.text = str(len(items)) + "/" + str(size)
	
