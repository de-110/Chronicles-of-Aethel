extends CharacterBody2D

@export var movement_speed : float = 500
var character_direction : Vector2

func _physics_process(delta):
	character_direction.x = Input.get_axis("ui_left", "ui_right")
	character_direction.y = Input.get_axis("ui_up", "ui_down")
	character_direction = character_direction.normalized()

	if character_direction:
		velocity = character_direction * movement_speed
	else:
		velocity = velocity.move_toward(Vector2.ZERO, movement_speed)
	move_and_slide()
	
	if Input.is_action_just_pressed("player_dash"):
		player_dash()

func player_dash():
	movement_speed = movement_speed * 5
	$Timer.start()


func _on_timer_timeout() -> void:
	movement_speed = 500
