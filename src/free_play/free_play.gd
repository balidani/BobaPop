extends Node3D
class_name FreePlay


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("escape"):
		get_tree().root.add_child(load("res://src/main_menu/main_menu.tscn").instantiate())
		queue_free()
