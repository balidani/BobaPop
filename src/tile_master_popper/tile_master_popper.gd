extends StaticBody3D
class_name TileMasterPopper

@onready var _ap : AnimationPlayer = $AnimationPlayer
@onready var _asp : AudioStreamPlayer3D = $AudioStreamPlayer3D


func bounce(_bubble: BouncyBubble, _last_velocity):
	_ap.stop(false)
	_ap.play("bounce")
	var pitch = 440 * abs(_bubble.linear_velocity.x)
	MusicRecorder.instance.record(
		NoteEvent.new(
			pitch,
			"bounce",
			false,
			false,
		)
	)
	Synth.player.play_note(pitch)
	add_child(EFFECT.instantiate())
	GameLoop.instance.master_popper_popped()


# Effect when master popper is popped.
const EFFECT = preload("res://src/master_popper_effect/master_popper_effect.tscn")