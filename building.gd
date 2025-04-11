extends Node2D

var object_name: String
var object_level: int
var object_location: Vector2i

func init(name, level, location):
	object_name = name
	object_level = level
	object_location = location
	set_photos(name)
	
#func set_photos(name):
	#var photo_path = str("res://Cards/",name,".png")
	#
	#if FileAccess.file_exists(photo_path):
		#var img = Image.new()
		#img.load(photo_path)
		#print(img)
		#$photo.texture = img
	#else:
		#print(str("building photo for",name,"not found"))
		#var img = Image.new()
		#img.load("res://Cards/rock.png")
		#$photo.texture.set_data(img)
	#
func set_photos(name):
	var photo_path = "res://Cards/%s.png" % name

	if FileAccess.file_exists(photo_path):
		var texture = load(photo_path)
		$photo.texture = texture
	else:
		var texture = load("res://Cards/rock.png")
		$photo.texture = texture

	
