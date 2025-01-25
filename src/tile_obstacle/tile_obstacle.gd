extends StaticBody3D
class_name TileObstacle

@onready var _ap : AnimationPlayer = $AnimationPlayer
@onready var _asp : AudioStreamPlayer3D = $AudioStreamPlayer3D


func bounce(_bubble: BouncyBubble, _last_velocity):
	#_asp.play(0.0)
	#_ap.play("bounce")
	Synth.player.play_note(57 + randi_range(0, 24))
