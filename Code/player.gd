extends CharacterBody2D

@export var speed: float = 200.0  # Movement speed in pixels per second
@export var assault_bullet_scene : PackedScene
@export var shotgun_bullet_scene : PackedScene
@onready var marker_2d: Marker2D = $Marker2D
var guns = {0:["Pistol",50,99,false,0.0,0,400],1:["Gun1",2,50,true,0.075,7.5,225],2:["Gun2",2,50,true,0.2,1.5,400],3:["Gun3",2,50,true,0.2,2,400],4:["Gun4",2,50,true,1,15,250],5:["Gun5",2,50,true,0.2,1,400],6:["Gun6",2,50,true,0.2,1,400],7:["Gun7",2,50,true,0.2,1,400],8:["Gun8",2,50,true,0.2,1,400],9:["Gun9",2,50,true,0.2,1,400]}
#name, damage, max ammo, automatic?, time, variance, speed
#var gun_names = ["Pistol", "Gun1", "Gun2", "Gun3", "Gun4", "Gun5", "Gun6", "Gun7", "Gun8", "Gun9"] # List of gun animation names
var unlocked_gun_index = 0
var unlocked_guns = [0,1,2,3,4]
var can_shoot = true
var current_gun_index = 0


# Reference to the AnimatedSprite2D node
@onready var gun_sprite = $Guns
# Called when the node enters the scene tree for the first time
func _ready():
	# Set the initial gun animation
	equip_gun(current_gun_index)
	
func equip_gun(index: int):
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
	
	# Old code for changing guns compare to new code
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
		unlocked_gun_index += 1
		if unlocked_gun_index >= unlocked_guns.size():
			unlocked_gun_index = 0
		current_gun_index = unlocked_guns[unlocked_gun_index]
		equip_gun(unlocked_guns[unlocked_gun_index])
	
	if Input.is_action_just_pressed("ui_scroll_down"):
		unlocked_gun_index -= 1
		if unlocked_gun_index < 0:
			unlocked_gun_index = unlocked_guns.size() - 1
		current_gun_index = unlocked_guns[unlocked_gun_index]
		equip_gun(unlocked_guns[unlocked_gun_index])
	
	# Was using current gun index for two different things, the keypad to define what gun is equipped, and with this old code to scroll through the unlocked gun index and not what gun is equipped, unlocked gun index should be the gun thats equipped.
	#if Input.is_action_just_pressed("ui_scroll_down"):
		#current_gun_index -= 1
		#if current_gun_index < 0:
			#current_gun_index = unlocked_guns.size() - 1
		#equip_gun(unlocked_guns[current_gun_index])


	
	if Input.is_action_pressed("shoot") and can_shoot:
		can_shoot = false

		#Timer for automatic guns
		if guns[current_gun_index][3]:
			$Timer.wait_time = guns[current_gun_index][4]
			$Timer.start()
		var bullet
		#checking if shotgun or not, probably a better way to do this.
		if current_gun_index not in [4 , 7]:
			bullet = assault_bullet_scene.instantiate()
			bullet.variance = guns[current_gun_index][5]
			bullet.speed = guns[current_gun_index][6]
			bullet.bullet_damage = guns[current_gun_index][1]
			bullet.global_transform = marker_2d.global_transform
			add_sibling(bullet)
		else:
			for i in range(5):
				bullet = shotgun_bullet_scene.instantiate()
				bullet.variance = guns[current_gun_index][5]
				bullet.speed = guns[current_gun_index][6]
				bullet.bullet_damage = guns[current_gun_index][1]
				bullet.global_transform = marker_2d.global_transform
				add_sibling(bullet)
		#Changed this code for the stuff above
		#bullet.direction = (get_global_mouse_position() - position).normalized()
		#bullet.look_at(get_global_mouse_position())
		
	
	if Input.is_action_just_released("shoot") and not can_shoot:
		if current_gun_index not in [4 , 7]:
			can_shoot = true
		else:
			if $Timer.is_stopped():
				$Timer.wait_time = guns[current_gun_index][4]
				$Timer.start()
			
func _input(event):
	# Changing weapons using number keys
	if event is InputEventKey and event.is_pressed():
		if event.keycode not in [KEY_0,KEY_1,KEY_2,KEY_3,KEY_4,KEY_5,KEY_6,KEY_7,KEY_8,KEY_9]:
			return
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
		current_gun_index = gun_select
		if gun_select in unlocked_guns:
			equip_gun(gun_select)

# Automatic gun stuff
func _on_timer_timeout() -> void:
	can_shoot = true
