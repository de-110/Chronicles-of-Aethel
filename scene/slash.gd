extends Node2D

var player_damage: float = 1.0

func _ready():
	$Timer.start()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		body.take_damage(player_damage)

func _on_timer_timeout() -> void:
	queue_free()
