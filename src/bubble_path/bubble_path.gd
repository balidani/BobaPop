extends RigidBody3D
class_name BouncyBubble

# We use a dict as set
static var all_bubbles: Dictionary = {}
const NOP = {}


var last_velocity: Vector3 = Vector3.ZERO
var can_collide : bool = false
var immune : bool = false
var t = 0.0
var current_note = 69

static func add_bubble(bubble: BouncyBubble):
	all_bubbles[bubble] = NOP
	
static func remove_bubble(bubble: BouncyBubble):
	all_bubbles.erase(bubble)

func _enter_tree() -> void:
	add_bubble(self)
	
func _exit_tree() -> void:
	remove_bubble(self)

func _ready():
	get_node("CollisionShape3D").set_deferred("disabled", true)
	apply_central_impulse(-global_transform.basis.z * 5.0)

func _process(delta: float) -> void:
	t += delta
	if t > 0.2 and not can_collide:
		can_collide = true
		get_node("CollisionShape3D").set_deferred("disabled", false)

	if global_transform.origin.distance_to(Vector3.ZERO) > 100:
		print("Removing bubble that's too far away from home")
		queue_free()

func _integrate_forces(state) -> void:
	for i in range(state.get_contact_count()):
		last_velocity = state.get_contact_local_velocity_at_position(i)
	
func _on_body_entered(body: Node) -> void:
	#_asp.play(0.0)
	if body.has_method("bounce"):
		body.bounce(self, last_velocity)
