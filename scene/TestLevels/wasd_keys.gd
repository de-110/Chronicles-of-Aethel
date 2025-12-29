extends Node2D

@onready var w_key = $player/Camera2D/Node2D/w_key
@onready var s_key = $player/Camera2D/Node2D/s_key
@onready var a_key = $player/Camera2D/Node2D/a_key
@onready var d_key = $player/Camera2D/Node2D/d_key

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_up"):
		w_key.add_theme_color_override("font_color", Color.RED)
	elif event.is_action_released("ui_up"):
		w_key.remove_theme_color_override("font_color")
	if event.is_action_pressed("ui_down"):
		s_key.add_theme_color_override("font_color", Color.RED)
	elif event.is_action_released("ui_down"):
		s_key.remove_theme_color_override("font_color")
	if event.is_action_pressed("ui_left"):
		a_key.add_theme_color_override("font_color", Color.RED)
	elif event.is_action_released("ui_left"):
		a_key.remove_theme_color_override("font_color")
	if event.is_action_pressed("ui_right"):
		d_key.add_theme_color_override("font_color", Color.RED)
	elif event.is_action_released("ui_right"):
		d_key.remove_theme_color_override("font_color")
	
