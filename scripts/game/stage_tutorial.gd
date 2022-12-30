extends StageBuilder

var flat_scene = preload("res://scenes/game_scene/platforms/flat.tscn")
var stair_scene = preload("res://scenes/game_scene/platforms/stair.tscn")
var gap_scene = preload("res://scenes/game_scene/platforms/gap.tscn")
var portal_scene = preload("res://scenes/game_scene/platforms/portal.tscn")

var firework_scene = preload("res://scenes/game_scene/items/firework.tscn")
var coin_scene = preload("res://scenes/game_scene/items/coin.tscn")
var notification_scene = preload("res://scenes/game_scene/items/notification.tscn")

@onready var gamebus = get_node("/root/gamebus")

func _ready():
	gamebus.portal_entered.connect(_on_portal_entered)
	tutorial()
	
func tutorial():
	for __ in range(5):
		add_platform_to_path(flat_scene, Directions.straight, 2)
	
	var p1 = add_platform_to_path(flat_scene, Directions.straight, 2)
	add_item_to_path(notification_scene, p1.get_node("spawns").get_child(0))
	
	add_platform_to_path(flat_scene, Directions.left, 2)
	for __ in range(3):
		add_platform_to_path(flat_scene, Directions.straight, 2)
		
	var p5 = add_platform_to_path(flat_scene, Directions.straight, 2)
	add_item_to_path(notification_scene, p5.get_node("spawns").get_child(0))
	
	for __ in range(3):
		add_platform_to_path(flat_scene, Directions.straight, 2)
	
	var p4 = add_platform_to_path(flat_scene, Directions.straight, 2)
	add_item_to_path(notification_scene, p4.get_node("spawns").get_child(0))
	
	add_platform_to_path(flat_scene, Directions.right, 1)
	
	for __ in range(3):
		var p2 =add_platform_to_path(flat_scene, Directions.straight, 1)
		for i in p2.get_node("spawns").get_children():
			add_item_to_path(coin_scene, i)
	
	add_platform_to_path(stair_scene, Directions.straight, 1)
	
	var p3 = add_platform_to_path(flat_scene, Directions.straight, 1)
	add_item_to_path(firework_scene, p3.get_node("spawns").get_child(0))
	
	add_platform_to_path(flat_scene, Directions.straight, 1)
	add_platform_to_path(gap_scene, Directions.straight, 1)
	add_platform_to_path(flat_scene, Directions.straight, 1)
	add_platform_to_path(portal_scene, Directions.straight, 1)


func _on_portal_entered():
	gamebus.stage_number += 1
