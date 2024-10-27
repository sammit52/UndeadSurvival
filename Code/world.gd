extends Node

@onready var full_screen = true

func _ready():
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)

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
	if Input.is_action_just_pressed("ui_cancel"):  # This is typically mapped to the Esc key
		toggle_pause()

func toggle_pause() -> void:
	is_paused = !is_paused  # Toggle the pause state
	if is_paused:
		get_tree().paused = true  # Pause the game
		show_pause_menu()  # Call a function to show the pause menu
	else:
		get_tree().paused = false  # Unpause the game
		hide_pause_menu()  # Call a function to hide the pause menu

func show_pause_menu() -> void:
	# Here, you can show your pause menu UI
	print("Game Paused")  # Placeholder for debugging
	# Example: get_node("PauseMenu").show() if you have a pause menu node

func hide_pause_menu() -> void:
	# Here, you can hide your pause menu UI
	print("Game Resumed")  # Placeholder for debugging
	# Example: get_node("PauseMenu").hide() if you have a pause menu node
