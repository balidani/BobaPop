extends StaticBody3D
class_name TileDefault


func _on_area_3d_area_entered(area: Area3D) -> void:
	print(area)
	queue_free()
