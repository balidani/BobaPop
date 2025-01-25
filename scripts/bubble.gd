extends Node3D
class_name Bubble

static var all_bubbles: dict[Bubble, null] = {}

@export var speed: float = 10.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	
func _enter_tree() -> void:
	all_bubbles[self] = null
	
func _exit_tree() -> void:
	all_bubbles.remove(self)

func _process(delta):
	global_transform.origin += global_transform.basis.z * -speed * delta

	if global_transform.origin.distance_to(Vector3.ZERO) > 100:
		queue_free()
