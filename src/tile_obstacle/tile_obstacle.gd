extends StaticBody3D
class_name TileObstacle

@onready var _ap : AnimationPlayer = $AnimationPlayer
@onready var _asp : AudioStreamPlayer3D = $AudioStreamPlayer3D


func bounce(_bubble: BouncyBubble):
	MusicRecorder.singleton.record("obstacle")
	#_asp.play(0.0)
	_ap.play("bounce")
	_ap.stop(false)
	Synth.player.play_note(440 * abs(_bubble.linear_velocity.x))
