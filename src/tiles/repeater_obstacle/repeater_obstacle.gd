extends Node3D
class_name RepeaterObstacle


const BouncyBubbleScene = preload("res://src/bubble_path/bubble_path.tscn")


func spawn_bubble(incoming : Vector3, rot : float):
	var bubble_instance : BouncyBubble = BouncyBubbleScene.instantiate() as BouncyBubble
	
	var yrot = atan2(incoming.x, incoming.z)
	yrot = round(rad_to_deg(yrot) / 45.0) * 45.0
	yrot = deg_to_rad(yrot)
	yrot += rot

	var forward_direction = -incoming * 1
	var spawn_position = global_transform.origin + forward_direction
	# Floating above ground so no drag
	spawn_position += Vector3(0, 1, 0)
	
	bubble_instance.rotation = Vector3(0, yrot, 0)
	
	# Add the cloud instance to the scene
	get_parent().add_child(bubble_instance)
	# 
	bubble_instance.global_transform.origin = spawn_position


func _on_tile_with_sound_bounced(bubble: BouncyBubble, last_velocity: Variant) -> void:
	var incoming : Vector3 = last_velocity.normalized()
	
	# TODO: Bubble pop
	bubble.queue_free()

	spawn_bubble(-incoming, PI / 4)
	spawn_bubble(-incoming, -PI / 4)
