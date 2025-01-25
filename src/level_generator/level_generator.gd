extends Node3D
class_name LevelGenerator


@onready var _container : Node3D = $Level


var computer_level
var real_level

var initial_level_setup


func reset_real_level():
	for c in _container.get_children():
		c.queue_free()
	_container.process_mode = Node.PROCESS_MODE_DISABLED
	real_level = initial_level_setup.duplicate()
	_container.add_child(real_level)


# Start the level simulation.
func start():
	_container.process_mode = Node.PROCESS_MODE_INHERIT


func _ready():
	# Do not process anything until start() is called.
	_container.process_mode = Node.PROCESS_MODE_DISABLED


# Remove all state and generate a new level.
func generate_new_level():
	# Wait in case not ready yet.
	if not is_node_ready():
		await ready
	# Clear out container
	for c in _container.get_children():
		c.queue_free()
	# TODO: Hardcoded example level, replace with level generation
	initial_level_setup = HARDCODED_LEVEL.instantiate()
	computer_level = initial_level_setup.duplicate()
	
	_container.add_child(computer_level)


const HARDCODED_LEVEL = preload("res://src/level/level.tscn")
