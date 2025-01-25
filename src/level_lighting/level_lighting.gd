extends Node3D
class_name LevelLighting

# Contains the current level lighting in a singleton.
static var instance : LevelLighting


@onready var _light : DirectionalLight3D = $DirectionalLight3D
@onready var _world_env : WorldEnvironment = $WorldEnvironment
@onready var _env : Environment = _world_env.environment


var rng = RandomNumberGenerator.new()


# Dark mode when the AI is playing.
@export var dark_mode : bool :
	set(d):
		dark_mode = d
		if d:
			_light.light_energy = 0.05
			_env.background_energy_multiplier = 0.05
		else:
			_light.light_energy = 2.0
			_env.background_energy_multiplier = 1.0


func new_level():
	dark_mode = true
	random_angle()


func random_angle():
	var b = global_transform.basis
	_light.transform.basis = Basis().rotated(-b.x, PI * 0.25).rotated(b.y, TAU * rng.randf())


func _ready():
	instance = self
	dark_mode = false
	randomize()
	rng.seed = randi()
	random_angle()
