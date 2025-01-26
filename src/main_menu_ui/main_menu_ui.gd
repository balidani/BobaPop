extends Control
class_name MainMenuUI


signal play_button_pressed
signal free_play_button_pressed


@onready var _main : Control = $Main
@onready var _credits : Control = $Credits


@onready var _play_button : Button = $Main/Control2/HBoxContainer/Play


var credits = false :
	set(c):
		credits = c
		_main.visible = !c
		_credits.visible = c


@onready var _ap : AnimationPlayer = $AnimationPlayer


func _ready():
	_ap.play("yhee_yoobubbles")
	_play_button.grab_focus()


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_play_pressed() -> void:
	play_button_pressed.emit()


func _on_chaos_slider_chaos_changed(value: Variant) -> void:
	Difficulty.difficulty = value


func _on_free_play_pressed() -> void:
	free_play_button_pressed.emit()
