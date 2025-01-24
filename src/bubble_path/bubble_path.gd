extends RigidBody3D
class_name BouncyBubble

var t = 0.0
func _process(delta: float) -> void:
	t += delta
	if t < 1.0: return
	
	apply_central_impulse(-global_transform.basis.z * 2.0)
	set_process(false)
