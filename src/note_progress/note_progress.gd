extends ColorRect
class_name NoteProgress

static var instance : NoteProgress


@onready var _progress_bar : Control = $ProgressBar
@onready var _computer_notes : Control = $ComputerNotes
@onready var _player_notes : Control = $PlayerNotes
@onready var _note_spacing : Control = $NoteSpacing

@onready var _computer_rest_symbols : Control = $ComputerRestSymbols
@onready var _player_rest_symbols : Control = $PlayerRestSymbols


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


var _last_note_progress = 0.0
func add_note(event : NoteEvent, recording_length):
	_last_note_progress = progress
	var p = event.timestamp / recording_length
	var note = notes[event.type.hash() % len(notes)].instantiate()
	
	note.position = _note_spacing.position
	note.position.x = size.x * p
	note.position.y = _note_spacing.get_child(int(event.pitch) % note_spacing_count).position.y
	
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


var _next_rest_progress = 0.125
func _process(delta : float) -> void:
	# Change colour based on whether the computer is playing or not.
	if GameLoop.instance.computer_playing:
		_computer_notes.modulate = Color(1.0, 0.0, 0.5)
		_computer_rest_symbols.modulate = Color(1.0, 0.0, 0.5)
		_progress_bar.modulate = Color(1.0, 0.0, 0.5)
	else:
		_player_notes.modulate = Color(0.0, 1.0, 1.0)
		_player_rest_symbols.modulate = Color(1.0, 0.0, 0.5)
		_progress_bar.modulate = Color(0.0, 1.0, 1.0)
	
	if progress < _next_rest_progress:
		return
		
	_next_rest_progress = progress + 0.125
		
	if progress - _last_note_progress > 0.125:
		_last_note_progress = progress
		# Add a rest symbol
		var rest_symbol = REST_SYMBOL.instantiate()
		rest_symbol.position.x = size.x * progress
		
		if GameLoop.instance.computer_playing:
			_computer_rest_symbols.add_child(rest_symbol)
		else:
			_player_rest_symbols.add_child(rest_symbol)


# Called when the node enters the scene tree for the first time.
var note_spacing_count = 1
func _ready() -> void:
	instance = self
	progress = 0.0
	_last_note_progress = -1.0
	note_spacing_count = _note_spacing.get_child_count()


var notes = [
	NOTE_DOUBLE,
	NOTE_SINGLE,
	NOTE_SINGLE_LONG,
]


const REST_SYMBOL = preload("res://src/rest_symbol/rest_symbol.tscn")


const NOTE_DOUBLE = preload("res://src/note_double/note_double.tscn")
const NOTE_SINGLE = preload("res://src/note_single/note_single.tscn")
const NOTE_SINGLE_LONG = preload("res://src/note_single_long/note_single_long.tscn")
