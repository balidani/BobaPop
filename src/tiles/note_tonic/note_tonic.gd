extends StaticBody3D
class_name NoteTonic

@onready var _ap : AnimationPlayer = $AnimationPlayer
@onready var _asp : AudioStreamPlayer3D = $AudioStreamPlayer3D


func bounce(_bubble: BouncyBubble, _last_velocity):
	#_asp.play(0.0)
	_ap.stop(false)
	_ap.play("bounce")
	# Synth.player.play_note(69)
	_bubble.current_note = 69