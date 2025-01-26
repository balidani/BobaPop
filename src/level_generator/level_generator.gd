extends Node3D
class_name LevelGenerator


@onready var _container : Node3D = $Level
@onready var _bg_music : AudioStreamPlayer = $BackgroundMusic
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
	real_level.rng.seed = rng.seed
	_container.add_child(real_level)


# Stop the level simulation.
func stop_level():
	if _bg_music != null:
		_bg_music.stop()
	# Do not process anything until start() is called.
	_container.process_mode = Node.PROCESS_MODE_DISABLED


# Start the level simulation.
func start_level():
	_bg_music.play()
	_bg_music.seek(0)
	_container.process_mode = Node.PROCESS_MODE_INHERIT


func _ready():
	stop_level()


func reset():
	# Wait in case not ready yet.
	if not is_node_ready():
		await ready
	# Clear out container
	for c in _container.get_children():
		c.queue_free()


# Remove all state and generate a new level.
func generate_new_level():
	print("generate_new_level with seed %s" % rng.seed)
	reset()

	if use_generated_level:
		var generated_level : GeneratedLevel = GENERATED_LEVEL.instantiate()
		generated_level.rng.seed = rng.seed
		initial_level_setup = generated_level.duplicate()
	else:
		# TODO: Hardcoded example level, replace with level generation
		initial_level_setup = HARDCODED_LEVEL.instantiate()
	
	computer_level = initial_level_setup.duplicate()
	_container.add_child(computer_level)


const HARDCODED_LEVEL = preload("res://src/level/level.tscn")
const GENERATED_LEVEL = preload("res://src/generated_level/generated_level.tscn")
