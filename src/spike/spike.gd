extends StaticBody3D
class_name Spike

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func bounce(_bubble : BouncyBubble, _last_velocity):
	MusicRecorder.instance.play_note(
		NoteEvent.new(
			_bubble.current_note,
			"bounce",
			false,
			false,
		)
	)
	
	if _bubble.immune != true:
		_bubble.queue_free()
	else:
		_bubble.immune = false
