extends CharacterBody2D

const SPEED = 100.0

@onready var sprite = $AnimatedSprite2D 

func _physics_process(_delta):
	var direction = Vector2.ZERO
	
	if Input.is_action_pressed("ui_right"):
		direction.x = 1
		sprite.flip_h = false
		sprite.play("walk")    
	elif Input.is_action_pressed("ui_left"):
		direction.x = -1
		sprite.flip_h = true  
		sprite.play("walk")
	elif Input.is_action_pressed("ui_down"):
		direction.y = 1
		sprite.play("walk")
	elif Input.is_action_pressed("ui_up"):
		direction.y = -1
		sprite.play("walk")
	else:
		sprite.play("idle")  
		
	velocity = direction * SPEED
	move_and_slide()
