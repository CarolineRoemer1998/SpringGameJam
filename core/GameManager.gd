# GameManager.gd
extends Node

const RESOURCE_FLOWER_DAISY = preload("uid://blak745amd86c")
#const RESOURCE_FLOWER_DAISY = 
#const RESOURCE_FLOWER_DAISY = 

var flower_resource_types : Array[PlantData]
var current_seed_type : PlantData

func _ready():
	flower_resource_types.append(RESOURCE_FLOWER_DAISY)
	set_random_seed_type()
	## TODO: Restliche Types adden

func set_random_seed_type():
	current_seed_type = flower_resource_types.pick_random()
	## TODO: Visual ändern, um player zu zeigen, welchen seed er hat

func get_and_use_current_seed() -> PlantData:
	var result = current_seed_type.duplicate(true)
	set_random_seed_type()
	return result
	
