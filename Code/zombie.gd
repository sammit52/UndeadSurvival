extends CharacterBody2D

@export var speed : float = 150.0
var player : Node2D = null

# The current direction and speed, with smoothing
var current_velocity : Vector2 = Vector2.ZERO
@export var direction_smoothing : float = 0.05  # Smoothing factor (0 = no smoothing, 1 = instant)

func _ready() -> void:
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		player = players[0]  # Assuming there's only one player in the group

func _process(delta: float) -> void:
	if player:
		# Get the direction to the player
		var target_direction = (player.global_position - global_position).normalized()
		
		# Smoothly interpolate the velocity towards the target direction
		current_velocity = current_velocity.lerp(target_direction * speed, direction_smoothing)
		
		# Set the velocity property before moving
		velocity = current_velocity
		
		# Move the enemy
		move_and_slide()
		
		# Rotate the enemy to face the direction of movement
		if current_velocity.length() > 0:
			rotation = current_velocity.angle()



