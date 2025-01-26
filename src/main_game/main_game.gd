extends Node3D
class_name MainGame


static var singleton : MainGame


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	singleton = self
