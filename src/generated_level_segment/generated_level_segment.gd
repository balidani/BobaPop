extends Node3D
class_name GeneratedLevelSegment


const SPIKE = preload("res://src/tiles/spike/spike.tscn")
const MASTER_POPPER = preload("res://src/tiles/tile_master_popper/tile_master_popper.tscn")
const REPEATER = preload("res://src/tiles/repeater_obstacle/repeater_obstacle.tscn")
const NOTE_TONIC = preload("res://src/tiles/note_tonic/note_tonic.tscn")
const NOTE_DOMINANT = preload("res://src/tiles/note_dominant/note_dominant.tscn")
const TILE_EFFECT = preload("res://src/tiles/tile_effect/tile_effect.tscn")
const TILE_INSTRUMENT = preload("res://src/tiles/tile_instrument/tile_instrument.tscn")
const OBSTACLE = preload("res://src/tiles/tile_obstacle/tile_obstacle.tscn")
const OBSTACLE_CORNER = preload("res://src/tiles/tile_obstacle_corner/tile_obstacle_corner.tscn")
const TILE_3W3L = preload("res://src/tiles/tile_3w3l/tile_3w3l.tscn")
const BLACK_HOLE = preload("res://src/tiles/black_hole/black_hole.tscn")
const AMEN = preload("res://src/tiles/tile_amen/tile_amen.tscn")
const GIFT = preload("res://src/tiles/tile_gift/tile_gift.tscn")
const GRAVITY_PUSH = preload("res://src/tiles/tile_gravity_push/tile_gravity_push.tscn")


var rng = RandomNumberGenerator.new()

# Set by GeneratedLevel
var level : GeneratedLevel

# map[Vector3i]true whether a local tile is occupied.
var occupancy = {}
var edge_candidates = {}

# Checks occupancy so we don't place objects in the same spot twice.
func _maybe_add_block(block, local : Vector3i, orientation : int):
	if local in occupancy:
		return
	
	occupancy[local] = true
	# int -> orientation
	block.transform.basis = Basis().rotated(transform.basis.y, PI * 0.5 * orientation)
	block.transform.origin = Vector3(local)
	add_child(block)

func _ready():
	rng.seed += str(global_position).hash()
	
	var difficulty = 3.0
	if GameLoop.instance != null:
		difficulty = GameLoop.instance.difficulty
	
	# Possibly generate a master popper block.
	if difficulty > 4.0:
		if rng.randf() < 0.1:
			if not level.master_popper_generated:
				level.master_popper_generated = true
				# TODO: Rotate the special blocks.
				var random_pos = Vector3i(rng.randi_range(-1, 1) * 2, 2, rng.randi_range(-1, 1) * 2)
				var random_orientation = rng.randi() % 4
				_maybe_add_block(MASTER_POPPER.instantiate(), random_pos, random_orientation)
	
	# Possibly generate a special block.
	if rng.randf() < 0.9:
		# TODO: Rotate the special blocks.
		var random_pos = Vector3i(rng.randi_range(-1, 1) * 2, 2, rng.randi_range(-1, 1) * 2)
		var random_orientation = rng.randi() % 4
		var random_kind = rng.randi_range(1, 4)
		var instance = null
		if random_kind == 1:
			instance = REPEATER.instantiate()
		elif random_kind == 2:
			instance = NOTE_TONIC.instantiate()
		elif random_kind == 3:
			instance = NOTE_DOMINANT.instantiate()
		elif random_kind == 4:
			instance = TILE_EFFECT.instantiate()
		# else:
			# instance = TILE_INSTRUMENT.instantiate()
		
		_maybe_add_block(instance, random_pos, random_orientation)
	
	# Make gravity thing
	if difficulty > 1.0:
		if rng.randf() < 0.2:
			var random_pos = Vector3i(rng.randi_range(-1, 1) * 2, 2, rng.randi_range(-1, 1) * 2)
			var random_orientation = rng.randi() % 4
			_maybe_add_block(GRAVITY_PUSH.instantiate(), random_pos, random_orientation)
	
	# Make a repeater
	if rng.randf() < 0.3:
		var random_pos = Vector3i(rng.randi_range(-1, 1) * 2, 2, rng.randi_range(-1, 1) * 2)
		var random_orientation = rng.randi() % 4
		_maybe_add_block(REPEATER.instantiate(), random_pos, random_orientation)
	
	# Make a gift
	if difficulty > 2.0:
		if rng.randf() < 0.2:
			var random_pos = Vector3i(rng.randi_range(-1, 1) * 2, 2, rng.randi_range(-1, 1) * 2)
			var random_orientation = rng.randi() % 4
			_maybe_add_block(GIFT.instantiate(), random_pos, random_orientation)
	
	# Make spikes
	if difficulty > 1.0:
		if rng.randf() < 0.2:
			var random_pos = Vector3i(rng.randi_range(-1, 1) * 2, 2, rng.randi_range(-1, 1) * 2)
			var random_orientation = rng.randi() % 4
			_maybe_add_block(SPIKE.instantiate(), random_pos, random_orientation)
	
	# Make black hole
	if difficulty > 1.0:
		if rng.randf() < 0.2:
			var random_pos = Vector3i(rng.randi_range(-1, 1) * 2, 2, rng.randi_range(-1, 1) * 2)
			var random_orientation = rng.randi() % 4
			_maybe_add_block(BLACK_HOLE.instantiate(), random_pos, random_orientation)
	
	# Make amen hole
	if rng.randf() < 0.2:
		var random_pos = Vector3i(rng.randi_range(-1, 1) * 2, 2, rng.randi_range(-1, 1) * 2)
		var random_orientation = rng.randi() % 4
		_maybe_add_block(AMEN.instantiate(), random_pos, random_orientation)
	
	# Pepper in a few obstacles.
	for _o in range(rng.randi_range(1, 1 + int(difficulty))):
		var random_pos = Vector3i(rng.randi_range(-1, 1) * 2, 2, rng.randi_range(-1, 1) * 2)
		var random_orientation = rng.randi() % 4
		var random_kind = rng.randi_range(1, 2)
		if random_kind == 1:
			_maybe_add_block(OBSTACLE.instantiate(), random_pos, random_orientation)
		else:
			_maybe_add_block(OBSTACLE_CORNER.instantiate(), random_pos, random_orientation)
	
	
	# Mark edges
	for dz in range(-2, 3):
		for dx in range(-2, 3):
			if abs(dz) != 2 and abs(dx) != 2:
				continue
			edge_candidates[Vector3i(dx * 2, 0, dz * 2)] = 1
