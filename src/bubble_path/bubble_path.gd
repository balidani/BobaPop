extends RigidBody3D
class_name BouncyBubble

@onready var _asp : AudioStreamPlayer3D = $AudioStreamPlayer3D

var last_velocity: Vector3 = Vector3.ZERO
var can_collide : bool = false
var t = 0.0

func _ready():
	get_node("CollisionShape3D").set_deferred("disabled", true)
	apply_central_impulse(-global_transform.basis.z * 5.0)

func _process(delta: float) -> void:
	t += delta
	if t > 0.2 and not can_collide:
		can_collide = true
		get_node("CollisionShape3D").set_deferred("disabled", false)

func _integrate_forces(state) -> void:
	for i in range(state.get_contact_count()):
		last_velocity = state.get_contact_local_velocity_at_position(i)
	
func _on_body_entered(body: Node) -> void:
	#_asp.play(0.0)
	if body.has_method("bounce"):
		body.bounce(self, last_velocity)
