extends Node
class_name GameLoop

# Access from random objects by Gameloop.instance.<method>
static var instance : GameLoop


# "goal" contains the simulated recording. 
# "player" contains what the player is creating.
@export var _music_recorder_goal : MusicRecorder
@export var _music_recorder_player : MusicRecorder

@export var _level_camera : LevelCamera
@export var _level_generator : LevelGenerator
@export var _level_lighting : LevelLighting
@export var _player_spawner : PlayerSpawner

const MUSIC_RECORDING_DURATION_S = 5.0



func master_popper_popped():
	print("Master popper popped")
	_music_recorder_goal.stop()
	_music_recorder_player.stop()
	_level_generator.stop_level()
	_player_spawner.remove_real_player()
	# Wait for master popper effect.
	await get_tree().create_timer(5.0).timeout
	# TODO: Swap this with comparison method once it works
	retry_level()


func player_recording_start():
	print("Starting the player recording")
	_music_recorder_player.start(MUSIC_RECORDING_DURATION_S)


func computer_recording_start():
	print("Starting the computer recording")
	_music_recorder_goal.start(MUSIC_RECORDING_DURATION_S)


func retry_level():
	print("Resetting the real level")
	for bubble in BouncyBubble.all_bubbles:
		bubble.queue_free()
	_level_generator.reset_real_level()
	print("Spawning the real player")
	_player_spawner.spawn_real_player()
	_level_generator.start_level()


func pass_level():
	pass


const SUCCESS_PERCENT_MIN = 0.8


func new_level():
	print("Generating a new level")
	_level_generator.generate_new_level()
	_level_lighting.new_level()
	_player_spawner.spawn_computer_player()
	print("Showing the level, computer mode")
	_level_camera.target = _level_generator
	_level_lighting.dark_mode = true
	_level_generator.start_level()
	await _music_recorder_goal.finished
	print("Removing computer player")
	_player_spawner.remove_computer_player()
	print("Starting player level")
	_level_lighting.dark_mode = false
	
	retry_level()
	await _music_recorder_player.finished
	
	print("Comparing recordings")
	
	var challenge: MusicRecorder = _music_recorder_goal
	var player_recording: MusicRecorder = _music_recorder_player

	var success_percentage = challenge.rate_player_recording(player_recording)
	print("Similarity: %s" % success_percentage)
	
	var passed = success_percentage > SUCCESS_PERCENT_MIN
	# TODO: Make description change based on score
	var description = "You're a Musical Maestro!"
	ScoreUI.instance.show_score(success_percentage, passed, description)


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
	
	print("Game loop initializing")
	instance = self
	
	# Wait for everything to be ready.
	# TODO: This should be called in _ready() of a parent node.
	await get_tree().create_timer(1.0).timeout
	new_level()


func _on_score_ui_next_level() -> void:
	new_level()


func _on_score_ui_retry() -> void:
	retry_level()
