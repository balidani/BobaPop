extends Node3D
class_name LevelLighting


@onready var _light : DirectionalLight3D = $DirectionalLight3D
var rng = RandomNumberGenerator.new()


func new_level():
	_randomize()


# Just get a random angle for the light.
func _randomize():
	var b = global_transform.basis
	_light.transform.basis = Basis().rotated(-b.x, PI * 0.25).rotated(b.y, TAU * rng.randf())


func _ready():
	randomize()
	rng.seed = randi()
	_randomize()
