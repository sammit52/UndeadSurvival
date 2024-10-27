extends Area2D

@export var health : float 
@export var speed : float
@export var separation_distance : float
var player : Node2D = null
var velocity : Vector2 = Vector2.ZERO 
var current_velocity : Vector2 = Vector2.ZERO
@export var direction_smoothing : float = 0.1 # Smoothing factor (0 = no smoothing, 1 = instant)
@export var death_money = 100

var target_offset : Vector2 = Vector2.ZERO
var sprite = null
var timer = null
var death_money_paid = false

var can_spawn_baby_zombie = true

@export var baby_zombie : PackedScene

@onready var baby_zombie_timer = $Baby_Zombie_Timer

func _ready() -> void:
	var players = get_tree().get_nodes_in_group("player")
	sprite = $Sprite2D
	timer = $Damage_Timer
	if players.size() > 0:
		player = players[0]  # Assuming there's only one player in the group
	# Slightly randomizing each zombie
	target_offset = Vector2(randf_range(-10, 10), randf_range(-10, 10))
	health += randf_range(-health/10, health/10)
	speed += randf_range(-speed/10, speed/10)
	direction_smoothing += randf_range(-direction_smoothing/10, direction_smoothing/10)

func _process(delta: float) -> void:
	if can_spawn_baby_zombie:
		can_spawn_baby_zombie = false
		baby_zombie_timer.wait_time = 2.5
		baby_zombie_timer.start()
		spawn_baby_zombie()
	
	if player:
		var target_direction = (player.global_position + target_offset - global_position).normalized()
		current_velocity = current_velocity.lerp(target_direction * speed, direction_smoothing)
		
		# Apply separation force
		var separation = apply_separation(get_tree().get_nodes_in_group("zombie"))
		current_velocity += separation
		
		velocity = current_velocity
		
		global_position += velocity * delta
		#ALERT Changed this from position to global_position
		
		# Update rotation only if there is movement
		if velocity.length() > 0:
			rotation = velocity.angle()

func apply_separation(zombies):
	var separation_force = Vector2.ZERO
	for other_zombie in zombies:
		if other_zombie != self and not other_zombie.is_in_group("baby_zombie"):
			var distance = global_position.distance_to(other_zombie.global_position)
			if distance < separation_distance:  # Separation threshold
				separation_force += (global_position - other_zombie.global_position).normalized() / distance
	return separation_force * 30.0  # Separation strength

func take_damage(damage):
	if death_money_paid:
		return
	reduce_opacity()
	health-= damage
	if health <= 0 and not death_money_paid:
		death_money_paid = true
		player.money += death_money
		queue_free()


func reduce_opacity() -> void:
	if sprite:
		sprite.modulate.a = 0.8  # Set opacity to 80%
		
		$Damage_Timer.start(0.05)
		
		await $Damage_Timer.timeout
		
		sprite.modulate.a = 1.0  # Restore full opacity

func spawn_baby_zombie():
	var zombie = baby_zombie.instantiate()
	print(position)
	add_sibling(zombie)
	zombie.global_position = global_position
	print("Baby zombie spawned")

func _on_baby_zombie_timer_timeout() -> void:
	can_spawn_baby_zombie = true
