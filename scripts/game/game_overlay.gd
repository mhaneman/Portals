extends Control

@onready var gamebus = get_node("/root/gamebus")
@onready var coins = get_node("coins")
@onready var fireworks = get_node("fireworks")

func _process(delta):
	coins.text = "coins: " + str(gamebus.current_collected_coins)
	fireworks.text = "fireworks: " + str(gamebus.collected_fireworks)
