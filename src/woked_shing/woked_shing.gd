extends Control
class_name WokedShing

static var instance : WokedShing


@onready var _slide : Control = $Control
@onready var _ap : AnimationPlayer = $AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	instance = self


func cameo():
	_slide.visible = true
	_ap.play("woked_shing")
