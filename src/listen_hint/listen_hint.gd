extends Control
class_name ListenHint


@onready var _ap : AnimationPlayer = $AnimationPlayer
@onready var _ap2 : AnimationPlayer = $AnimationPlayer2
@onready var _slide : Control = $Slide


func _ready():
	_ap2.play("ear")


func hint():
	_slide.visible = true
	_ap.stop(true)
	_ap.play("listen_closely")
	await _ap.animation_finished
	_slide.visible = false
