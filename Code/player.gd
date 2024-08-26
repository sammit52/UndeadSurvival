extends CharacterBody2D

@export var speed: float = 200.0  # Movement speed in pixels per second
@export var bullet_scene : PackedScene
@onready var marker_2d: Marker2D = $Marker2D
var guns = {0:["Pistol",5,99],1:["Gun1",2,50],2:["Gun2",2,50],3:["Gun3",2,50],4:["Gun4",2,50],5:["Gun5",2,50],6:["Gun6",2,50],7:["Gun7",2,50],8:["Gun8",2,50],9:["Gun9",2,50]}
#name, damage, max ammo (potentially add owned? true or false value)
#var gun_names = ["Pistol", "Gun1", "Gun2", "Gun3", "Gun4", "Gun5", "Gun6", "Gun7", "Gun8", "Gun9"] # List of gun animation names

var unlocked_guns = [0,1,2,3]

var current_gun_index = 0

# Reference to the AnimatedSprite2D node
@onready var gun_sprite = $Guns
# Called when the node enters the scene tree for the first time
func _ready():
	# Set the initial gun animation
	equip_gun(current_gun_index)
	
func equip_gun(index: int):
	
	#if index >= 0 and index <= unlocked_guns.size():
	gun_sprite.animation = guns[index][0]

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
	#for i in range(1, guns.size()+1):
		#if i in unlocked_guns:
			#if Input.is_action_just_pressed("ui_select_weapon_" + str(i)):
				#current_gun_index = i-1
				#equip_gun(current_gun_index)
				## Code to move where the bullet shoots out of based on barrel size
				#if i > 2:
					## marker_2d. need to add code that moves the marker 2d across a few pizels closer to the barrel of the gun
					#pass
				#elif i <= 2:
					## marker 2d back to position.
					#pass

	# Scroll wheel to switch guns
	if Input.is_action_just_pressed("ui_scroll_up"):
		current_gun_index += 1
		if current_gun_index >= unlocked_guns.size():
			current_gun_index = 0
		
		equip_gun(unlocked_guns[current_gun_index])
	
	if Input.is_action_just_pressed("ui_scroll_down"):
		current_gun_index -= 1
		if current_gun_index < 0:
			current_gun_index = unlocked_guns.size() - 1
		equip_gun(unlocked_guns[current_gun_index])

	
	if Input.is_action_just_pressed("shoot"):
		var bullet = bullet_scene.instantiate()
		bullet.global_position = marker_2d.global_position
		bullet.direction = (get_global_mouse_position() - position).normalized()
		bullet.look_at(get_global_mouse_position())
		add_sibling(bullet)		
	
func _input(event):
	if event is InputEventKey and event.is_pressed():
		var gun_select = null
		match(event.keycode):
			KEY_1:
				gun_select = 0
			KEY_2:
				gun_select = 1
			KEY_3:
				gun_select = 2
			KEY_4:
				gun_select = 3
			KEY_5:
				gun_select = 4
			KEY_6:
				gun_select = 5
			KEY_7:
				gun_select = 6
			KEY_8:
				gun_select = 7
			KEY_9:
				gun_select = 8
			KEY_0:
				gun_select = 9
			_:
				pass
		if gun_select in unlocked_guns:
			equip_gun(gun_select)
