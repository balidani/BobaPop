extends Node3D
class_name BubbleSpawn


@onready var _container : Node3D = $Bubbles


func reset():
	# Clear out container
	for c in _container.get_children():
		c.queue_free()


func spawn():
	_container.add_child(BUBBLE.instantiate())


func _ready():
	spawn()


const BUBBLE = preload("res://src/bubble_path/bubble_path.tscn")
