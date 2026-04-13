extends CharacterBody2D
class_name Player

@export var starting_tile := Vector2(5, 1)

@onready var sprite = $Visuals/AnimatedSprite2D
@onready var audio_player_plant: AudioStreamPlayer2D = $AudioPlayerPlant
@onready var audio_player_harvest: AudioStreamPlayer2D = $AudioPlayerHarvest
@onready var audio_player_step: AudioStreamPlayer2D = $AudioPlayerStep
@onready var audio_player_sneeze: AudioStreamPlayer2D = $AudioPlayerSneeze

const STEP_LENGTH_IN_PIXELS = 16
const SPEED := 100
const STEP_DURATION_IN_SECONDS := 0.75

var delta_time := 0.0
var current_dir := "down"
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
	var anim_name = "walk_" + current_dir
	if sprite.animation != anim_name:
		sprite.play(anim_name)

	delta_time += delta
	var weight = delta_time / STEP_DURATION_IN_SECONDS
	global_position = global_position.lerp(target_position, weight)

	if global_position.distance_to(target_position) <= 0.5:
		global_position = target_position
		delta_time = 0.0
		SignalBus.stepped.emit(global_position)
		#for looks: check if player is still pressing the movement key, signal aber vroher abfeuern
		var is_any_key_pressed = Input.is_action_pressed("move_up") or \
								Input.is_action_pressed("move_down") or \
								Input.is_action_pressed("move_left") or \
								Input.is_action_pressed("move_right")
		if not is_any_key_pressed:
			sprite.play("idle")
		else:
			handle_direction_input()

func handle_direction_input():
	if Input.is_action_pressed("move_up"):
		if check_field_has_pollen(Vector2(0, -1*STEP_LENGTH_IN_PIXELS)):
			sneeze()
		else:
			## TODO: check if tile is free (var col = Helper.check_for_collider_on_position(global_position, get_world_2d()))
			target_position = global_position + Vector2(0, -1*STEP_LENGTH_IN_PIXELS)
			current_dir = "up"
	if Input.is_action_pressed("move_down"):
		if check_field_has_pollen(Vector2(0, 1*STEP_LENGTH_IN_PIXELS)):
			sneeze()
		else:
			## TODO: check if tile is free
			target_position = global_position + Vector2(0, 1*STEP_LENGTH_IN_PIXELS)
			current_dir = "down"
	if Input.is_action_pressed("move_left"):
		if check_field_has_pollen(Vector2(-1*STEP_LENGTH_IN_PIXELS, 0)):
			sneeze()
		else:
			## TODO: check if tile is free
			target_position = global_position + Vector2(-1*STEP_LENGTH_IN_PIXELS, 0)
			current_dir = "left"
	if Input.is_action_pressed("move_right"):
		if check_field_has_pollen(Vector2(1*STEP_LENGTH_IN_PIXELS, 0)):
			sneeze()
		else:
			## TODO: check if tile is free
			target_position = global_position + Vector2(1*STEP_LENGTH_IN_PIXELS, 0)
			current_dir = "right"
	if target_position != global_position:
		audio_player_step.pitch_scale = [1.0, 1.1, 1.2, 1.3, 1.4, 1.5, 1.6, 1.7, 1.8, 1.9, 2.0].pick_random()
		audio_player_step.play()

func check_field_has_pollen(dir: Vector2):
		var new_pos = global_position + dir
		var has_pollen = Helper.check_for_collider_on_position(new_pos, (1 << Helper.LAYER_BIT_POLLEN), get_world_2d()) != null
		return has_pollen

func handle_action_input():
	if Input.is_action_just_pressed("action_plant"):
		plant_seed()
	if Input.is_action_just_pressed("action_collect"):
		pick_flower()

func plant_seed():
	if check_can_plant_on_current_tile():
		SignalBus.seed_planted.emit(global_position, "Daisy") ## TODO: "Daisy" später zu enum oder ressource-type ändern
		audio_player_plant.pitch_scale = [1.2, 1.4, 1.6, 1.8, 2.0, 2.2].pick_random()
		audio_player_plant.play()
		print("Planting Seed: Success!")
	else:
		print("Planting Seed: Failed!")

func pick_flower():
	var flower_on_tile : Plant = Helper.check_for_collider_on_position(global_position, (1 << Helper.LAYER_BIT_PLANT), get_world_2d())
	if flower_on_tile != null and flower_on_tile.plantState == Enums.plantStates.FULLY_GROWN:
		audio_player_harvest.play()
		SignalBus.flower_collected.emit(flower_on_tile)
		print("Collecting Flower: Success!")
	else:
		print("Collecting Flower: Failed!")

func check_can_plant_on_current_tile():
	var tile_has_plant = Helper.check_for_collider_on_position(global_position, (1 << Helper.LAYER_BIT_PLANT), get_world_2d()) != null
	return not tile_has_plant

func sneeze():
	sprite.play("sneeze")
	SignalBus.sneezed.emit()
	if not audio_player_sneeze.playing:
		audio_player_sneeze.pitch_scale = [0.9, 0.95, 1.0, 1.05, 1.1].pick_random()
		audio_player_sneeze.play()
