extends RigidBody3D
class_name BouncyBubble

# We use a dict as set
static var all_bubbles: Dictionary = {}
const NOP = {}


@onready var _pop_effect : GPUParticles3D = $sparcs
@onready var _mesh : MeshInstance3D = $MeshInstance3D
@onready var _asp : AudioStreamPlayer3D = $AudioStreamPlayer3D
@onready var _glow : GlowEffect = $GlowEffect

var last_velocity: Vector3 = Vector3.ZERO
var can_collide : bool = false
var immune : bool = false
var t = 0.0
var current_note = 0

static func add_bubble(bubble: BouncyBubble):
	all_bubbles[bubble] = NOP
	
static func remove_bubble(bubble: BouncyBubble):
	all_bubbles.erase(bubble)


func pop():
	_pop_effect.emitting = true
	_mesh.visible = false
	_asp.play(0.0)
	
	# Pop gives some visual feedback.
	#MusicRecorder.instance.play_note(
		#57 + current_note,
		#"bubble_pop",
	#)
	# _glow.glow()
	
	# Emit for 100ms
	await get_tree().create_timer(0.1).timeout
	queue_free()


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


func _on_pop_timer_timeout() -> void:
	pop()
