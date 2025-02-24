extends Control
class_name NoteUI

static var singleton : NoteUI


@onready var _listen_hint = $ListenHint
@onready var _play_hint = $PlayHint
@export var _note_progress : NoteProgress


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	singleton = self


func show_hint():
	_listen_hint.hint()


func show_play_hint():
	_play_hint.hint()


func reset():
	_note_progress.reset()
