extends Node3D
class_name LevelLighting

# Contains the current level lighting in a singleton.
static var instance : LevelLighting


@onready var _light : DirectionalLight3D = $DirectionalLight3D
@onready var _world_env : WorldEnvironment = $WorldEnvironment
@onready var _env : Environment = _world_env.environment


var rng = RandomNumberGenerator.new()


var light_energy_target = 1.2
var background_energy_target = 0.5


# Dark mode when the AI is playing.
@export var dark_mode : bool :
	set(d):
		dark_mode = d
		if d:
			light_energy_target = 0.0
			background_energy_target = 0.05
		else:
			light_energy_target = 1.2
			background_energy_target = 0.5


func _process(delta):
	# _light.light_energy = lerpf(_light.light_energy, light_energy_target, delta * 4.0)
	# _env.background_energy_multiplier = lerpf(_env.background_energy_multiplier, background_energy_target, delta * 4.0)
	pass


func new_level():
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
