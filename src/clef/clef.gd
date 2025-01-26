extends Control
class_name Clef

static var instance : Clef


@onready var _ap : AnimationPlayer = $AnimationPlayer


var recording = false :
	set(r):
		recording = r
		if r:
			_ap.stop(true)
			_ap.play("clef_anim")
		else:
			_ap.stop(true)


func _ready():
	instance = self
