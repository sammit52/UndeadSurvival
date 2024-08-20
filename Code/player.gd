extends CharacterBody2D

@export var speed: float = 200.0  # Movement speed in pixels per second
@export var bullet_scene : PackedScene
@onready var marker_2d: Marker2D = $Marker2D

var gun_names = ["Pistol", "Gun1", "Gun2", "Gun3", "Gun4", "Gun5", "Gun6", "Gun7", "Gun8", "Gun9"] # List of gun animation names
var current_gun_index = 0

# Reference to the AnimatedSprite2D node
@onready var gun_sprite = $Guns
# Called when the node enters the scene tree for the first time
func _ready():
	# Set the initial gun animation
	equip_gun(current_gun_index)
	
func equip_gun(index: int):
	if index >= 0 and index < gun_names.size():
		gun_sprite.animation = gun_names[index]

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
	
	
	
	# Need to make it so some gun indexes are skipped when they're not unlocked, 
		# Number keys to switch guns
	for i in range(1, gun_names.size() + 1):
		if Input.is_action_just_pressed("ui_select_weapon_" + str(i)):
			current_gun_index = i - 1
			equip_gun(current_gun_index)
			# Code to move where the bullet shoots out of based on barrel size
			if i > 2:
				# marker_2d. need to add code that moves the marker 2d across a few pizels closer to the barrel of the gun
				pass
			elif i <= 2:
				# marker 2d back to position.
				pass

	# Scroll wheel to switch guns
	if Input.is_action_just_pressed("ui_scroll_up"):
		current_gun_index -= 1
		if current_gun_index < 0:
			current_gun_index = gun_names.size() - 1
		equip_gun(current_gun_index)
	
	if Input.is_action_just_pressed("ui_scroll_down"):
		current_gun_index += 1
		if current_gun_index >= gun_names.size():
			current_gun_index = 0
		equip_gun(current_gun_index)

	
	if Input.is_action_just_pressed("shoot"):
		var bullet = bullet_scene.instantiate()
		bullet.global_position = marker_2d.global_position
		bullet.direction = (get_global_mouse_position() - position).normalized()
		bullet.look_at(get_global_mouse_position())
		add_sibling(bullet)		
	
