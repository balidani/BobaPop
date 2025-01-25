extends Node
class_name MusicRecorder

# Access from random objects by MusicRecorder.singleton.<method>
static var singleton : MusicRecorder


func _ready() -> void:
	singleton = self


# Emitted when the recording is finished.
signal finished


# Records notes into a "recording", which then has to be replicated.
var recording = []


# All things that make sounds that matter for the game score must call record()
func record(sound):
	recording.push_back([t - _recording_start_t, sound])


# When the recording was started. Used to normalize timestamps.
var _recording_start_t = 0.0
var _recording_end_t = INF


var is_recording = false :
	set(i):
		is_recording = true
		set_process(true)


func start(max_duration_s : float):
	print("Recording started")
	t = 0.0
	_recording_start_t = t
	_recording_end_t = t + max_duration_s
	recording = []
	is_recording = true


func _finish_recording():
	print("Recording finished")
	finished.emit()
	is_recording = false
	# Save the recording.
	var file = FileAccess.open("user://recording.dat", FileAccess.WRITE)
	file.store_string(str(recording))


# Keep track of time.
var t = 0.0
func _process(delta: float) -> void:
	if not is_recording:
		return
	
	t += delta
	print("%s >= %s" % [t, _recording_end_t])
	if t >= _recording_end_t:
		_finish_recording()
		set_process(false)
		return
