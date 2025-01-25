extends Node3D
class_name GeneratedLevelSegmentEdge
# Special spawn that makes sure the player does not get stuck into obstacles.


var rng = RandomNumberGenerator.new()

# Checks occupancy so we don't place objects in the same spot twice.
func _add_block(block, local : Vector3i):
	await get_tree().physics_frame
	block.transform.origin = Vector3(local)
	add_child(block)


func _ready():
	rng.seed = str(global_position).hash()
	_add_block(TILE.instantiate(), Vector3i(0, 0, 0))
	_add_block(NOTE_DOMINANT.instantiate(), Vector3i(0, 2, 0))


const TILE = preload("res://src/tiles/tile_default/tile_default.tscn")
const NOTE_DOMINANT = preload("res://src/tiles/note_dominant/note_dominant.tscn")
