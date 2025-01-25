extends Control
class_name NoteUI

static var singleton : NoteUI


@onready var _note_progress : NoteProgress = $Control/TextureRect2/NoteProgress


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	singleton = self


func reset():
	_note_progress.reset()
