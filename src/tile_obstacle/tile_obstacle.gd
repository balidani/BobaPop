extends StaticBody3D
class_name TileObstacle

@onready var _ap : AnimationPlayer = $AnimationPlayer
@onready var _asp : AudioStreamPlayer3D = $AudioStreamPlayer3D


func bounce(_bubble: BouncyBubble, _last_velocity):
	#_asp.play(0.0)
	#_ap.stop(false)
	#_ap.play("bounce")
	var pitch = 440 * abs(_bubble.linear_velocity.x)
	MusicRecorder.instance.record(
		NoteEvent.new(
			pitch,
			"bounce",
			false,
			false,
		)
	)
	Synth.player.play_note(440 * abs(_bubble.linear_velocity.x))
