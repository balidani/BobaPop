extends Node
class_name MusicRecorder

# Access from random objects by MusicRecorder.singleton.<method>
static var singleton : MusicRecorder


# Records notes into a "recording", which then has to be replicated.
var recording = []


# All things that make sounds that matter for the game score must call record()
func record(sound):
	recording.push_back([t, sound])


# Start recording.
func _enter_tree() -> void:
	singleton = self


# Save the recording.
func _exit_tree() -> void:
	var file = FileAccess.open("user://recording.dat", FileAccess.WRITE)
	file.store_string(str(recording))


var t = 0.0
func _process(delta: float) -> void:
	t += delta
