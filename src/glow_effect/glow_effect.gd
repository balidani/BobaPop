extends Node3D
class_name GlowEffect


var color :
	set(c):
		color = c
		_light.light_color = c


@onready var _ap : AnimationPlayer = $AnimationPlayer2
@onready var _light : OmniLight3D = $OmniLight3D


func glow():
	_light.visible = true
	_ap.play("glow")
