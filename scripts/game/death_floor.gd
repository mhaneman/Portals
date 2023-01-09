extends Area3D

@onready var gamebus = get_node("/root/gamebus")

func _on_body_entered(_body):
	gamebus.stage_number = 1
	gamebus.base_scale = gamebus.INIT_PLAT_SIZE
	get_tree().change_scene_to_file("res://scenes/menu_scene/menu.tscn")
