extends CharacterBody2D

const SPEED = 100.0
@export var target:Node2D



func _physics_process(delta: float) -> void:
	var direction = (target.global_position - global_position).normalized()
	velocity = direction * SPEED
	move_and_slide()
