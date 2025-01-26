extends Node3D


signal ai_try_shoot


@onready var _rc : RayCast3D = $RayCast3D


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not _rc.is_colliding(): return
	var coll = _rc.get_collider()
	if coll is not TileWithSound: return
	if not coll.interesting_for_ai: return
	ai_try_shoot.emit()
