extends Control
class_name Tutorial

func _ready() -> void:
	SignalBus.stepped.connect(fade)

func _on_timer_timeout() -> void:
	# start tween to fade out ui
	#fade()
	pass

func fade(_pos=Vector2.ZERO):
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate", Color(1.0, 1.0, 1.0, 0.0), 0.25)
