extends StaticBody3D
class_name TileMasterPopper

@onready var _ap : AnimationPlayer = $AnimationPlayer
@onready var _asp : AudioStreamPlayer3D = $AudioStreamPlayer3D


func bounce(_bubble: BouncyBubble, _last_velocity):
	_ap.stop(false)
	_ap.play("bounce")
	MusicRecorder.instance.play_note(
		69,  # A4
		"bounce",
	)
	add_child(EFFECT.instantiate())
	WokedShing.instance.cameo()
	GameLoop.instance.master_popper_popped()


# Effect when master popper is popped.
const EFFECT = preload("res://src/master_popper_effect/master_popper_effect.tscn")
