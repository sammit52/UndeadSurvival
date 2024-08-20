extends Area2D

@export var speed : float = 500.0
@export var direction : Vector2 = Vector2.ZERO

func _process(delta):
	position += direction * speed * delta
	if position.x < 0 or position.x > get_viewport().size.x or position.y < 0 or position.y > get_viewport().size.y:
		queue_free()

func _on_body_entered(body: Node):
	# Handle collision with enemies or walls
	queue_free()