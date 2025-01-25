extends Node
class_name MusicRecorder

# Access from random objects by MusicRecorder.instance.<method>
# This contains the currently recording MusicRecorder.
static var instance : MusicRecorder


func _ready() -> void:
	instance = self


# Emitted when the recording is finished.
signal finished


# Records notes into a "recording", which then has to be replicated.
var recording: Array[NoteEvent] = []


# All things that make sounds that matter for the game score must call record()
func record(event: NoteEvent):
	event.timestamp = t - _recording_start_t
	recording.push_back(event)


# When the recording was started. Used to normalize timestamps.
var _recording_start_t = 0.0
var _recording_end_t = INF


var is_recording = false :
	set(i):
		is_recording = true
		set_process(true)


func start(max_duration_s : float):
	if is_recording: return
	print("Recording started: ", self)
	instance = self
	t = 0.0
	_recording_start_t = t
	_recording_end_t = t + max_duration_s
	recording = []
	is_recording = true


func stop():
	print("Recording stopped: ", self)
	is_recording = false


func _finish_recording():
	if not is_recording: return
	print("Recording finished")
	finished.emit()
	is_recording = false
	# Save the recording.sad d
	var file = FileAccess.open("user://recording.dat", FileAccess.WRITE)
	file.store_string(str(recording))


# Keep track of time.
var t = 0.0
func _process(delta: float) -> void:
	if not is_recording:
		return
	
	t += delta
	# dsprint("%s >= %s" % [t, _recording_end_t])
	if t >= _recording_end_t:
		_finish_recording()
		set_process(false)
		return

func rate_player_recording(player_recording: MusicRecorder) -> float:
	return rate_recording_similarity(self.recording, player_recording.recording)

static func rate_recording_similarity(goal_recording: Array[NoteEvent], user_recording: Array[NoteEvent], time_window: float = 0.2) -> float:
	"""
	Calculates similarity between two lists of musical events.

	Args:
		user_recording: First list of event dictionaries.
		goal_recording: Second list of event dictionaries.
		time_window: Time window for matching events (in seconds).

	Returns:
		Similarity score (0.0 to 1.0).
	"""
	assert(!goal_recording.is_empty())
	if user_recording.is_empty():
		print("No recording")
		return 0.0

	var total_similarity: float = 0.0
	var matched_count: int = 0
	var goal_recording_cpy: Array[NoteEvent] = goal_recording.duplicate(false) # Create a copy to avoid modifying original list
	
	var user_time_offset = user_recording.back().timestamp - goal_recording.back().timestamp
	print("user_time_offset:", user_time_offset)

	var first_timestamp_with_offset_and_time_window = goal_recording.front().timestamp + user_time_offset - time_window

	var last_user_event = user_recording.front()
		
	for user_event in user_recording:
		if user_event.timestamp < first_timestamp_with_offset_and_time_window:
			# These notes are out of bounds.
			matched_count += 1
			continue
	
		var max_sim: float = -1.0
		var best_match_index: int = -1 # Initialize best_match_index

		for i in range(goal_recording_cpy.size()):
			var already_had_matches = false
			var goal_event = goal_recording_cpy[i]
			if abs(user_event.timestamp - goal_event.timestamp) <= time_window:
				already_had_matches = true
				var sim = user_event.event_similarity(goal_event)
				if sim > max_sim:
					max_sim = sim
					best_match_index = i # Store the index of the best match
				if sim == 1:
					# We have a perfect match. No need to keep looking.
					break
			elif already_had_matches:
				# We have already had matches here.
				# We assume that the lists are in-order, so we can break.
				break

		if best_match_index != -1: # Check if a best_match_index was actually found
			total_similarity += max_sim
			matched_count += 1
			goal_recording_cpy.remove_at(best_match_index)  # Remove matched event from copy

	# Penalty for unmatched events (simplified - just counts unmatched in user_recording for now)
	var unmatched_penalty = (user_recording.size() - matched_count) * 0.2  # Example penalty per unmatched event

	var final_similarity = maxf(0.0, (total_similarity / float(user_recording.size())) - unmatched_penalty) # Normalize and apply penalty, ensure not negative
	return final_similarity
