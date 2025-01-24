extends RigidBody3D
class_name BouncyBubble


@onready var _asp : AudioStreamPlayer3D = $AudioStreamPlayer3D


var t = 0.0
func _process(delta: float) -> void:
	t += delta
	
	apply_central_impulse(-global_transform.basis.z * 2.0)
	set_process(false)

func _on_body_entered(body: Node) -> void:
	_asp.play(0.0)
	MusicRecorder.singleton.record("bubble")
	if body.has_method("bounce"):
		body.bounce(self)
