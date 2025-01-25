extends Node3D
class_name GeneratedLevelSegment


var rng = RandomNumberGenerator.new()


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
	
	# Possibly generate a special block.
	if rng.randf() < 0.3:
		var random_pos = Vector3i(rng.randi_range(-1, 1) * 2, 2, rng.randi_range(-1, 1) * 2)
		_maybe_add_block(REPEATER.instantiate(), random_pos)
	
	# Pepper a few obstacles.
	for _o in range(rng.randi() % 2):
		var random_pos = Vector3i(rng.randi_range(-1, 1) * 2, 2, rng.randi_range(-1, 1) * 2)
		_maybe_add_block(OBSTACLE.instantiate(), random_pos)


# const SPIKE = preload(spike)
const REPEATER = preload("res://src/repeater_obstacle/repeater_obstacle.tscn")
const OBSTACLE = preload("res://src/tile_obstacle/tile_obstacle.tscn")
const TILE_3W3L = preload("res://src/tile_3w3l/tile_3w3l.tscn")
