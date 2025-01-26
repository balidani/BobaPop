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
		self.position = self.position.lerp(Vector3(0, 0, 0), delta * 4)
		camera.position = camera.position.lerp(Vector3(0, 0, 0), 8 * delta)
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
	var input_zoom := 0.0
	
	if not GameLoop.instance.computer_playing:
		input_zoom = Input.get_axis("zoom_in", "zoom_out")
		input.y = Input.get_axis("camera_left", "camera_right")
		input.x = Input.get_axis("camera_up", "camera_down")
	
	camera_rotation += input.limit_length(1.0) * rotation_speed * delta
	camera_rotation.x = clamp(camera_rotation.x, -60, -50)
	
	# Zooming
	
	zoom += input_zoom * zoom_speed * delta
	zoom = clamp(zoom, zoom_maximum, zoom_minimum)
