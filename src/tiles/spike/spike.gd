extends Node3D
class_name Spike


func _on_tile_with_sound_bounced(bubble: BouncyBubble, last_velocity: Variant) -> void:
	if bubble.immune != true:
		bubble.pop()
	else:
		bubble.immune = false
