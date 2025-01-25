extends Control
class_name ScoreUI

static var instance : ScoreUI


@onready var _control : Control = $Control
@onready var _score : Label = $Control/VBoxContainer/HBoxContainer/Score
@onready var _pass_fail : Label = $Control/VBoxContainer/pass_fail
@onready var _description : Label = $Control/VBoxContainer/description

@onready var _retry_button : Button = $Control/VBoxContainer/HBoxContainer2/Retry
@onready var _next_level_button : Button = $Control/VBoxContainer/HBoxContainer2/NextLevelButton


signal retry
signal next_level


func _ready():
	instance = self


@onready var _ap : AnimationPlayer = $AnimationPlayer


func bam():
	var pitch = 440
	Synth.player.play_note(pitch)


func show_score(score, passed, desc):
	_control.visible = true
	_score.text = "%0.1f%%" % (score * 100)
	_description.text = str(desc)
	
	if passed:
		_pass_fail.text = "PASS"
		_retry_button.visible = false
		_next_level_button.visible = true
	else:
		_pass_fail.text = "FAIL"
		_retry_button.visible = true
		_next_level_button.visible = false
	
	_ap.stop(false)
	_ap.play("score_slam")
	await _ap.animation_finished


const MAIN_MENU = preload("res://src/main_menu/main_menu.tscn")


func _on_menu_pressed() -> void:
	get_tree().change_scene_to_packed(MAIN_MENU)


func _on_retry_pressed() -> void:
	_ap.stop(true)
	_ap.play("score_away")
	await _ap.animation_finished
	retry.emit()


func _on_next_level_button_pressed() -> void:
	_ap.stop(true)
	_ap.play("score_away")
	await _ap.animation_finished
	next_level.emit()
