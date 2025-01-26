extends HBoxContainer


@onready var _label : Label = $Value


signal time_changed(value)


func _on_h_slider_value_changed(value: float) -> void:
	time_changed.emit(value)
	_label.text = "%0.1fs" % value
