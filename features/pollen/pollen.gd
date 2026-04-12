extends StaticBody2D

const tile:float = 16
const pollen = preload("uid://c6oott1jjxued")
var directions = [Vector2(0,-1) , Vector2(0,1) , Vector2(1,0) , Vector2(-1,0)]

var counter:int = 0
var spread_time:int = 5

func _ready() -> void:
	SignalBus.stepped.connect(on_stepped)
	#spread_pollen()

func on_stepped(position:Vector2):
	counter += 1
	if counter >= spread_time:
		spread_pollen()
		counter = 0

func spread_pollen():
	for i in directions:
		print(i)
		var new_pollen = pollen.instantiate()
		add_child(new_pollen)
		new_pollen.global_position = global_position + i * tile
