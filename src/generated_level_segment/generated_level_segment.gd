extends Node3D
class_name GeneratedLevelSegment


var rng = RandomNumberGenerator.new()


# Set by GeneratedLevel
var level : GeneratedLevel


# map[Vector3i]true whether a local tile is occupied.
var occupancy = {}


# Checks occupancy so we don't place objects in the same spot twice.
func _maybe_add_block(block, local : Vector3i):
	if local in occupancy:
		return
	
	occupancy[local] = true
	block.transform.origin = Vector3(local)
	add_child(block)


func _ready():
	randomize()
	rng.seed = randi()
	
	# TODO: Generate some more interesting patterns.
	var floor = TILE_3W3L.instantiate()
	add_child(floor)
	
	# Possibly generate a master popper block.
	if rng.randf() < 0.1:
		if not level.master_popper_generated:
			level.master_popper_generated = true
			# TODO: Rotate the special blocks.
			var random_pos = Vector3i(rng.randi_range(-1, 1) * 2, 2, rng.randi_range(-1, 1) * 2)
			_maybe_add_block(MASTER_POPPER.instantiate(), random_pos)
	
	# Possibly generate a special block.
	if rng.randf() < 0.3:
		# TODO: Rotate the special blocks.
		var random_pos = Vector3i(rng.randi_range(-1, 1) * 2, 2, rng.randi_range(-1, 1) * 2)
		_maybe_add_block(REPEATER.instantiate(), random_pos)
	
	# Pepper in a few obstacles.
	for _o in range(rng.randi_range(1, 3)):
		var random_pos = Vector3i(rng.randi_range(-1, 1) * 2, 2, rng.randi_range(-1, 1) * 2)
		_maybe_add_block(OBSTACLE.instantiate(), random_pos)


# const SPIKE = preload(spike)
const MASTER_POPPER = preload("res://src/tile_master_popper/tile_master_popper.tscn")
const REPEATER = preload("res://src/repeater_obstacle/repeater_obstacle.tscn")
const OBSTACLE = preload("res://src/tile_obstacle/tile_obstacle.tscn")
const TILE_3W3L = preload("res://src/tile_3w3l/tile_3w3l.tscn")
