extends CharacterBody2D

@onready var sprite = $AnimatedSprite2D

@export var movement_speed: float = 250
var character_direction: Vector2
var sprite_direction= "Down": get = get_sprite_direction

enum states {idle, walk}
var current_state: states

@export var player_damage: float = 1.0

func _physics_process(_delta: float) -> void:
	current_state = states.idle
	player_movement()
	move_and_slide()
	
	print(sprite_direction)

func player_movement():
	character_direction.x = Input.get_axis("ui_left", "ui_right")
	character_direction.y = Input.get_axis("ui_up", "ui_down")
	character_direction = character_direction.normalized()
	
	if character_direction:
		velocity = character_direction * movement_speed
		current_state = states.walk
		update_sprite_animation(current_state)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, movement_speed)
		current_state = states.idle
		update_sprite_animation(current_state)

func get_sprite_direction():
	match character_direction:
		Vector2.LEFT:
			sprite_direction = "Left"
		Vector2.RIGHT:
			sprite_direction = "Right"
		Vector2.UP:
			sprite_direction = "Up"
		Vector2.DOWN:
			sprite_direction = "Down"
	return sprite_direction

func update_sprite_animation(state):
	if current_state == states.idle:
		match sprite_direction:
			"Left":
				sprite.play("idle_side")
				sprite.flip_h = true
			"Right":
				sprite.play("idle_side")
				sprite.flip_h = false
			"Up":
				sprite.play("idle_up")
			"Down":
				sprite.play("idle_down")
	
	if current_state == states.walk:
		match sprite_direction:
			"Left":
				sprite.play("walk_side")
				sprite.flip_h = true
			"Right":
				sprite.play("walk_side")
				sprite.flip_h = false
			"Up":
				sprite.play("walk_up")
			"Down":
				sprite.play("walk_down")
