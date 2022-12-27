extends Control

@onready var gamebus = get_node("/root/gamebus")

func _on_tutorial_pressed():
	gamebus.play_tutorial = !gamebus.play_tutorial
