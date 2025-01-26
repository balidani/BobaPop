extends StaticBody3D
class_name TileObstacle

@onready var _ap : AnimationPlayer = $AnimationPlayer
@onready var _glow : GlowEffect = $GlowEffect

func bounce(_bubble: BouncyBubble, _last_velocity):
	MusicRecorder.instance.play_note(
		57, # TODO: More fun
		"bounce",
	)
	if LevelLighting.instance.dark_mode:
		_glow.glow()
