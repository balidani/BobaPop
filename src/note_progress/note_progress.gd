extends ColorRect
class_name NoteProgress

static var instance : NoteProgress


@onready var _progress_bar : Control = $ColorRect
@onready var _notes : Control = $Notes


var progress = 0.0 :
	set(p):
		progress = p
		_progress_bar.position.x = size.x * p


func add_note(event : NoteEvent, recording_length):
	var p = event.timestamp / recording_length
	# TODO: Note pitch
	var note = NOTE_SINGLE.instantiate()
	note.position = _progress_bar.position
	note.position.x = size.x * p
	_notes.add_child(note)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	instance = self
	progress = 0.0


const NOTE_DOUBLE = preload("res://src/note_double/note_double.tscn")
const NOTE_SINGLE = preload("res://src/note_single/note_single.tscn")
const NOTE_SINGLE_LONG = preload("res://src/note_single_long/note_single_long.tscn")
