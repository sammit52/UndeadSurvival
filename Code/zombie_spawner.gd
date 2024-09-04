extends Node2D

@export var normal_zombie : PackedScene
@export var fast_zombie : PackedScene
@export var big_zombie : PackedScene
var can_spawn_zombie = true

@onready var zombie_timer = $Timer

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if can_spawn_zombie:
		can_spawn_zombie = false
		zombie_timer.wait_time = 5
		zombie_timer.start()
		spawn_zombie()

func spawn_zombie():
	var i = randi_range(1,10)
	var zombie = null
	if 1 <= i and i <= 5:
		zombie = normal_zombie.instantiate()
	elif 6 <= i and i <= 9:
		zombie = fast_zombie.instantiate()
	elif i == 10:
		zombie = big_zombie.instantiate()
	zombie.position = Vector2(1950, randf_range(0,1090))
	add_child(zombie)

func _on_timer_timeout() -> void:
	can_spawn_zombie = true
