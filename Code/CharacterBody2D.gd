extends CharacterBody2D

@export var speed: float = 200.0  # Movement speed in pixels per second

func _process(delta: float) -> void:
	var velocity: Vector2 = Vector2.ZERO
	
	# Handle input
	if Input.is_action_pressed("right"):
		velocity.x += 1
	if Input.is_action_pressed("left"):
		velocity.x -= 1
	if Input.is_action_pressed("down"):
		velocity.y += 1
	if Input.is_action_pressed("up"):
		velocity.y -= 1

	# Normalize the velocity vector to prevent faster diagonal movement
	velocity = velocity.normalized() * speed

	# Set the velocity in CharacterBody2D
	self.velocity = velocity

	# Move the character using the built-in method
	move_and_slide()
	
	var mouse_position = get_global_mouse_position()
	var direction = (mouse_position - global_position).angle()
	rotation = direction
