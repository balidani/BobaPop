extends Node3D
class_name Level


func reset():
	print("Level resetting")
	# Send a reset to all level objects that can be reset.
	for c in get_children():
		if c.has_method("reset"):
			c.reset()
