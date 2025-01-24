extends Node3D
class_name Bubble

@export var speed: float = 10.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _process(delta):
	global_transform.origin += global_transform.basis.z * -speed * delta

	if global_transform.origin.distance_to(Vector3.ZERO) > 100:
		queue_free()
