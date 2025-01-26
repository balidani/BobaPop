extends Node3D


@onready var _rotate : Node3D = $Anim/Rotate


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_rotate.basis = _rotate.basis.rotated(transform.basis.y, delta * 3.0)
