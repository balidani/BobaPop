###################################################
# Part of GDSiON example project                  #
# Copyright (c) 2024 Yuri Sizov and contributors  #
# Provided under MIT                              #
###################################################

## The music player component, responsible for producing sounds using SiON and
## input data.
class_name MusicPlayer extends Object



signal instrument_changed()
signal filter_changed()

const AVAILABLE_INSTRUMENTS := [
	{ "category": "BELL", "name": "Glocken 1" }, #9
	{ "category": "MIDI", "name": "Grand Piano" }, #0
	#{ "category": "MIDI", "name": "Glockenspiel" }, #1
	{ "category": "MIDI", "name": "Xylophone" }, #2
	#{ "category": "MIDI", "name": "Rock Organ" }, #3
	#{ "category": "MIDI", "name": "Accordion" }, #4
	#{ "category": "MIDI", "name": "Nylon Guitar" }, #5
	#{ "category": "MIDI", "name": "Electric Guitar" }, #6
	#{ "category": "MIDI", "name": "Trumpet" }, #7
	#{ "category": "MIDI", "name": "Oboe" }, #8


	#{ "category": "CHIPTUNE", "name": "Square Wave" }, #10
	#{ "category": "CHIPTUNE", "name": "Dual Saw" }, #11
	#{ "category": "CHIPTUNE", "name": "Triangle LO-FI" }, #12

	#{ "category": "DRUMKIT", "name": "Simple Drumkit" }, #13
	
]

const AVAILABLE_FILTERS := [
	"DELAY", #0
	"CHORUS", #1
	"REVERB", #2
	"DISTORTION", #3
	"LOW BOOST", #4
	"COMPRESSOR", #5
	"HIGH PASS", #6
]

var _driver: SiONDriver = null
var _active_instrument: Instrument = null
var _active_instrument_index: int = 0
var _effects: Array[SiEffectBase] = []
var _active_effect: SiEffectBase = null

var _active_filter_index: int = 0
var _active_filter_power: int = 0

var _voice_manager: VoiceManager

func _init(controller: Node) -> void:
	var buffer_size = 4096
	_driver = SiONDriver.create(buffer_size)
	controller.add_child(_driver)
	_voice_manager = VoiceManager.new()
	
	# Start playing..
	#_driver.stream()
	
	
	
	print("Created synthesizer driver (v%s-%s)" % [ SiONDriver.get_version(), SiONDriver.get_version_flavor() ])


# Initialization.

func initialize() -> void:
	_driver.set_timer_interval(1)
	_driver.set_bpm(128)

	_active_instrument = Instrument.new()
	_update_instrument()
	instrument_changed.emit()

	_effects.resize(AVAILABLE_FILTERS.size())
	_effects[0] = SiEffectStereoDelay.new();
	_effects[1] = SiEffectStereoChorus.new()
	_effects[2] = SiEffectStereoReverb.new()
	_effects[3] = SiEffectDistortion.new()
	_effects[4] = SiFilterLowBoost.new()
	_effects[5] = SiEffectCompressor.new()
	_effects[6] = SiControllableFilterHighPass.new()


func _update_instrument() -> void:
	_active_instrument.clear()

	var preset: Dictionary = AVAILABLE_INSTRUMENTS[_active_instrument_index]
	print(preset)
	var voice_data := _voice_manager.get_voice_data(preset["category"], preset["name"])
	if not voice_data:
		return

	_active_instrument.type = voice_data.type
	_active_instrument.category = voice_data.category
	_active_instrument.name = voice_data.name
	_active_instrument.voice_held = voice_data.held

	if _active_instrument.type == 0: # Drumkits don't use presets.
		_active_instrument.voice = _voice_manager.get_voice_preset(voice_data.preset)
	else:
		_active_instrument.voice = null

	_active_instrument.update_filter()


func _update_filter() -> void:
	if _active_filter_power <= 5:
		_active_effect = null
		_driver.get_effector().clear_slot_effects(0)
		return

	var next_effect := _effects[_active_filter_index]
	if next_effect != _active_effect:
		_active_effect = next_effect
		_driver.get_effector().clear_slot_effects(0)
		_driver.get_effector().add_slot_effect(0, _active_effect)

	# Most of the values set here are default values for the corresponding arguments.

	if _active_effect is SiEffectStereoDelay:
		_active_effect.set_params((300.0 * _active_filter_power) / 100.0, 0.1, false)

	elif _active_effect is SiEffectStereoChorus:
		_active_effect.set_params(20, 0.2, 4, 10 + ((50.0 * _active_filter_power) / 100.0))

	elif _active_effect is SiEffectStereoReverb:
		_active_effect.set_params(0.7, 0.4 + ((0.5 * _active_filter_power) / 100.0), 0.8, 0.3)

	elif _active_effect is SiEffectDistortion:
		_active_effect.set_params(-20 - ((80.0 * _active_filter_power) / 100.0), 18, 2400, 1)

	elif _active_effect is SiFilterLowBoost:
		_active_effect.set_params(3000, 1, 4 + ((6.0 * _active_filter_power) / 100.0))

	elif _active_effect is SiEffectCompressor:
		_active_effect.set_params(0.7, 50, 20, 20, -6, 0.2 + ((0.6 * _active_filter_power) / 100.0))

	elif _active_effect is SiControllableFilterHighPass:
		_active_effect.set_params_manually(((1.0 * _active_filter_power) / 100.0), 0.9)

func reset():
	notes.clear()

# Configuration.
func get_active_instrument() -> Array:
	return [_active_instrument, _active_instrument_index]
	
func set_active_instrument(instrument: Array):
	_active_instrument = instrument[0]
	_active_instrument_index = instrument[1]
	_update_instrument()
	instrument_changed.emit()

func change_instrument(shift: int) -> void:
	for note in notes:
		stop_note(note)
	notes.clear()

	_active_instrument_index += shift
	if _active_instrument_index < 0:
		_active_instrument_index = AVAILABLE_INSTRUMENTS.size() - 1
	elif _active_instrument_index >= AVAILABLE_INSTRUMENTS.size():
		_active_instrument_index = 0

	_update_instrument()
	instrument_changed.emit()


func get_active_filter() -> int:
	return _active_filter_index

func set_active_filter(filter_id: int):
	_active_filter_index = filter_id
	_update_filter()
	filter_changed.emit()

func change_filter(shift: int) -> void:
	_active_filter_index += shift
	if _active_filter_index < 0:
		_active_filter_index = AVAILABLE_FILTERS.size() - 1
	elif _active_filter_index >= AVAILABLE_FILTERS.size():
		_active_filter_index = 0

	_update_filter()
	filter_changed.emit()


func change_filter_power(value: int) -> void:
	_active_filter_power = clampi(value, 0, 100)

	_update_filter()
	filter_changed.emit()


func change_volume(value: int) -> void:
	var volume := clampi(value, 0, 100)

	_driver.volume = (volume / 100.0)


# Output and streaming control.

func stop() -> void:
	_driver.stop()
	print("Driver stopped.")


func play_tune(mml_string: String) -> void:
	print("Driver is processing MML tune.")

	_driver.compilation_finished.connect(func(_data: SiONData) -> void:
		print("MML compiled in %d msec." % [ _driver.get_compiling_time() ])
	, CONNECT_ONE_SHOT)

	_driver.play(mml_string)


func start_streaming() -> void:
	_driver.stream(false)
	print("Driver is streaming.")

var notes: Array[int] = []

func play_note(note: int) -> void:
	notes.push_back(note)
	# All instruments, except drumkits.
	if _active_instrument.type == 0:
		_active_instrument.update_filter()
		_driver.note_on(note, _active_instrument.voice, 1000)
	# Drumkits.
	else:
		var active_drumkit := _voice_manager.get_drumkit(_active_instrument.type)
		if note >= active_drumkit.size:
			return

		active_drumkit.update_filter(_active_instrument.cutoff, _active_instrument.resonance)
		active_drumkit.update_volume(_active_instrument.volume)
		_driver.note_on(active_drumkit.voice_note[note], active_drumkit.voice_list[note])
	
	# TODO:
	# We could use an async timer here to auto-stop the note.

func play_chord(chord: Array, _time: int) -> void:
	for element in chord:
		play_note(element)


func stop_note(note: int) -> void:
	_driver.note_off(note)
