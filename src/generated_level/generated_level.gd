extends Node3D
class_name GeneratedLevel


var rng = RandomNumberGenerator.new()


# Whether there is already a master popper somewhere in this level.
var master_popper_generated = false


# map[Vector3i]true whether a local tile is occupied.
var occupancy = {}
var edge_candidates = {}
var forbidden_edges = {}


# Adds tiles but only if they're not occupied
func _maybe_add_tile(segment, local):
	if local in occupancy:
		return
	
	# Nuke any clashing edge candidate
	for dz in range(-2, 3):
		for dx in range(-2, 3):
			var v = Vector3i(local.x * 6 + dx, 0, local.z * 6 + dz)
			if v in edge_candidates:
				edge_candidates.erase(v)
			forbidden_edges[v] = 1
	
	occupancy[local] = true
	segment.level = self
	segment.transform.origin = Vector3(local * Vector3i(6, 0, 6))
	add_child(segment)

	# Add new edge candidates
	if is_instance_of(segment, GeneratedLevelSegment):
		var segment_segment : GeneratedLevelSegment = segment as GeneratedLevelSegment
		for key : Vector3i in segment_segment.edge_candidates:
			var v = Vector3i(local.x * 6 + key.x, 0, local.z * 6 + key.z)
			if v not in forbidden_edges:
				edge_candidates[v] = 1


func _ready():
	print("Level generating with seed %s" % rng.seed)
	
	# Generate a cross to spawn in.
	for x in range(-1, 1 +1):
		_maybe_add_tile(SEGMENT_SPAWN.instantiate(), Vector3i(x, 0, 0))
	for z in range(-1, 1 +1):
		_maybe_add_tile(SEGMENT_SPAWN.instantiate(), Vector3i(0, 0, z))
	
	# Always generate a 3x3.
	for x in range(-1, 1 +1):
		for z in range(-1, 1 +1):
			var segment = SEGMENT.instantiate()
			segment.rng.seed = rng.seed # Segments are seeded additionally by their position.
			_maybe_add_tile(segment, Vector3i(x, 0, z))
	
	# Floors.
	for _iterations in range(4):
		var turtle_origin = Vector3i(0, 0, 0)
		var turtle_direction = Vector3i(0, 0, 0)
		for _turtle in range(8):
			var segment = SEGMENT.instantiate()
			segment.rng.seed = rng.seed # Segments are seeded additionally by their position.
			_maybe_add_tile(segment, turtle_origin)
			
			if rng.randf() < 0.8:
				# New direction for the turtle.
				var sign = 1
				if rng.randf() < 0.5:
					sign = -1
				
				var axis = 1
				if rng.randf() < 0.5:
					axis = 3
				
				if axis == 1:
					turtle_direction = Vector3i(sign, 0, 0)
				else:
					turtle_direction = Vector3i(0, 0, sign)
			
			turtle_origin += turtle_direction
	
	for key in edge_candidates:
		var segment = SEGMENT_EDGE.instantiate()
		segment.transform.origin = Vector3(key)
		add_child(segment)

const SEGMENT = preload("res://src/generated_level_segment/generated_level_segment.tscn")
const SEGMENT_SPAWN = preload("res://src/generated_level_segment_spawn/generated_level_segment_spawn.tscn")
const SEGMENT_EDGE = preload("res://src/generated_level_segment_edge/generated_level_segment_edge.tscn")
