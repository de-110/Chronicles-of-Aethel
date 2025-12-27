extends CharacterBody2D

@onready var sprite = $AnimatedSprite2D

@export var movement_speed: float = 200.0
var character_direction: Vector2
var sprite_direction= "Down": get = get_sprite_direction
var last_direction: Vector2 = Vector2.DOWN

enum states {idle, walk, attack}
var current_state: states

var player_damage: float = 1.0

var dash_cooldown: bool = false

func _ready():
	current_state = states.idle

func _physics_process(_delta: float) -> void:
	player_movement()
	player_attack()
	
	update_sprite_animation()
	
func player_attack():
	var attack = Input.is_action_just_pressed("player_attack")
	if attack and current_state != states.attack:
		current_state = states.attack
		spawn_slash()
		$attack_cooldown.start()

func _on_attack_cooldown_timeout() -> void:
	current_state = states.idle

const slash_preload = preload("res://scene/slash.tscn")
func spawn_slash():
	var slash_var = slash_preload.instantiate()
	if last_direction == Vector2.UP:
		slash_var.position = last_direction * 25
	elif last_direction == Vector2.DOWN:
		slash_var.position = last_direction * 5
	elif last_direction == Vector2.LEFT:
		slash_var.position = last_direction * 14
		slash_var.rotation_degrees = 90
	elif last_direction == Vector2.RIGHT:
		slash_var.position = last_direction * 20
		slash_var.rotation_degrees = 90
	add_child(slash_var)
		
func player_movement():
	if current_state == states.attack: return
	character_direction.x = Input.get_axis("ui_left", "ui_right")
	character_direction.y = Input.get_axis("ui_up", "ui_down")
	character_direction = character_direction.normalized()
	
	if character_direction != Vector2.ZERO:
		velocity = character_direction * movement_speed
		last_direction = character_direction
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

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("player_dash") and dash_cooldown != true:
		player_dash()

func player_dash():
	if character_direction == Vector2.ZERO: return
	movement_speed = movement_speed * 3
	$dash_particles.emitting = true
	$dash_duration.start()
	_on_dash_cooldown()
		
func _on_dash_duration_timeout() -> void:
	$dash_particles.emitting = false
	movement_speed = 200

func _on_dash_cooldown():
	dash_cooldown = true
	$dash_cooldown.start()
	
func _on_dash_cooldown_timeout() -> void:
	dash_cooldown = false
