extends Control
class_name Clef

static var instance : Clef


@onready var _ap : AnimationPlayer = $AnimationPlayer
@onready var _clef_thingy : Control = $TextureRect2/ClefThingy


var recording = false :
	set(r):
		recording = r
		if r:
			_ap.stop(true)
			_ap.play("clef_anim")
		else:
			_ap.stop(true)


func _process(delta : float) -> void:
	# Change colour based on whether the computer is playing or not.
	# TODO: Clean me uuuuup
	if GameLoop.instance.computer_playing:
		_clef_thingy.self_modulate = Color(1.0, 0.0, 0.5)
	else:
		_clef_thingy.self_modulate = Color(0.0, 1.0, 1.0)


func _ready():
	instance = self
