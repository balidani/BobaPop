extends Node3D
class_name TileGift


@onready var _bubble_spawn : BubbleSpawn = $BubbleSpawn
@onready var _bubble_spawn2 : BubbleSpawn = $BubbleSpawn2
@onready var _bubble_spawn3 : BubbleSpawn = $BubbleSpawn3
@onready var _bubble_spawn4 : BubbleSpawn = $BubbleSpawn4


func _on_tile_with_sound_bounced(bubble: BouncyBubble, last_velocity: Variant) -> void:
	_bubble_spawn.spawn()
	_bubble_spawn2.spawn()
	_bubble_spawn3.spawn()
	_bubble_spawn4.spawn()
