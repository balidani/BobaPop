extends HBoxContainer


signal chaos_changed(value)


func _on_h_slider_value_changed(value: float) -> void:
	chaos_changed.emit(value)
