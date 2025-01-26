extends Node3D


# Generate a random level for the main menu.
@export var _level_generator : LevelGenerator
@export var _level_lighting : LevelLighting


func generate():
	_level_generator.generate_new_level()
	_level_lighting.random_angle()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	call_deferred("generate")


func _on_main_menu_ui_play_button_pressed() -> void:
	get_tree().root.add_child(load("res://src/main_game/main_game.tscn").instantiate())
	queue_free()


func _on_main_menu_ui_free_play_button_pressed() -> void:
	get_tree().root.add_child(load("res://src/free_play/free_play.tscn").instantiate())
	queue_free()
