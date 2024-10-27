extends Node

@onready var full_screen = true
@onready var player = $Player
@onready var money_label = $UILayer/Money/Label

func _ready():
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	$UILayer/PauseMenu.hide()  # Hide the pause overlay initially



func _input(event: InputEvent) -> void:
	  
	if event.is_action_pressed("Toggle Fullscreen"):
		if full_screen:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			full_screen = false
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			full_screen = true
		

var is_paused: bool = false  # Track whether the game is paused

func _process(delta: float) -> void:
	# Check for Escape key press to toggle pause state
	money_label.text = "Money: " + str(player.money)
	if Input.is_action_just_pressed("ui_cancel"):
		toggle_pause()
	
	$UILayer/Shop/HealthUpgrade.text = "$" + str(health_upgrade_cost)
	$UILayer/Shop/MovementSpeedUpgrade.text = "$" + str(movement_speed_upgrade_cost)
	$UILayer/Shop/BulletSpeedUpgrade.text = "$" + str(bullet_speed_upgrade_cost)
	$UILayer/Shop/BulletAccuracyUpgrade.text = "$" + str(bullet_accuracy_upgrade_cost)
	$UILayer/Shop/BulletDamageUpgrade.text = "$" + str(bullet_damage_upgrade_cost)
	$UILayer/Shop/NewGunUpgrade.text = "$" + str(new_gun_cost)

func toggle_pause() -> void:
	is_paused = !is_paused  # Toggle the pause state

	if is_paused:
		pause_game()  # Call function to pause specific nodes
		show_pause_overlay()  # Show the pause overlay
	else:
		resume_game()  # Call function to resume specific nodes
		hide_pause_overlay()  # Hide the pause overlay

func pause_game() -> void:
	# Pause player
	var player = get_node("Player")
	player.set_process(false)  # Stop processing for the player
	player.set_physics_process(false)  # Stop physics processing for the player
	for bullet in get_tree().get_nodes_in_group("bullet"):
		bullet.set_physics_process(false)  # Stop processing for each bullet
		bullet.set_process(false)

	# Pause the zombie spawner
	var spawner = get_node("Zombie Spawner")
	spawner.set_process(false)  # Stop processing for the spawner
	for zombie in spawner.get_children():  # Loop through all children of the Zombies node
		zombie.set_process(false)  # Stop processing for each zombie

func resume_game() -> void:
	# Resume player
	var player = get_node("Player")
	player.set_process(true)  # Resume processing for the player
	player.set_physics_process(true)  # Resume physics processing for the player
	for bullet in get_tree().get_nodes_in_group("bullet"):
		bullet.set_physics_process(true)  # Stop processing for each bullet
		bullet.set_process(true)

	# Resume the zombie spawner
	var spawner = get_node("Zombie Spawner")
	spawner.set_process(true)  # Resume processing for the spawner
	for zombie in spawner.get_children():  # Loop through all children of the Zombies node
		zombie.set_process(true)  # Stop processing for each zombie
		


func show_pause_overlay() -> void:
	$UILayer/PauseMenu.show()
	print("Game Paused")  # Debug message

func hide_pause_overlay() -> void:
	$UILayer/PauseMenu.hide()
	$UILayer/Shop.hide()
	
	print("Game Resumed")  # Debug message
		



func _on_exit_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main.tscn")


func _on_shop_pressed() -> void:
	$UILayer/PauseMenu.hide()
	$UILayer/Shop.show()
	
# SHOP STUFF
@onready var movement_speed_upgrade_cost = 10
@onready var bullet_speed_upgrade_cost = 10
@onready var bullet_accuracy_upgrade_cost = 10
@onready var bullet_damage_upgrade_cost = 10
@onready var health_upgrade_cost = 10
@onready var new_gun_cost = 25
@onready var gun = 0

func _on_health_upgrade_pressed() -> void:
	if player.money >= health_upgrade_cost:
		player.money-= health_upgrade_cost
		health_upgrade_cost+=5
		player.health += 10

func _on_movement_speed_upgrade_pressed() -> void:
	if player.money >= movement_speed_upgrade_cost:
		player.money-= movement_speed_upgrade_cost
		movement_speed_upgrade_cost+=5
		player.speed += 10

func _on_bullet_speed_upgrade_pressed() -> void:
	if player.money >= bullet_speed_upgrade_cost:
		player.money-= bullet_speed_upgrade_cost
		bullet_speed_upgrade_cost+=10
		player.bullet_speed_upgrade += 0.1


func _on_bullet_accuracy_upgrade_pressed() -> void:
	if player.money >= bullet_accuracy_upgrade_cost:
		player.money-= bullet_accuracy_upgrade_cost
		bullet_accuracy_upgrade_cost+=10
		player.bullet_accuracy_upgrade -= 0.1

func _on_bullet_damage_upgrade_pressed() -> void:
	if player.money >= bullet_damage_upgrade_cost:
		player.money-= bullet_damage_upgrade_cost
		bullet_damage_upgrade_cost+=10
		player.bullet_damage_upgrade += 0.1


func _on_new_gun_upgrade_pressed() -> void:
	if player.money >= new_gun_cost:
		if gun < 10:
			player.money-= new_gun_cost
			gun += 1
			new_gun_cost+=50
			player.unlocked_guns.append(gun)
