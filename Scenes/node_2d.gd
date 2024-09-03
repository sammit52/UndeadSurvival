extends Node2D

@export var not_working : PackedScene
@export var zombie : PackedScene
var can_spawn_zombie = true

var zombie_timer = $Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("hello")
	if can_spawn_zombie:
		can_spawn_zombie = false
		zombie_timer.wait_time = 5
		zombie_timer.start()
		print("whatever")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func spawn_zombie():
	pass

func _on_timer_timeout() -> void:
	can_spawn_zombie = true
