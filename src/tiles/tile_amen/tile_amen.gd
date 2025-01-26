extends StaticBody3D
class_name TileAmen
# Plays AmenBros

@onready var _ap : AnimationPlayer = $AnimationPlayer
@onready var _asp_dot_net: AudioStreamPlayer3D = $AmenPlayer3d
@onready var _glow : GlowEffect = $GlowEffect

static var playing : bool = false

func bounce(_bubble: BouncyBubble, _last_velocity):
	if playing:
		_asp_dot_net.stop()
		playing = false
	else:
		_asp_dot_net.play()
		playing = true
	
	MusicRecorder.instance.record(
		NoteEvent.new(0, "amen", playing, not playing)
	)

	if LevelLighting.instance.dark_mode:
		_glow.glow()
