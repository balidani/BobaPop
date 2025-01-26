extends StaticBody3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Dirty hack to remove z fighting
	var basis_amt = 0.0
	var origin_amt = 0.1
	var rng = RandomNumberGenerator.new()
	rng.seed = str(global_transform).hash()
	transform.origin += Vector3(0, rng.randf(), 0) * origin_amt
	transform.basis = Basis().rotated(transform.basis.x, basis_amt).rotated(transform.basis.z, basis_amt)
