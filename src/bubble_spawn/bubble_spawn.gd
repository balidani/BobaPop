extends Node3D
class_name BubbleSpawn


@onready var _container : Node3D = $Bubbles


func reset():
	# Clear out container
	for c in _container.get_children():
		c.queue_free()


var t = 0.0
var _next_spawn_t = 0.0
func _process(delta: float) -> void:
	t += delta


func spawn():
	if t < _next_spawn_t: return
	_next_spawn_t = t + 0.5 # Rate limit to 500ms
	_container.add_child(BUBBLE.instantiate())


const BUBBLE = preload("res://src/bubble_path/bubble_path.tscn")
