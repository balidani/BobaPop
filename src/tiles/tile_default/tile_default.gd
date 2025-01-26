extends StaticBody3D
class_name TileDefault


func _ready() -> void:
	# Dirty hack to remove z fighting
	var basis_amt = 0.01
	var origin_amt = 0.3
	var rng = RandomNumberGenerator.new()
	rng.seed = str(global_transform).hash()
	transform.origin += Vector3(0, rng.randf(), 0) * origin_amt
	transform.basis = Basis().rotated(transform.basis.x, basis_amt).rotated(transform.basis.z, basis_amt)



func _on_area_3d_area_entered(_area: Area3D) -> void:
	queue_free()
