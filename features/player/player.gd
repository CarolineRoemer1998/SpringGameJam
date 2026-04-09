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


func move_player(delta: float):
	sprite.play("walk") 
	delta_time += delta
	var weight = delta_time / STEP_DURATION_IN_SECONDS
	global_position = global_position.lerp(target_position, weight)
	if global_position.distance_to(target_position) <= 2:
		global_position = target_position
		sprite.play("idle")
		delta_time = 0.0

func handle_direction_input():
	if Input.is_action_pressed("move_up"):
		## TODO: check if tile is free (var col = Helper.get_collision_on_area(global_position, get_world_2d()))
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
