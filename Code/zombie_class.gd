extends Area2D

class_name Zombie
@export var health : float 
@export var speed : float
@export var separation_distance : float
var player : Node2D = null
var velocity : Vector2 = Vector2.ZERO 
# The current direction and speed, with smoothing
var current_velocity : Vector2 = Vector2.ZERO
@export var direction_smoothing : float = 0.1 # Smoothing factor (0 = no smoothing, 1 = instant)

var target_offset : Vector2 = Vector2.ZERO
var sprite = null
var timer = null

func _ready() -> void:
	var players = get_tree().get_nodes_in_group("player")
	sprite = $Sprite2D
	timer = $Timer
	if players.size() > 0:
		player = players[0]  # Assuming there's only one player in the group
	# slightly randomising each zombie
	target_offset = Vector2(randf_range(-10, 10), randf_range(-10, 10))
	health += randf_range(-health/10,health/10)
	speed += randf_range(-speed/10,speed/10)
	direction_smoothing += randf_range(-direction_smoothing/10,direction_smoothing/10)

	
func apply_separation(zombies):
	var separation_force = Vector2.ZERO
	for other_zombie in zombies:
		if other_zombie != self:
			var distance = global_position.distance_to(other_zombie.global_position)
			if distance < separation_distance:  # Separation threshold
				separation_force += (global_position - other_zombie.global_position).normalized() / distance
	return separation_force * 30.0  # Separation strength

func _process(delta: float) -> void:
	if player:
		var target_direction = (player.global_position + target_offset - global_position).normalized()
		current_velocity = current_velocity.lerp(target_direction * speed, direction_smoothing)
		
		# Apply separation force
		var separation = apply_separation(get_tree().get_nodes_in_group("zombie"))
		current_velocity += separation
		
		velocity = current_velocity
		
		position += velocity * delta
		
		if current_velocity.length() > 0:
			rotation = current_velocity.angle()
	
func take_damage(damage):
	
	reduce_opacity()
	health-= damage
	if health <= 0:
		queue_free()

func reduce_opacity() -> void:
	if sprite:
		sprite.modulate.a = 0.8  # Set opacity to 50%
		
		$Timer.start(0.05) 
		
		await $Timer.timeout
		
		sprite.modulate.a = 1.0  # Restore full opacity
