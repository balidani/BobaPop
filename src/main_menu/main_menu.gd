extends Node3D


# Generate a random level for the main menu.
@export var _level_generator : LevelGenerator
@export var _level_lighting : LevelLighting


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_level_generator.generate_new_level()
	_level_lighting.new_level()
