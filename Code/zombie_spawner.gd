extends Node2D

@export var normal_zombie : PackedScene
@export var fast_zombie : PackedScene
@export var big_zombie : PackedScene
@export var boss_zombie : PackedScene
var can_spawn_zombie = true
var can_spawn_boss_zombie = false
@onready var zombie_timer = $Zombie_Timer
@onready var boss_zombie_timer = $Boss_Zombie_Timer
var zombie_spawn_time = 5
# Called every frame. 'delta' is the elapsed time since the previous frame.

func _ready():
	boss_zombie_timer.wait_time = 60
	boss_zombie_timer.start()
		
func _process(delta: float) -> void:
	if can_spawn_zombie:
		can_spawn_zombie = false
		zombie_timer.wait_time = zombie_spawn_time
		zombie_timer.start()
		spawn_zombie()
	
	if can_spawn_boss_zombie:
		can_spawn_boss_zombie = false
		boss_zombie_timer.wait_time = 60
		boss_zombie_timer.start()
		spawn_boss_zombie()
	
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
	
func spawn_boss_zombie():
	var zombie 
	zombie = boss_zombie.instantiate()
	zombie.position = Vector2(1950, randf_range(0,1090))
	add_child(zombie)
	
func _on_zombie_timer_timeout() -> void:
	can_spawn_zombie = true

func _on_boss_zombie_timer_timeout() -> void:
	can_spawn_boss_zombie = true
