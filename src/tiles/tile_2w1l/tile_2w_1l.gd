extends StaticBody3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Dirty hack to remove z fighting
	var rng = RandomNumberGenerator.new()
	rng.seed = str(global_transform).hash()
	transform.origin += Vector3(rng.randf(), rng.randf(), rng.randf()).normalized() * 0.01
	# transform.basis = Basis().rotated(transform.basis, 0.01)
