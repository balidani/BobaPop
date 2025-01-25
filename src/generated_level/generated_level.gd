extends Node3D
class_name GeneratedLevel


var rng = RandomNumberGenerator.new()


# Whether there is already a master popper somewhere in this level.
var master_popper_generated = false


# map[Vector3i]true whether a local tile is occupied.
var occupancy = {}


# Adds tiles but only if they're not occupied
func _maybe_add_tile(segment, local):
	if local in occupancy:
		return
	
	occupancy[local] = true
	segment.level = self
	segment.transform.origin = Vector3(local * Vector3i(6, 0, 6))
	add_child(segment)


func _ready():
	randomize()
	rng.seed = randi()
	
	# Always generate a 3x3.
	for x in range(-1, 1 +1):
		for z in range(-1, 1 +1):
			_maybe_add_tile(SEGMENT.instantiate(), Vector3i(x, 0, z))
	
	# Floors.
	for _iterations in range(15):
		var turtle_origin = Vector3i(0, 0, 0)
		var turtle_direction = Vector3i(0, 0, 0)
		for _turtle in range(4):
			_maybe_add_tile(SEGMENT.instantiate(), turtle_origin)
			
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

const SEGMENT = preload("res://src/generated_level_segment/generated_level_segment.tscn")
