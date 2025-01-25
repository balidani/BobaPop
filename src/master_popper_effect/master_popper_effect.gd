extends Node3D
class_name MasterPopperEffect


@onready var _ap : AnimationPlayer = $AnimationPlayer


func _ready():
	_ap.stop()
	_ap.play("effect")
