extends Node3D
class_name Spike


func _on_tile_with_sound_bounced(bubble: BouncyBubble, last_velocity: Variant) -> void:
	if bubble.immune != true:
		# TODO: Bubble pop
		bubble.queue_free()
	else:
		bubble.immune = false
