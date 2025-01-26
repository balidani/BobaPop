extends StaticBody3D
class_name BlackHole



func bounce(_bubble : BouncyBubble, _last_velocity):
	_bubble.immune = false
	_bubble.queue_free()
