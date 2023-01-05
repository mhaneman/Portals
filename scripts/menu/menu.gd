extends Node3D

@onready var gamebus = get_node("/root/gamebus")

func _ready():
	gamebus.portal_entered.connect(_on_portal_entered)
	
func _on_portal_entered():
	get_tree().change_scene_to_file("res://scenes/game_scene/game.tscn")
	
