extends CharacterBody2D

const SPEED = 100.0
@export var target:Node2D
var player_detected: bool = false
var animation : AnimatedSprite2D

func _physics_process(delta: float) -> void:
	if player_detected:
		var direction = (target.global_position - global_position).normalized()
		velocity = direction * SPEED
		
		move_and_slide()

func _on_area_2d_body_entered(body: Node2D) -> void:
	player_detected = true
	print("fouunddd youuuu")

func _on_area_2d_body_exited(body: Node2D) -> void:
	player_detected = false
	print("wer u at nigga")
