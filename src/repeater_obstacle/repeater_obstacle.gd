extends StaticBody3D
class_name RepeaterObstacle


@onready var _ap : AnimationPlayer = $AnimationPlayer
@onready var _asp : AudioStreamPlayer3D = $AudioStreamPlayer3D

var BouncyBubbleScene = preload("res://src/bubble_path/bubble_path.tscn")

var count = 0

func bounce(_bubble):
	if count < 2:
		count += 1
		var bubble_instance : BouncyBubble = BouncyBubbleScene.instantiate() as BouncyBubble
		
		# Calculate the position in front of the player
		var forward_direction = -global_transform.basis.z.normalized()  # Get the forward direction vector
		var spawn_position = global_transform.origin + forward_direction * -0.5  # Adjust distance if needed
		spawn_position += Vector3(0, 1, 0)
		# Set the position of the cloud instance
		bubble_instance.global_transform.origin = spawn_position
		
		bubble_instance.rotation = Vector3(0, PI, 0)
		
		# Add the cloud instance to the scene
		get_parent().add_child(bubble_instance)
