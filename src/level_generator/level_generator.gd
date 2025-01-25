extends Node3D
class_name LevelGenerator


@onready var _container : Node3D = $Level
@export var use_generated_level = false


var computer_level
var real_level

var initial_level_setup


var rng = RandomNumberGenerator.new()


func reset_real_level():
	for c in _container.get_children():
		c.queue_free()
	_container.process_mode = Node.PROCESS_MODE_DISABLED
	real_level = initial_level_setup.duplicate()
	_container.add_child(real_level)


# Stop the level simulation.
func stop_level():
	# Do not process anything until start() is called.
	_container.process_mode = Node.PROCESS_MODE_DISABLED


# Start the level simulation.
func start_level():
	_container.process_mode = Node.PROCESS_MODE_INHERIT


func _ready():
	randomize()
	rng.seed = randi()
	stop_level()


# Remove all state and generate a new level.
func generate_new_level():
	# Wait in case not ready yet.
	if not is_node_ready():
		await ready
	# Clear out container
	for c in _container.get_children():
		c.queue_free()
		
	if use_generated_level:
		initial_level_setup = GENERATED_LEVEL.instantiate()
	else:
		# TODO: Hardcoded example level, replace with level generation
		initial_level_setup = HARDCODED_LEVEL.instantiate()
	
	computer_level = initial_level_setup.duplicate()
	_container.add_child(computer_level)


const HARDCODED_LEVEL = preload("res://src/level/level.tscn")
const GENERATED_LEVEL = preload("res://src/generated_level/generated_level.tscn")
