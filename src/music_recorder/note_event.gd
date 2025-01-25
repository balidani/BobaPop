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

func event_similarity(other: NoteEvent, pitch_weight: float = 0.4, type_weight: float = 0.4, long_running_weight: float = 0.2) -> float:
	"""Calculates similarity between two musical events."""
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
		+ long_running_event_addition * long_running_weight

	

# --- List Similarity Function ---

func list_similarity(list_a: Array[NoteEvent], list_b: Array[NoteEvent], time_window: float = 0.2) -> float:
	"""
	Calculates similarity between two lists of musical events.

	Args:
		list_a: First list of event dictionaries.
		list_b: Second list of event dictionaries.
		time_window: Time window for matching events (in seconds).

	Returns:
		Similarity score (0.0 to 1.0).
	"""
	var total_similarity: float = 0.0
	var matched_count: int = 0
	var b_copy: Array = list_b.duplicate(true) # Create a copy to avoid modifying original list

	for event_a in list_a:
		var best_match: Dictionary = {} # Initialize as empty Dictionary to avoid null type issues
		var max_sim: float = -1.0
		var best_match_index: int = -1 # Initialize best_match_index

		for i in range(b_copy.size()):
			var event_b = b_copy[i]
			if abs(event_a.timestamp - event_b.timestamp) <= time_window:
				var sim = event_similarity(event_a, event_b)
				if sim > max_sim:
					max_sim = sim
					best_match = event_b
					best_match_index = i # Store the index of the best match

		if best_match_index != -1: # Check if a best_match_index was actually found
			total_similarity += max_sim
			matched_count += 1
			b_copy.remove_at(best_match_index)  # Remove matched event from copy

	# Penalty for unmatched events (simplified - just counts unmatched in list_a for now)
	var unmatched_penalty = (list_a.size() - matched_count) * 0.2  # Example penalty per unmatched event

	var final_similarity = maxf(0.0, (total_similarity / float(list_a.size())) - unmatched_penalty) # Normalize and apply penalty, ensure not negative
	return final_similarity


# --- Example Usage (for testing in Godot) ---

func _ready():
	var list1 = [
		{"timestamp": 1.0, "pitch": 440.0, "instrument": "brass"},
	]
