extends Node
class_name GameLoop

# Access from random objects by Gameloop.instance.<method>
static var instance : GameLoop


@export var free_play = false


# "goal" contains the simulated recording. 
# "player" contains what the player is creating.
@export var _music_recorder_goal : MusicRecorder
@export var _music_recorder_player : MusicRecorder

@export var _level_camera : LevelCamera
@export var _level_generator : LevelGenerator
@export var _level_lighting : LevelLighting
@export var _player_spawner : PlayerSpawner

const USE_CONST_SEED = false
const CONST_LEVEL_SEED = 0

const SUCCESS_PERCENT_MIN = 0.6
const TWO_STARS_PERCENT_MIN = 0.74
const THREE_STARS_PERCENT_MIN = 0.85

var computer_hit_woked_shing: bool = false

# True when computer is playing.
var computer_playing = false :
	set(c):
		if computer_playing == c: return
		computer_playing = c
		computer_playing_changed.emit(c)
signal computer_playing_changed

# Keeps increasing without bounds.
var difficulty = Difficulty.difficulty


func master_popper_popped():
	print("Master popper popped. Computer:", computer_playing)
	
	var computer_was_player = computer_playing
	
	var woked_shing_event = NoteEvent.new(
			0, "woked shing", true, false
		)
	
	# If AI is recording, stop it and get ready for the player parts
	if computer_playing:
		computer_hit_woked_shing = true
		_music_recorder_goal.record(woked_shing_event)
		_remove_computer_stuff()
	else:
		_music_recorder_player.record(woked_shing_event)

	_player_spawner.remove_real_player()
	# Wait for master popper effect.
	await get_tree().create_timer(5.0).timeout
	if not computer_was_player:
		if computer_hit_woked_shing:
			_music_recorder_player.finish()
			# TODO: Swap this with comparison method once it works
		else:
			_music_recorder_player.stop()
			_level_generator.stop_level()
			_level_camera.target = _level_generator
			retry_level()


func _remove_computer_stuff():
	_music_recorder_goal.finish()
	_player_spawner.remove_computer_player()
	computer_playing = false
	_level_lighting.dark_mode = false


func player_recording_start():
	if _music_recorder_player.is_recording: return
	print("Starting the player recording")
	_music_recorder_player.start(Difficulty.time_value)


func computer_recording_start():
	if _music_recorder_goal.is_recording: return
	print("Starting the computer recording")
	_music_recorder_goal.start(Difficulty.time_value)


func retry_level_with_relisten():
	var gray : ShaderMaterial = shader_canvas.inst._gray_vignette.material
	gray.set_shader_parameter("MainAlpha", 0.0)
	var rainbow : ShaderMaterial = shader_canvas.inst._saturated_rainbow.material
	rainbow.set_shader_parameter("strength", 0.0)
		
	_level_camera.target = null
	NoteUI.singleton.reset()
	_level_generator.reset()
	print("Generating a new level")
	_level_generator.rng.seed = level_seed
	_level_generator.generate_new_level()
	_level_lighting.new_level()
	_level_camera.target = _level_generator
	
	if not free_play:
		await get_tree().create_timer(1.0).timeout
		NoteUI.singleton.show_hint()
		await get_tree().create_timer(2.0).timeout
		_level_lighting.dark_mode = true
		await get_tree().create_timer(1.0).timeout
		_player_spawner.rng.seed = level_seed
		_player_spawner.spawn_computer_player()
		print("Showing the level, computer mode")
		computer_playing = true
		computer_hit_woked_shing = false
		_level_generator.start_level()
		await _music_recorder_goal.finished
	_remove_computer_stuff()
	
	retry_level()


func retry_level():
	NoteProgress.instance.reset_player_notes()
	Clef.instance.recording = false
	print("Resetting the real level")
	for bubble in BouncyBubble.all_bubbles:
		bubble.queue_free()
	_level_generator.rng.seed = level_seed
	_level_generator.reset_real_level()
	await get_tree().create_timer(1.0).timeout
	NoteUI.singleton.show_play_hint()
	await get_tree().create_timer(1.0).timeout
	print("Spawning the real player")
	_player_spawner.spawn_real_player()
	_level_camera.target = _player_spawner.real_player
	_level_generator.start_level()
	await _music_recorder_player.finished
	
	if not free_play:
		score_game()
	else:
		while free_play:
			print("Free play: Reset the recorder")
			_music_recorder_player.stop()
			NoteProgress.instance.reset_player_notes()
			_music_recorder_player.start(Difficulty.time_value)
			await _music_recorder_player.finished
	
func score_game():
	print("Stopping level")
	_level_generator.stop_level()
	_player_spawner.remove_real_player()
	
	print("Comparing recordings")
	
	var challenge: MusicRecorder = _music_recorder_goal
	var player_recording: MusicRecorder = _music_recorder_player

	var success_percentage = challenge.rate_player_recording(player_recording)
	print("Similarity: %s" % success_percentage)

	var passed = true
	var stars = 0
	if success_percentage > THREE_STARS_PERCENT_MIN:
		stars = 3
	elif success_percentage > TWO_STARS_PERCENT_MIN:
		stars = 2
	elif success_percentage > SUCCESS_PERCENT_MIN:
		stars = 1
	else:
		passed = false

	
	var description;
	
	var loss_msgs = [
		"Truly a special try",
		"What an attempt",
		"win-adjacent",
		"You are unwinning",
		"So much enthusiasm",
		"So close to being sparkly!",
	]
	if success_percentage <= 0.6:
		var msg_rand = rng.randi() % loss_msgs.size();
		description = loss_msgs[msg_rand]
		var mat : ShaderMaterial = shader_canvas.inst._gray_vignette.material
		mat.set_shader_parameter("MainAlpha", 0.4)
	else:
		description = "flawless!"
		var mat : ShaderMaterial = shader_canvas.inst._saturated_rainbow.material
		mat.set_shader_parameter("strength", 0.3)

	ScoreUI.instance.show_score(success_percentage, passed, stars, description)

var level_seed = 0
func new_level():
	# level_seed = 1539753758 # Hardcoded for bug repro
	if USE_CONST_SEED:
		level_seed = 4278744844
	else:
		level_seed = rng.randi()
	print("Game loop initializing with seed %s and difficulty %s" % [level_seed, difficulty])
	
	retry_level_with_relisten()

var rng = RandomNumberGenerator.new()


func _ready():
	if _level_camera == null:
		push_error("No _level_camera, please assign one in the editor")
		breakpoint
		return
	if _level_generator == null:
		push_error("No _level_generator, please assign one in the editor")
		breakpoint
		return
	if _music_recorder_goal == null:
		push_error("No _music_recorder_goal, please assign one in the editor")
		breakpoint
		return
	if _music_recorder_player == null:
		push_error("No _music_recorder_player, please assign one in the editor")
		breakpoint
		return
	if _player_spawner == null:
		push_error("No _player_spawner, please assign one in the editor")
		breakpoint
		return
	
	if instance != null:
		push_error("Multiple game loops")
		breakpoint
		return
	instance = self
	
	# Wait for everything to be ready.
	# TODO: This should be called in _ready() of a parent node.
	await get_tree().create_timer(1.0).timeout
	new_level()


func _on_score_ui_next_level() -> void:
	difficulty += 1.0
	new_level()


func _on_score_ui_retry() -> void:
	retry_level()


func _on_score_ui_relisten() -> void:
	retry_level_with_relisten()
