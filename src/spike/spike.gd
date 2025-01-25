extends StaticBody3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func bounce(_bubble, _last_velocity):
	if _bubble.immune != true:
		_bubble.queue_free()
	else:
		_bubble.immune = false
