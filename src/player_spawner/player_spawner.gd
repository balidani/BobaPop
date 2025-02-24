extends Node3D
class_name PlayerSpawner


@export var _level_camera : LevelCamera
@onready var _container : Node3D = $PlayerSpot


var rng = RandomNumberGenerator.new()


var computer_player : Player
var real_player


func spawn_computer_player():
	computer_player = PLAYER.instantiate()
	computer_player.rng.seed = rng.seed
	computer_player.view = _level_camera
	_container.add_child(computer_player)
	computer_player.is_ai = true


func remove_computer_player():
	if is_instance_valid(computer_player):
		computer_player.queue_free()


func remove_real_player():
	if is_instance_valid(real_player):
		real_player.queue_free()


func spawn_real_player():
	# Remove previous player.
	if real_player:
		remove_real_player()
	real_player = PLAYER.instantiate()
	real_player.view = _level_camera
	_container.add_child(real_player)


const PLAYER = preload("res://objects/player.tscn")
