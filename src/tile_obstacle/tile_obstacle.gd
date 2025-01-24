extends StaticBody3D
class_name TileObstacle


@onready var _ap : AnimationPlayer = $AnimationPlayer
@onready var _asp : AudioStreamPlayer3D = $AudioStreamPlayer3D


func bounce(_bubble):
	_asp.play(0.0)
	_ap.play("bounce")
