extends Node

const LAYER_BIT_PLAYER := 0
const LAYER_BIT_TILE := 1
const LAYER_BIT_PLANT := 2
const LAYER_BIT_POLLEN := 3

var layer_mask := (1 << LAYER_BIT_PLAYER) | (1 << LAYER_BIT_TILE) | (1 << LAYER_BIT_PLANT) | (1 << LAYER_BIT_POLLEN)

func get_position_from_tile(tile: Vector2) -> Vector2:
	return Vector2(96-16, 24-16) + tile*16

func get_tile_from_position(position: Vector2) -> Vector2:
	return (position - Vector2(96-16, 24-16)) / 16

func get_collision_on_area(_position: Vector2, _layer_mask, world : World2D) -> Array[Dictionary]:
	var space = world.direct_space_state
	var query = PhysicsPointQueryParameters2D.new()
	query.position = _position
	query.collision_mask = _layer_mask
	query.collide_with_areas = true
	return space.intersect_point(query, 5)

#func get_collisions_on_tile()
