extends Node

@onready var full_screen = true

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
	if Input.is_action_just_pressed("ui_cancel"):
		toggle_pause()

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
	print("Game Resumed")  # Debug message
		
