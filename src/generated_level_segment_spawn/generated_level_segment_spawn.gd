extends Node3D
class_name GeneratedLevelSegmentSpawn
# Special spawn that makes sure the player does not get stuck into obstacles


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
	rng.seed = str(global_position).hash()
	
	# TODO: Generate some more interesting patterns.
	var floor = TILE_3W3L.instantiate()
	add_child(floor)


const TILE_3W3L = preload("res://src/tile_3w3l/tile_3w3l.tscn")
