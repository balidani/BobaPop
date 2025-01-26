extends Node3D
class_name GeneratedLevelSegment

const SPIKE = preload("res://src/tiles/spike/spike.tscn")
const MASTER_POPPER = preload("res://src/tiles/tile_master_popper/tile_master_popper.tscn")
const REPEATER = preload("res://src/tiles/repeater_obstacle/repeater_obstacle.tscn")
const NOTE_TONIC = preload("res://src/tiles/note_tonic/note_tonic.tscn")
const NOTE_DOMINANT = preload("res://src/tiles/note_dominant/note_dominant.tscn")
const OBSTACLE = preload("res://src/tiles/tile_obstacle/tile_obstacle.tscn")
const OBSTACLE_CORNER = preload("res://src/tiles/tile_obstacle_corner/tile_obstacle_corner.tscn")
const TILE_3W3L = preload("res://src/tiles/tile_3w3l/tile_3w3l.tscn")
const BLACK_HOLE = preload("res://src/tiles/black_hole/black_hole.tscn")
const AMEN = preload("res://src/tiles/tile_amen/tile_amen.tscn")
const GIFT = preload("res://src/tiles/tile_gift/tile_gift.tscn")


var rng = RandomNumberGenerator.new()

# Set by GeneratedLevel
var level : GeneratedLevel

# map[Vector3i]true whether a local tile is occupied.
var occupancy = {}
var edge_candidates = {}

# Checks occupancy so we don't place objects in the same spot twice.
func _maybe_add_block(block, local : Vector3i):
	if local in occupancy:
		return
	
	occupancy[local] = true
	block.transform.origin = Vector3(local)
	add_child(block)

func _ready():
	rng.seed = str(global_position).hash()
	
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
		var random_kind = rng.randi_range(1, 3)
		var instance = null
		if random_kind == 1:
			instance = REPEATER.instantiate()
		elif random_kind == 2:
			instance = NOTE_TONIC.instantiate()
		else:
			instance = NOTE_DOMINANT.instantiate()
		
		_maybe_add_block(instance, random_pos)
	
	# Make a gift
	if rng.randf() < 0.1:
		var random_pos = Vector3i(rng.randi_range(-1, 1) * 2, 2, rng.randi_range(-1, 1) * 2)
		_maybe_add_block(GIFT.instantiate(), random_pos)
	
	# Make spikes
	if rng.randf() < 0.1:
		var random_pos = Vector3i(rng.randi_range(-1, 1) * 2, 2, rng.randi_range(-1, 1) * 2)
		_maybe_add_block(SPIKE.instantiate(), random_pos)
	
	# Make black hole
	if rng.randf() < 0.1:
		var random_pos = Vector3i(rng.randi_range(-1, 1) * 2, 2, rng.randi_range(-1, 1) * 2)
		_maybe_add_block(SPIKE.instantiate(), random_pos)
	
	# Pepper in a few obstacles.
	for _o in range(rng.randi_range(1, 3)):
		var random_pos = Vector3i(rng.randi_range(-1, 1) * 2, 2, rng.randi_range(-1, 1) * 2)
		var random_kind = rng.randi_range(1, 2)
		if random_kind == 1:
			_maybe_add_block(OBSTACLE.instantiate(), random_pos)
		else:
			_maybe_add_block(OBSTACLE_CORNER.instantiate(), random_pos)
	
		# Pepper in a few obstacles.
	for _o in range(rng.randi_range(1, 3)):
		var random_pos = Vector3i(rng.randi_range(-1, 1) * 2, 2, rng.randi_range(-1, 1) * 2)
		_maybe_add_block(AMEN.instantiate(), random_pos)
	
	
	# Mark edges
	for dz in range(-2, 3):
		for dx in range(-2, 3):
			if abs(dz) != 2 and abs(dx) != 2:
				continue
			edge_candidates[Vector3i(dx * 2, 0, dz * 2)] = 1
