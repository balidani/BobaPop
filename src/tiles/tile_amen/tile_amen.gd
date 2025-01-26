extends Node3D
class_name TileAmen
# Plays AmenBros


@onready var _asp_dot_net: AudioStreamPlayer3D = $AmenPlayer3d
var _self_playing: bool = false

static var _playing_asp = null

func _on_tile_with_sound_bounced(_bubble: BouncyBubble, _last_velocity: Variant) -> void:
	var playing = _playing_asp != null
	if Difficulty.difficulty < 6:
		# We only want one amen break.
		if playing:
			_playing_asp.stop()
			_playing_asp = null
		else:
			_asp_dot_net.play()
			_playing_asp = _asp_dot_net
	
	else:
		# MADNESS
		if _self_playing:
			_asp_dot_net.stop()
		else:
			_asp_dot_net.play()
	
	MusicRecorder.instance.record(
		NoteEvent.new(0, "amen", playing, not playing)
	)
