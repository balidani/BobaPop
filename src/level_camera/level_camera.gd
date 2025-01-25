extends Node3D
class_name LevelCamera


@export var target : Node :
	set(t):
		target = t
		set_process(true)

@export var camera: Camera3D

@export_group("Zoom")
@export var zoom_minimum = 16
@export var zoom_maximum = 4
@export var zoom_speed = 10

@export_group("Rotation")
@export var rotation_speed = 120

var camera_rotation:Vector3
var zoom = 15


func _ready():
	
	camera_rotation = rotation_degrees # Initial rotation
	
	pass

func _process(delta):
	if target == null:
		set_process(false)
		return
	
	# Set position and rotation to targets
	
	self.position = self.position.lerp(target.position, delta * 4)
	rotation_degrees = rotation_degrees.lerp(camera_rotation, delta * 6)
	
	camera.position = camera.position.lerp(Vector3(0, 0, zoom), 8 * delta)
	
	handle_input(delta)

# Handle input

func handle_input(delta):
	
	# Rotation
	
	var input := Vector3.ZERO
	
	input.y = Input.get_axis("camera_left", "camera_right")
	input.x = Input.get_axis("camera_up", "camera_down")
	
	camera_rotation += input.limit_length(1.0) * rotation_speed * delta
	camera_rotation.x = clamp(camera_rotation.x, -40, -30)
	
	# Zooming
	
	zoom += Input.get_axis("zoom_in", "zoom_out") * zoom_speed * delta
	zoom = clamp(zoom, zoom_maximum, zoom_minimum)
