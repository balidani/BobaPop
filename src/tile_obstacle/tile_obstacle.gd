extends StaticBody3D
class_name TileObstacle

@onready var _ap : AnimationPlayer = $AnimationPlayer
@onready var _glow : GlowEffect = $GlowEffect

var a_major = [440, 554, 659]

func bounce(_bubble: BouncyBubble, _last_velocity):
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
	if LevelLighting.instance.dark_mode:
		_glow.glow()


const _mat : StandardMaterial3D = preload("res://src/tile_obstacle/tile_obstacle.tres")
