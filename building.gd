extends Node2D

var object_name: String

func init(name):
	object_name = name
	set_photos(name)
	
func set_photos(name):
	var photo_path = str("res://Cards/",name,".png")
	
	if FileAccess.file_exists(photo_path):
		$photo.texture = photo_path
	else:
		print(str("building photo for",name,"not found"))
		$photo.texture = "res://Cards/rock.png"
	
	
