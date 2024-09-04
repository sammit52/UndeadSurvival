extends Area2D
var variance : float
var speed : float 
@export var direction : Vector2 = Vector2.ZERO
var bullet_damage : float
func _ready():
	rotation_degrees+=randf_range(-variance,variance)
	
func _process(delta):
	translate(transform.x * speed * delta)
	#position += direction * speed * delta
	if position.x < 0 or position.x > get_viewport().size.x or position.y < 0 or position.y > get_viewport().size.y:
		queue_free()


func _on_area_entered(area: Area2D) -> void:
	if area.has_method("take_damage"):
		area.take_damage(bullet_damage)# Handle collision with enemies or walls
		queue_free()
	
