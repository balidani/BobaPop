extends Node3D


# Generate a random level for the main menu.
@export var _level_generator : LevelGenerator
@export var _level_lighting : LevelLighting


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_level_generator.generate_new_level()
	_level_lighting.random_angle()


const MAIN_GAME = preload("res://src/main_game/main_game.tscn")


func _on_main_menu_ui_play_button_pressed() -> void:
	get_tree().change_scene_to_packed(MAIN_GAME)
