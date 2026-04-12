extends ColorRect
class_name NextSeedWindow

@onready var texture_rect: TextureRect = $Control/TextureRect

const ICON_DAISY = preload("uid://w1lcgvwkh0v5")
const ICON_SUNFLOWER = preload("uid://c4pxm8nxum78x")
const ICON_TULIP = preload("uid://b4ot1r803lemu")

func _ready() -> void:
	SignalBus.new_seed.connect(set_new_seed_icon)

func set_new_seed_icon(plant_type: Plant.PLANT_TYPE):
	match plant_type:
		Plant.PLANT_TYPE.Daisy:
			texture_rect.texture = ICON_DAISY
		Plant.PLANT_TYPE.Tulip:
			texture_rect.texture = ICON_TULIP
		Plant.PLANT_TYPE.Sunflower:
			texture_rect.texture = ICON_SUNFLOWER
	
