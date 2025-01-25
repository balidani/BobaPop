extends Control
class_name ScoreUI

static var instance : ScoreUI


@onready var _control : Control = $Control
@onready var _score : Label = $Control/VBoxContainer/HBoxContainer/Score
@onready var _pass_fail : Label = $Control/VBoxContainer/pass_fail
@onready var _description : Label = $Control/VBoxContainer/description


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
	else:
		_pass_fail.text = "FAIL"
	
	_ap.stop(false)
	_ap.play("score_slam")
	await _ap.animation_finished
