extends Node
class_name NoteEvent

# The time this thing happened
var timestamp: float
# The pitch of this event (can be 0)
var pitch: float
# The type / description
var type: String
# If this event starts a long-running task, like a drum loop
var is_event_start: bool
# If this event stops a long-running task, like a drum loop
var is_event_end: bool


func _init(
	# The pitch of this event (can be 0)
	pitch: float,
	# The type / description
	type: String,
	# If this event starts a long-running task, like a drum loop
	is_event_start: bool,
	# If this event stops a long-running task, like a drum loop
	is_event_end: bool,
):
	self.timestamp = 0.0
	self.pitch = pitch
	self.type = type
	self.is_event_start = is_event_start
	self.is_event_end = is_event_end

# similarity_metrics.gd

# --- Feature Similarity Functions ---

func pitch_similarity(p1: float, p2: float) -> float:
	"""Calculates pitch similarity based on semitone difference."""
	var semitone_diff = abs(12.0 * log(p2 / p1) / log(2.0)) if p1 > 0 and p2 > 0 else 1000 # Large diff if pitch is 0 or negative
	return 1.0 - min(semitone_diff / 12.0, 1.0) # Scale and cap difference (max 1 octave diff considered)


func type_similarity(type1: String, type2: String) -> float:
	"""Simple instrument string equality for now."""
	return 1.0 if type1 == type2 else 0.5 # Example: instruments in same family get 0.5 (adjust as needed)

func long_running_event_addition(is_start: bool, is_end: bool, other_start: bool, other_end: bool) -> float:
	# Can't start and end at the same time!
	assert(!is_start || !is_end || is_start != is_end)
	assert(!other_start || !other_end || !other_start != other_end)
	if is_start:
		if other_start:
			return 1.0
		elif other_end:
			return 0.5
		return 0.0
	elif is_end:
		if other_end:
			return 1.0
		elif other_start:
			return 0.5
		return 0.0
	return 1.0

func event_similarity(other: NoteEvent, pitch_weight: float = 0.4, type_weight: float = 0.4, long_running_weight: float = 0.2, max_time_diff=0.25, max_time_diff_malus: float = 0.2) -> float:
	"""Calculates similarity between two musical events."""
	
	var time_diff = abs(self.timestamp - other.timestamp)
	if time_diff > max_time_diff:
		return 0.0
	var time_diff_malus = ((1/max_time_diff) * time_diff) * max_time_diff_malus
	
	var pitch_sim = pitch_similarity(self.pitch, other.pitch)
	var type_sim = type_similarity(
		self.type,
		other.type
	)
	var long_running_event_addition = long_running_event_addition(
		self.is_event_start,
		self.is_event_end,
		other.is_event_start,
		other.is_event_end,
	)
	
	return pitch_weight * pitch_sim \
		+ type_weight * type_sim \
		+ long_running_event_addition * long_running_weight \
		- time_diff_malus
