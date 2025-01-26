extends StaticBody3D
class_name TileWithSound


signal bounced(bubble: BouncyBubble, last_velocity)


# This node gets the bounce animation. Resets scale, if that's a problem
# wrap your thing into a Node3D first.
@export var animate_node : Node3D :
	set(a):
		animate_node = a
		if not is_node_ready():
			await ready
		var animate_node_parent = animate_node.get_parent()
		if not animate_node_parent.is_node_ready():
			await animate_node_parent.ready
		# Parent under the animated node to get the bounce animation.
		animate_node.reparent(_bounce)

# If set, change the effect in the synth when hit
@export var effect_changer : bool = false

# This node gets a material.
@export var material_to_mesh : MeshInstance3D :
	set(a):
		material_to_mesh = a


@onready var _ap : AnimationPlayer = $AnimationPlayer
@onready var _bounce : Node3D = $BounceAnim
@onready var _glow : GlowEffect = $GlowEffect


# map[note]material
static var note_to_material = {}


# What note this tile should play.
# From 0 till fun
@export var note = -1 :
	set(n):
		note = n
		if not is_node_ready():
			await ready
		_glow.color = _note_to_color(note)
		if material_to_mesh:
			material_to_mesh.material_override = _maybe_generate_note_material(note)


static func _note_to_color(note) -> Color:
	return Color.from_hsv(float(note) / COLORS, 1.0, 1.0)


static func _maybe_generate_note_material(note) -> StandardMaterial3D:
	if note in note_to_material:
		return note_to_material[note]
	
	var color = _note_to_color(note)
	
	var mat = MATERIAL.duplicate()
	mat.albedo_color = color
	note_to_material[note] = mat
	return note_to_material[note]


func give_material_to_mesh(mesh : MeshInstance3D):
	mesh.material_override = _maybe_generate_note_material(note)


func bounce(bubble: BouncyBubble, last_velocity):
	_ap.play("bounce")

	# Map note from 0,1,2,3 to GDSiON notes.
	# In GDSiON notes, 69 is A3 and each increment represents a half step.
	# Note id        0 1 2 3
	# Scale position 1 3 5 7

	var gdsion_note = 69  # A
	if note == 1:
		gdsion_note = 73  # C#, we're in A major
	elif note == 2:
		gdsion_note = 76  # E
	elif note == 3:
		gdsion_note = 80  # G#
	
	if effect_changer:
		MusicRecorder.instance.change_effet(10)
	else:
		MusicRecorder.instance.play_note(
			gdsion_note, # TODO: More fun
			"bounce",
		)
	if LevelLighting.instance.dark_mode:
		_glow.glow()
	
	bounced.emit(bubble, last_velocity)


func _ready():
	if note == -1: # Random note
		note = str(global_transform.origin).hash() % COLORS


# 4 colors for 1, 3, 5 and 7
const COLORS = 4


const MATERIAL = preload("res://src/tiles/tile_with_sound/tile_color_material.tres")
