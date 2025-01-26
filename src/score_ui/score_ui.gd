extends Control
class_name ScoreUI

static var instance : ScoreUI


@onready var _score : Label = $Control/VBoxContainer/HBoxContainer/Score
@onready var _pass_fail : Label = $Control/VBoxContainer/pass_fail
@onready var _description : Label = $Control/VBoxContainer/description

@onready var _retry_button : Button = $Control2/HBoxContainer2/Retry
@onready var _relisten_button : Button = $Control2/HBoxContainer2/Relisten
@onready var _next_level_button : Button = $Control2/HBoxContainer2/NextLevelButton

@onready var _ap : AnimationPlayer = $AnimationPlayer

signal retry
signal relisten
signal next_level


const MAIN_MENU = preload("res://src/main_menu/main_menu.tscn")


func _ready():
	instance = self


func bam():
	var pitch = 440
	Synth.player.play_note(pitch)

# Stars from 0 to 3
func show_score(score: float, passed: bool, stars: int, desc: String):
	visible = true
	_score.text = "%0.1f%%: " % (score * 100)
	if not passed:
		_score.text += "🥶🥶🥶"
	for i in range(stars):
		_score.text += "⭐"
	_description.text = str(desc)
	
	if passed:
		_pass_fail.text = "PASS"
		_retry_button.visible = false
		_next_level_button.visible = true
		_next_level_button.grab_focus()
	else:
		_pass_fail.text = "FAIL"
		_retry_button.visible = true
		_next_level_button.visible = false
		_retry_button.grab_focus()
	
	_ap.stop(false)
	_ap.play("score_slam")
	_next_level_button.disabled = false
	_retry_button.disabled = false
	_relisten_button.disabled = false
	await _ap.animation_finished


func hide_score():
	_next_level_button.disabled = true
	_retry_button.disabled = true
	_relisten_button.disabled = true
	_ap.stop(true)
	_ap.play("score_away")
	await _ap.animation_finished
	visible = false


func _on_menu_pressed() -> void:
	get_tree().root.add_child(load("res://src/main_menu/main_menu.tscn").instantiate())
	MainGame.singleton.queue_free()
	queue_free()


func _on_retry_pressed() -> void:
	await hide_score()
	retry.emit()


func _on_next_level_button_pressed() -> void:
	await hide_score()
	next_level.emit()


func _on_relisten_pressed() -> void:
	await hide_score()
	relisten.emit()
