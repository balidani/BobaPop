extends StaticBody3D
class_name TileObstacle

@onready var _ap : AnimationPlayer = $AnimationPlayer
@onready var _asp : AudioStreamPlayer3D = $AudioStreamPlayer3D

var a_major = [440, 554, 659]

func bounce(_bubble: BouncyBubble):
	#new_chord = []y
	#new_chord[1] = 1
	#_asp.play(0.0)
	#_ap.play("bounce")

	var p = MusicPlayer.new(self)
	# Play the compiled chord
	Synth.player.start_streaming()
	#Synth.player.play_chord(a_major, 1)
	#Synth.player.play_chord(a_major, 1)
	#Synth.player.play_note(a_major[0] * abs(_bubble.linear_velocity.x))
	#Synth.player.stop_note(440)
	#Synth.player.play_tune()

	

	#Synth.player.play_note(554w) # * abs(_bubble.linear_velocity.x)
	#Synth.player.stop_note(554)
	#Synth.player.play_note(659) #
	#Synth.player.stop_note()
