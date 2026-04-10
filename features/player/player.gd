extends CharacterBody2D
class_name Player

@export var starting_tile := Vector2(5, 1)

@onready var sprite = $Visuals/AnimatedSprite2D

const STEP_LENGTH_IN_PIXELS = 16
const SPEED := 100
const STEP_DURATION_IN_SECONDS := 0.75

var delta_time := 0.0
var target_position := Vector2.ZERO:
	set(value):
		if value[0] < Grid.GRID_X_MIN:
			value[0] = Grid.GRID_X_MIN
		if value[0] > Grid.GRID_X_MAX:
			value[0] = Grid.GRID_X_MAX
		if value[1] < Grid.GRID_Y_MIN:
			value[1] = Grid.GRID_Y_MIN
		if value[1] > Grid.GRID_Y_MAX:
			value[1] = Grid.GRID_Y_MAX
		target_position = value


func _ready():
	global_position = Helper.get_position_from_tile(starting_tile)
	target_position = global_position

func _physics_process(delta):
	if global_position != target_position:
		move_player(delta)
	else:
		handle_direction_input()
		handle_action_input()

func move_player(delta: float):
	sprite.play("walk") 
	delta_time += delta
	var weight = delta_time / STEP_DURATION_IN_SECONDS
	global_position = global_position.lerp(target_position, weight)
	if global_position.distance_to(target_position) <= 2:
		global_position = target_position
		sprite.play("idle")
		delta_time = 0.0
		SignalBus.stepped.emit(global_position)

func handle_direction_input():
	if Input.is_action_pressed("move_up"):
		## TODO: check if tile is free (var col = Helper.check_for_collider_on_position(global_position, get_world_2d()))
		target_position = global_position + Vector2(0, -1*STEP_LENGTH_IN_PIXELS)
	if Input.is_action_pressed("move_down"):
		## TODO: check if tile is free
		target_position = global_position + Vector2(0, 1*STEP_LENGTH_IN_PIXELS)
	if Input.is_action_pressed("move_left"):
		## TODO: check if tile is free
		target_position = global_position + Vector2(-1*STEP_LENGTH_IN_PIXELS, 0)
		sprite.flip_h = true  
	if Input.is_action_pressed("move_right"):
		## TODO: check if tile is free
		target_position = global_position + Vector2(1*STEP_LENGTH_IN_PIXELS, 0)
		sprite.flip_h = false

func handle_action_input():
	if Input.is_action_just_pressed("action_plant"):
		if check_can_plant_on_current_tile():
			print("planted seed")
			SignalBus.seed_planted.emit(global_position, "Daisy") ## TODO: "Daisy" später zu enum oder ressource-type ändern
			print("Planting Seed: Success!")
		else:
			print("Planting Seed: Failed!")
	
	if Input.is_action_just_pressed("action_collect"):
		var plant_on_tile : Plant = Helper.check_for_collider_on_position(global_position, (1 << Helper.LAYER_BIT_PLANT), get_world_2d())
		#print("--- ", plant_on_tile.current_phase)
		if plant_on_tile != null:# and plant_on_tile.current_phase == Enums.plantStates.FULLY_GROWN:
			SignalBus.flower_collected.emit(plant_on_tile)
			print("Collecting Flower: Success!")
		else:
			print("Collecting Flower: Failed!")
	
func check_can_plant_on_current_tile():
	var tile_has_plant = Helper.check_for_collider_on_position(global_position, (1 << Helper.LAYER_BIT_PLANT), get_world_2d()) != null
	return not tile_has_plant
