extends Node3D
class_name TileMasterPopper


# Effect when master popper is popped.
const EFFECT = preload("res://src/master_popper_effect/master_popper_effect.tscn")


func _on_tile_with_sound_bounced(bubble: BouncyBubble, last_velocity: Variant) -> void:
	add_child(EFFECT.instantiate())
	WokedShing.instance.cameo()
	GameLoop.instance.master_popper_popped()
