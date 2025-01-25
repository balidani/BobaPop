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


func retry_level():
	print("Resetting the real level")
	_level_generator.reset_real_level()
	print("Spawning the real player")
	_player_spawner.spawn_real_player()
	_level_generator.start_level()
	# TODO: Do not start recording immediately, but start it on player action.
	print("Starting the player recording")
	_music_recorder_player.start(MUSIC_RECORDING_DURATION_S)


func pass_level():
	pass


func new_level():
	print("Generating a new level")
	_level_generator.generate_new_level()
	_level_lighting.new_level()
	_player_spawner.spawn_computer_player()
	print("Showing the level")
	_level_camera.target = _level_generator
	print("Starting the goal recording")
	_music_recorder_goal.start(MUSIC_RECORDING_DURATION_S)
	_level_generator.start_level()
	await _music_recorder_goal.finished
	print("Recording done")
	print("Removing computer player")
	_player_spawner.remove_computer_player()
	print("Starting player level")
	while true: # infinite retries, how fun
		retry_level()
		await _music_recorder_player.finished
		
		print("Comparing recordings")
		
		var challenge: MusicRecorder = _music_recorder_goal.instance
		var player_recording: MusicRecorder = _music_recorder_player.instance
	
		var success_percentage = challenge.compare_similarity_against(player_recording)
		
		print("Similarity", success_percentage)
		
		# TODO: Compare recordings
		print("Hardcoded, need to retry.")
		# Give a bit of time between resets
		await get_tree().create_timer(1.0).timeout
	


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
