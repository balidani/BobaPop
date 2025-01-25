extends CharacterBody3D
class_name Player

signal coin_collected

@export_subgroup("Components")
@export var view: Node3D

@export_subgroup("Properties")
@export var movement_speed = 250
@export var jump_strength = 7

var movement_velocity: Vector3
var rotation_direction: float
var gravity = 0

var previously_floored = false

var jump_single = true
var jump_double = true

var coins = 0

var rng = RandomNumberGenerator.new()
var is_ai : bool = false
var last_fake_input : Vector3 = Vector3(1, 0, 0)
var fake_shots : int = 0
var t : float = 0

@onready var particles_trail = $ParticlesTrail
@onready var sound_footsteps = $SoundFootsteps
@onready var model = $Character
@onready var animation = $Character/AnimationPlayer

# Preload the bubble model
var BouncyBubbleScene = preload("res://src/bubble_path/bubble_path.tscn")

# Functions

func _ready() -> void:
	rng.seed = 12345

func _physics_process(delta):
	t += delta

	if not model:
		return

	# Handle functions

	handle_controls(delta)
	handle_gravity(delta)

	handle_effects(delta)

	# Movement

	var applied_velocity: Vector3

	applied_velocity = velocity.lerp(movement_velocity, delta * 10)
	applied_velocity.y = -gravity

	velocity = applied_velocity
	move_and_slide()

	# Rotation

	if Vector2(velocity.z, velocity.x).length() > 0:
		rotation_direction = Vector2(velocity.z, velocity.x).angle()

	rotation.y = lerp_angle(rotation.y, rotation_direction, delta * 10)

	# Falling/respawning

	if position.y < -10:
		get_tree().reload_current_scene()

	# Animation for scale (jumping and landing)

	model.scale = model.scale.lerp(Vector3(1, 1, 1), delta * 10)

	# Animation when landing

	if is_on_floor() and gravity > 2 and !previously_floored:
		model.scale = Vector3(1.25, 0.75, 1.25)
		Audio.play("res://sounds/land.ogg")

	previously_floored = is_on_floor()

# Handle animation(s)

func handle_effects(delta):

	particles_trail.emitting = false
	sound_footsteps.stream_paused = true

	if is_on_floor():
		var horizontal_velocity = Vector2(velocity.x, velocity.z)
		var speed_factor = horizontal_velocity.length() / movement_speed / delta
		if speed_factor > 0.05:
			if animation.current_animation != "walk":
				animation.play("walk", 0.1)

			if speed_factor > 0.3:
				sound_footsteps.stream_paused = false
				sound_footsteps.pitch_scale = speed_factor

			if speed_factor > 0.75:
				particles_trail.emitting = true

		elif animation.current_animation != "idle":
			animation.play("idle", 0.1)
	elif animation.current_animation != "jump":
		animation.play("jump", 0.1)

# Handle movement input

func handle_controls(delta):

	# Movement

	var input := Vector3.ZERO

	input.x = Input.get_axis("move_left", "move_right")
	input.z = Input.get_axis("move_forward", "move_back")
	
	if is_ai:
		if rng.randf() < 0.1:
			var dir = rng.randi_range(0, 4)
			if dir == 0:
				last_fake_input = Vector3(1, 0, 0)
			elif dir == 1:
				last_fake_input = Vector3(-1, 0, 0)
			elif dir == 2:
				last_fake_input = Vector3(0, 0, 1)
			elif dir == 3:
				last_fake_input = Vector3(0, 0, -1)
		input = last_fake_input
	
		if t > (fake_shots + 1) * 4 and fake_shots < 3:
			fake_shots += 1
			shoot_bubble()

	input = input.rotated(Vector3.UP, view.rotation.y)
	
	if input.length() > 1:
		input = input.normalized()
	movement_velocity = input * movement_speed * delta

	# Jumping

	if Input.is_action_just_pressed("jump") and not is_ai:
		shoot_bubble()
		#if jump_single or jump_double:
			#jump()

# Handle gravity

func handle_gravity(delta):

	gravity += 25 * delta

	if gravity > 0 and is_on_floor():

		jump_single = true
		gravity = 0

func shoot_bubble():
	# Start the player recording, if not already.
	if GameLoop.instance:
		if is_ai:
			GameLoop.instance.computer_recording_start()
		else:
			GameLoop.instance.player_recording_start()
	
	
	# Instance the bubble
	var bubble_instance : BouncyBubble = BouncyBubbleScene.instantiate() as BouncyBubble
	
	# Calculate the position in front of the player
	var forward_direction = -global_transform.basis.z.normalized()  # Get the forward direction vector
	var spawn_position = global_transform.origin + forward_direction * -0.5  # Adjust distance if needed
	spawn_position += Vector3(0, 1, 0)
	# Set the position of the cloud instance
	bubble_instance.global_transform.origin = spawn_position
	
	var yrot = rotation_direction + PI
	# Quantize
	yrot = round(rad_to_deg(yrot) / 45.0) * 45.0
	yrot = deg_to_rad(yrot)
	bubble_instance.rotation = Vector3(0, yrot, 0)

	GameLoop.instance.get_parent().add_child(bubble_instance)

# Jumping

func jump():

	Audio.play("res://sounds/jump.ogg")

	gravity = -jump_strength

	model.scale = Vector3(0.5, 1.5, 0.5)

	if jump_single:
		jump_single = false;
		jump_double = true;
	else:
		jump_double = false;

# Collecting coins

func collect_coin():

	coins += 1

	coin_collected.emit(coins)
