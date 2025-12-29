extends CharacterBody2D

@onready var enemy_sprite = $Sprite2D/AnimationPlayer

var health: float = 99.0
const SPEED = 100.0
@export var target:Node2D
var player_detected: bool = false
var player_in_attack_range: bool = false

func _ready() -> void:
	add_to_group("enemy")

func _physics_process(_delta: float) -> void:
	print(player_detected)
	if player_detected:
		if !player_in_attack_range:
			var direction = (target.global_position - global_position).normalized()
			velocity = direction * SPEED
			move_and_slide()
		else:
			pass

func _on_area_2d_body_entered(body: Node2D) -> void:
		if body.is_in_group("player"):
			target = body
			player_detected = true
			$Timer.stop()

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
			$Timer.start()

func take_damage(player_damage: float):
	enemy_sprite.play("take_damage")
	health -= player_damage
	
	if health <= 0.0:
		queue_free()
	
func _on_attack_range_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_attack_range = true

func _on_attack_range_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_attack_range = false

func _on_timer_timeout() -> void:
	player_detected = false
