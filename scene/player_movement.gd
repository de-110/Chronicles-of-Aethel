extends CharacterBody2D

@export var movement_speed : float = 500
var character_direction : Vector2
var current_look_dir = "right"

var can_slash: bool = true
@export var slash_time: float = 0.1
@export var sword_return_time: float = 0.5
@export var weapon_damage: float = 1.0

func _physics_process(_delta: float) -> void:
	character_direction.x = Input.get_axis("ui_left", "ui_right")
	character_direction.y = Input.get_axis("ui_up", "ui_down")
	character_direction = character_direction.normalized()

	if character_direction:
		velocity = character_direction * movement_speed
	else:
		velocity = velocity.move_toward(Vector2.ZERO, movement_speed)
	move_and_slide()
	
	if current_look_dir == "right" and get_global_mouse_position().x > global_position.x:
		$Sprite2D/flip_anim.play("look-left")
		current_look_dir = "left"
	elif current_look_dir == "left" and get_global_mouse_position().x < global_position.x:
		$Sprite2D/flip_anim.play("look-right")
		current_look_dir = "right"
	
	if get_global_mouse_position().y > global_position.y:
		$Sprite2D/weapon.show_behind_parent = false
	else:
		$Sprite2D/weapon.show_behind_parent = true
	
	if Input.is_action_just_pressed("player_attack") and can_slash:
		$Sprite2D/weapon/AnimationPlayer.speed_scale = $Sprite2D/weapon/AnimationPlayer.get_animation("slash").length / slash_time
		$Sprite2D/weapon/AnimationPlayer.play("slash")
		spawn_slash()
		can_slash = false
	
	if Input.is_action_just_pressed("player_dash"):
		player_dash()

const sword_slash_preload = preload("res://scene/sword_slash.tscn")
func spawn_slash():
	var sword_slash_var = sword_slash_preload.instantiate()
	sword_slash_var.global_position = global_position
	sword_slash_var.get_node("Sprite2D/AnimationPlayer").speed_scale = sword_slash_var.get_node("Sprite2D/AnimationPlayer").get_animation("slash").length / slash_time
	sword_slash_var.get_node("Sprite2D").flip_v = false if get_global_mouse_position().x > global_position.x else true
	get_parent().add_child(sword_slash_var)

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "slash" and can_slash == false:
		$Sprite2D/weapon/AnimationPlayer.speed_scale = $Sprite2D/weapon/AnimationPlayer.get_animation("sword_return").length / sword_return_time
		$Sprite2D/weapon/AnimationPlayer.play("sword_return")
	else:
		can_slash = true
	
func player_dash():
	movement_speed = movement_speed * 5
	$Timer.start()

func _on_timer_timeout() -> void:
	movement_speed = 500
