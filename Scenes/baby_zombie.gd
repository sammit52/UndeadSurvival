extends Zombie

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		queue_free()