extends Node3D
class_name TileAmen
# Plays AmenBros


@onready var _asp_dot_net: AudioStreamPlayer3D = $AmenPlayer3d


static var playing : bool = false


func _on_tile_with_sound_bounced(_bubble: BouncyBubble, _last_velocity: Variant) -> void:
	if playing:
		_asp_dot_net.stop()
		playing = false
	else:
		_asp_dot_net.play()
		playing = true
	
	MusicRecorder.instance.record(
		NoteEvent.new(0, "amen", playing, not playing)
	)
