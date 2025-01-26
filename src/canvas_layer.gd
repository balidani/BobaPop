class_name shader_canvas
extends CanvasLayer
@export var _gray_vignette: gray_vignette
@export var _saturated_rainbow: saturated_rainbow
static var inst : shader_canvas
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
		inst = self
		#var instance = self
		pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
		pass
