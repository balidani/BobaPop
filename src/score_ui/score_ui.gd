extends Control
class_name ScoreUI

static var instance : ScoreUI


@export var _score : Label
@export var _pass_fail : Label
@export var _description : Label

@export var _score_total : Label
@export var _score_level : Label

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


# Small animation.
var score_total_target = 0.0
var score_level_target = 0.0

var score_total_text = 0.0 :
	set(st):
		score_total_text = st
		_score_total.text = "%d" % floor(st)
var score_level_text = 0.0 :
	set(st):
		score_level_text = st
		_score_level.text = "%d" % ceil(st)
func _process(delta):
	score_total_text = lerpf(score_total_text, score_total_target, delta * 4.0)
	score_level_text = lerpf(score_level_text, score_level_target, delta * 9.0)


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


func hide_and_show_totals():
	_next_level_button.disabled = true
	_retry_button.disabled = true
	_relisten_button.disabled = true
	_ap.stop(true)
	_ap.play("score_away_totals")
	score_total_target = GameLoop.instance.score_total
	score_level_target = GameLoop.instance.levels_cleared
	await _ap.animation_finished
	await get_tree().create_timer(2.0).timeout
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
	await hide_and_show_totals()
	next_level.emit()


func _on_relisten_pressed() -> void:
	await hide_score()
	relisten.emit()
