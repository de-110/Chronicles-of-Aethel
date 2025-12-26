extends CharacterBody2D

@onready var enemy_sprite = $Sprite2D/AnimationPlayer

var health: float = 3.0

func _ready() -> void:
	add_to_group("enemy")

func take_damage(player_damage: float):
	enemy_sprite.play("take_damage")
	health -= player_damage
	
	if health <= 0.0:
		queue_free()
	
