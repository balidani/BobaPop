extends Control
class_name MainMenuUI


signal play_button_pressed


@onready var _ap : AnimationPlayer = $AnimationPlayer


func _ready():
	_ap.play("yhee_yoobubbles")


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_play_pressed() -> void:
	play_button_pressed.emit()


func _on_chaos_slider_chaos_changed(value: Variant) -> void:
	Difficulty.difficulty = value
