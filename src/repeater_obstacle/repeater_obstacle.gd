extends StaticBody3D
class_name RepeaterObstacle


@onready var _ap : AnimationPlayer = $AnimationPlayer
@onready var _asp : AudioStreamPlayer3D = $AudioStreamPlayer3D


var BouncyBubbleScene = preload("res://src/bubble_path/bubble_path.tscn")

var count = 0

func spawn_bubble(incoming : Vector3, rot : float):
	var bubble_instance : BouncyBubble = BouncyBubbleScene.instantiate() as BouncyBubble
	
	var yrot = atan2(incoming.x, incoming.z)
	yrot = round(rad_to_deg(yrot) / 45.0) * 45.0
	yrot = deg_to_rad(yrot)
	yrot += rot

	var forward_direction = -incoming * 2
	var spawn_position = global_transform.origin + forward_direction
	# Floating above ground so no drag
	spawn_position += Vector3(0, 1, 0)
	
	bubble_instance.rotation = Vector3(0, yrot, 0)
	
	# Add the cloud instance to the scene
	get_parent().add_child(bubble_instance)
	# 
	bubble_instance.global_transform.origin = spawn_position

func bounce(_bubble : RigidBody3D, _last_velocity : Vector3):
	
	var incoming : Vector3 = _last_velocity.normalized()
	
	_bubble.queue_free()

	if count < 100:
		count += 1
		spawn_bubble(-incoming, PI / 4)
		spawn_bubble(-incoming, -PI / 4)
