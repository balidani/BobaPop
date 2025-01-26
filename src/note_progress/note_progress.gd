extends ColorRect
class_name NoteProgress

static var instance : NoteProgress


@onready var _progress_bar : Control = $ColorRect
@onready var _computer_notes : Control = $ComputerNotes
@onready var _player_notes : Control = $PlayerNotes


var player_recording = false :
	set(p):
		player_recording = p
		# Hide the computer notes to see the player attempt better.
		if player_recording:
			_computer_notes.modulate = Color(1.0, 1.0, 1.0, 0.5)
		else:
			_computer_notes.modulate = Color(1.0, 1.0, 1.0, 1.0)


var progress = 0.0 :
	set(p):
		progress = p
		_progress_bar.position.x = size.x * p


func add_note(event : NoteEvent, recording_length):
	var p = event.timestamp / recording_length
	# TODO: Note pitch
	var note = NOTE_SINGLE.instantiate()
	
	# Change colour based on whether the computer is playing or not.
	if GameLoop.instance.computer_playing:
		note.self_modulate = Color(1.0, 0.0, 0.5)
	else:
		note.self_modulate = Color(0.0, 1.0, 1.0)
	
	note.position = _progress_bar.position
	note.position.x = size.x * p
	var y = ((float(event.pitch) - 10.0) / 125.0) * size.y
	note.position.y += y
	
	if GameLoop.instance.computer_playing:
		_computer_notes.add_child(note)
	else:
		_player_notes.add_child(note)


func reset_player_notes():
	for c in _player_notes.get_children():
		c.queue_free()


func reset():
	for c in _computer_notes.get_children():
		c.queue_free()
	for c in _player_notes.get_children():
		c.queue_free()
	progress = 0.0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	instance = self
	progress = 0.0


const NOTE_DOUBLE = preload("res://src/note_double/note_double.tscn")
const NOTE_SINGLE = preload("res://src/note_single/note_single.tscn")
const NOTE_SINGLE_LONG = preload("res://src/note_single_long/note_single_long.tscn")
