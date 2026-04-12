extends Control


func _on_timer_timeout() -> void:
	# start tween to fade out ui
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate", Color(1.0, 1.0, 1.0, 0.0), 1.0)
