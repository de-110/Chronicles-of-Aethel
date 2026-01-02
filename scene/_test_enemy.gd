extends CharacterBody2D

@onready var enemy_sprite = $Sprite2D/AnimationPlayer
@export var target: Node2D 


const SPEED = 100.0
@export var attack_range: float = 50.0 
@export var attack_damage: int = 2
@export var attack_cooldown: float = 1.5


var player_detected: bool = false
var can_attack: bool = true
var health: float = 3.0

func _ready() -> void:
	add_to_group("enemy")

func _physics_process(_delta: float) -> void:
	if not player_detected or target == null:
		velocity = Vector2.ZERO
		return


	var distance_to_player = global_position.distance_to(target.global_position)

	if distance_to_player <= attack_range:
		velocity = Vector2.ZERO
		if can_attack:
			perform_attack()
	else:

		var direction = (target.global_position - global_position).normalized()
		velocity = direction * SPEED
		
		if direction.x < 0:
			$Sprite2D.flip_h = true
		else:
			$Sprite2D.flip_h = false
			
		move_and_slide()

func perform_attack():
	can_attack = false
	print("atak")
	
	if target.has_method("take_damage"):
		target.take_damage(attack_damage)
	
	
	await get_tree().create_timer(attack_cooldown).timeout
	
	can_attack = true

func take_damage(damage_amount: float):
	if enemy_sprite and enemy_sprite.has_animation("take_damage"):
		enemy_sprite.play("take_damage")
		print("Ouch")
	
	health -= damage_amount
	if health <= 0.0:
		queue_free()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		player_detected = true
		target = body 

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body == target:
		player_detected = false
