extends Node3D
class_name GeneratedLevelSegmentSpawn
# Special spawn that makes sure the player does not get stuck into obstacles.


var rng = RandomNumberGenerator.new()


# Set by GeneratedLevel
var level : GeneratedLevel


# map[Vector3i]true whether a local tile is occupied.
var occupancy = {}


# Checks occupancy so we don't place objects in the same spot twice.
func _maybe_add_block(block, local : Vector3i):
	if local in occupancy:
		return
	
	await get_tree().physics_frame
	
	occupancy[local] = true
	block.transform.origin = Vector3(local)
	add_child(block)


func _ready():
	rng.seed = str(global_position).hash()
	
	# Generate some more interesting patterns with tiles.
	if rng.randf() < 0.1:
		_maybe_add_block(TILE_3W3L.instantiate(), Vector3i(0, 0, 0))
	
	if rng.randf() < 0.3:
		var x = (rng.randi() % 2) * 2 - 1
		var z = (rng.randi() % 2) * 2 - 1
		_maybe_add_block(TILE_2W2L.instantiate(), Vector3i(x, 0, z))
	
	# TODO: Don't forget about 1W2L
	if rng.randf() < 0.6:
		var x = (rng.randi() % 2) * 3 - 1.5
		var z = (rng.randi() % 3) * 2 - 2
		_maybe_add_block(TILE_2W1L.instantiate(), Vector3i(x, 0, z))
	
	# Always generate a 3x3.
	for x in range(-1, 1 +1):
		for z in range(-1, 1 +1):
			_maybe_add_block(TILE.instantiate(), Vector3i(x * 2, 0, z * 2))


const TILE = preload("res://src/tile_default/tile_default.tscn")
const TILE_2W1L = preload("res://src/tile_2w1l/tile_2w1l.tscn")
const TILE_2W2L = preload("res://src/tile_2w2l/tile_2w2l.tscn")
const TILE_3W3L = preload("res://src/tile_3w3l/tile_3w3l.tscn")
