extends Control

@onready var gamebus = get_node("/root/gamebus")
@onready var coins = get_node("coins")
@onready var fireworks = get_node("fireworks")
@onready var level = get_node("level")

func _process(_delta):
	coins.text = "coins: " + str(gamebus.current_collected_coins)
	fireworks.text = "fireworks: " + str(gamebus.collected_fireworks)
	level.text = "level: " + str(gamebus.stage_number)
