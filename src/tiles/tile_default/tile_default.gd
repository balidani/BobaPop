extends StaticBody3D
class_name TileDefault


func _on_area_3d_area_entered(_area: Area3D) -> void:
	queue_free()
