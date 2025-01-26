extends Control


signal back


func _on_back_pressed() -> void:
	back.emit()
