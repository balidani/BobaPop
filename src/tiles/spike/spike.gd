extends StaticBody3D
class_name Spike


func bounce(_bubble : BouncyBubble, _last_velocity):
	MusicRecorder.instance.play_note(
		_bubble.current_note,
		"bounce",
	)
	
	if _bubble.immune != true:
		_bubble.queue_free()
	else:
		_bubble.immune = false
