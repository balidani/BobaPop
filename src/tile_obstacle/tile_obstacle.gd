extends StaticBody3D
class_name TileObstacle

@onready var _ap : AnimationPlayer = $AnimationPlayer
@onready var _glow : GlowEffect = $GlowEffect

func bounce(_bubble: BouncyBubble, _last_velocity):
	_ap.play("bounce")
	MusicRecorder.instance.play_note(
		NoteEvent.new(
			57 + randi_range(0, 24),
			"bounce",
			false,
			false,
		)
	)
	if LevelLighting.instance.dark_mode:
		_glow.glow()
