extends CharacterBody2D

@onready var sprite = $AnimatedSprite2D

@export var movement_speed: float = 250
var character_direction: Vector2
var sprite_direction= "Down": get = get_sprite_direction

enum states {idle, walk, attack}
var current_state: states

@export var player_damage: float = 1.0

func _ready():
	current_state = states.idle

func _physics_process(_delta: float) -> void:
	player_movement()
	player_attack()
	
	update_sprite_animation()
	print(current_state)
	
func player_attack():
	var attack = Input.is_action_just_pressed("player_attack")
	if attack:
		current_state = states.attack
		$attack_cooldown.start()

func _on_attack_cooldown_timeout() -> void:
	current_state = states.idle

func player_movement():
	character_direction.x = Input.get_axis("ui_left", "ui_right")
	character_direction.y = Input.get_axis("ui_up", "ui_down")
	character_direction = character_direction.normalized()
	
	if current_state == states.attack: return
	
	if character_direction:
		velocity = character_direction * movement_speed
		current_state = states.walk
	else:
		velocity = velocity.move_toward(Vector2.ZERO, movement_speed)
		current_state = states.idle
	move_and_slide()

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

func update_sprite_animation():
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
	elif current_state == states.walk:
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
	elif current_state == states.attack:
		match sprite_direction:
			"Left":
				sprite.play("attack_side")
				sprite.flip_h = true
			"Right":
				sprite.play("attack_side")
				sprite.flip_h = false
			"Up":
				sprite.play("attack_up")
			"Down":
				sprite.play("attack_down")
		
		
