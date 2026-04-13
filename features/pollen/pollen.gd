extends StaticBody2D

const tile:float = 16
const pollen = preload("uid://c6oott1jjxued")
var directions = [Vector2(0,-1) , Vector2(0,1) , Vector2(1,0) , Vector2(-1,0)]



var counter:int = 0
var spread_time:int = 8

func _ready() -> void:
	#SignalBus.stepped.connect(on_stepped)
	modulate = Color(1.0, 1.0, 1.0, 0.75)
	#spread_pollen()

#func on_stepped(position:Vector2):
	#counter += 1
	#if counter >= spread_time:
		#spread_pollen()
		#counter = 0

func spread_pollen():
	for i in directions:
		var pos = global_position + i * tile
		if check_if_field_is_on_grid(pos) and not check_if_field_has_pollen(pos):
			var new_pollen = pollen.instantiate()
			add_child(new_pollen)
			new_pollen.global_position = global_position + i * tile

func check_if_field_is_on_grid(pos: Vector2) -> bool:
	return pos[0] >= Grid.GRID_X_MIN and pos[0] <= Grid.GRID_X_MAX and pos[1] >= Grid.GRID_Y_MIN and pos[1] <= Grid.GRID_Y_MAX

func check_if_field_has_pollen(pos: Vector2) -> bool:
	var result = Helper.check_for_collider_on_position(pos, (1 << Helper.LAYER_BIT_POLLEN), get_world_2d()) != null
	return result
