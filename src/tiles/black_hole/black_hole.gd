extends Node3D
class_name BlackHole


func _on_tile_with_sound_bounced(bubble: BouncyBubble, last_velocity: Variant) -> void:
	bubble.pop()
