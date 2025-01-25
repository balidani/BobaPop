extends Node

var player: MusicPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:

	player = MusicPlayer.new(self)
	player.initialize()
	player.start_streaming()
	player.change_filter(2)
	player.change_filter_power(20)
	
	player.change_instrument(9)
