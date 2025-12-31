extends CharacterBody2D

@onready var enemy_sprite = $Sprite2D/AnimationPlayer

@export var target:Node2D

var health: float = 5.0
const SPEED = 100.0
var direction: Vector2

var player_detected: bool = false
var player_in_attack_range: bool = false

var knockback: Vector2 = Vector2.ZERO
var knockback_timer: float = 0.0

func _ready() -> void:
	add_to_group("enemy")

func _physics_process(delta: float) -> void:
	if knockback_timer > 0.0:
		velocity = knockback
		knockback_timer -= delta
		if knockback_timer <= 0.0:
			knockback = Vector2.ZERO 
	else:
		_movement()
	if !player_in_attack_range:	
		move_and_slide()

func _movement():
	if player_detected:
		direction = (target.global_position - global_position).normalized()
		velocity = direction * SPEED

func apply_knockback(direction, force: float, knockback_duration: float):
	knockback = direction * force
	knockback_timer = knockback_duration

func _on_area_2d_body_entered(body: Node2D) -> void:
		if body.is_in_group("player"):
			target = body
			player_detected = true
			$Timer.stop()

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player") and health != 0:
			$Timer.start()

func take_damage(player_damage: float, body: Node2D):
	enemy_sprite.play("take_damage")
	health -= player_damage
	
	var knockback_direction = (global_position - body.global_position).normalized()
	apply_knockback(knockback_direction, 500.0, 0.12)
	
	if health <= 0.0:
		$Timer.stop()
		queue_free()
	
func _on_attack_range_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_attack_range = true

func _on_attack_range_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_attack_range = false

func _on_timer_timeout() -> void:
	player_detected = false
