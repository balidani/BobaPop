extends Label


@onready var _ap : AnimationPlayer = $AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_ap.play("loop")
