extends StaticBody3D
class_name TileObstacleCorner

@onready var _ap : AnimationPlayer = $AnimationPlayer
@onready var _glow : GlowEffect = $GlowEffect
@onready var _mesh : MeshInstance3D = $Anim2/tile_corner/Cube_006


# map[note]material
static var note_to_material = {}


# What note this tile should play.
# From 0 till fun
var note = 0 :
	set(n):
		note = n
		
		if note in note_to_material:
			_mesh.material_override = note_to_material[note]
			return
		
		var color = Color.from_hsv(float(note) / COLORS, 1.0, 1.0)
		
		var mat = MATERIAL.duplicate()
		mat.albedo_color = color
		_glow.color = color
		_mesh.material_override = mat
		note_to_material[note] = mat


static var playing = false


func bounce(_bubble: BouncyBubble, _last_velocity):
	_ap.play("bounce")
	MusicRecorder.instance.play_note(
		57 + note, # TODO: More fun
		"bounce",
	)
	if LevelLighting.instance.dark_mode:
		_glow.glow()


func _ready():
	note = str(global_transform.origin).hash() % COLORS


const COLORS = 4


const MATERIAL = preload("res://src/tiles/tile_obstacle/tile_obstacle.tres")