extends Node2D
class_name Tile


@export var plant : PackedScene

func _ready() -> void:
	SignalBus.seed_planted.connect(set_plant)

func set_plant(pos: Vector2, name: String):
	if pos != global_position:
		return
	
	var new_plant = plant.instantiate()
	add_child(new_plant)
	new_plant.global_position = global_position
