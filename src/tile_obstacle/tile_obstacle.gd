extends StaticBody3D
class_name TileObstacle

@onready var _ap : AnimationPlayer = $AnimationPlayer
@onready var _asp : AudioStreamPlayer3D = $AudioStreamPlayer3D

var a_major = [440, 554, 659]

func bounce(_bubble: BouncyBubble, _last_velocity):
	#_asp.play(0.0)
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
